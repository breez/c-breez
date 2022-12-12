use std::str::FromStr;

use anyhow::{anyhow, Result};
use bip21::Uri;

use crate::input_parser::InputType::*;
use crate::invoice::{parse_invoice, LNInvoice};

/// Parses generic user input, typically pasted from clipboard or scanned from a QR
pub fn parse(raw_input: &str) -> Result<InputType> {
    // If the `lightning:` prefix is there, strip it for the bolt11 parsing function
    let prepared_input = raw_input.trim_start_matches("lightning:");

    // Check if valid BTC onchain address
    // For simple addresses, it prepends the "bitcoin:" prefix, thus converting it to a BIP21 URI
    // If it already has that prefix, it keeps it. In both cases, it tries to parse it as a BIP 21 URI
    if let Ok(uri) =
        format!("bitcoin:{}", prepared_input.trim_start_matches("bitcoin:")).parse::<Uri<'_>>()
    {
        let bitcoin_addr_data = uri.into();

        // Special case of LN BOLT11 with onchain fallback
        // Search for the `lightning=bolt11` param in the BIP21 URI and, if found, extract the bolt11
        let mut invoice_param: Option<LNInvoice> = None;
        if let Some(query) = prepared_input.split('?').collect::<Vec<_>>().get(1) {
            invoice_param = querystring::querify(query)
                .iter()
                .find(|(key, _)| key == &"lightning")
                .map(|(_, value)| parse_invoice(value))
                .transpose()?;
        }

        return match invoice_param {
            None => Ok(BitcoinAddress {
                data: bitcoin_addr_data,
            }),
            Some(invoice) => Ok(Bolt11 { invoice }),
        };
    }

    if let Ok(invoice) = parse_invoice(prepared_input) {
        return Ok(Bolt11 { invoice });
    }

    if let Ok(_node_id) = bitcoin::secp256k1::PublicKey::from_str(prepared_input) {
        // Public key serialized in compressed form
        return Ok(NodeId {
            node_id: prepared_input.into(),
        });
    }

    if let Ok(url) = reqwest::Url::parse(prepared_input) {
        if ["http", "https"].contains(&url.scheme()) {
            return Ok(Url {
                url: prepared_input.into(),
            });
        }
    }
    // TODO Parse the other InputTypes

    Err(anyhow!("Unrecognized input type"))
}

pub enum InputType {
    BitcoinAddress {
        data: BitcoinAddressData,
    },
    /// Also covers URIs like `bitcoin:...&lightning=bolt11`. In this case, it returns the BOLT11
    /// and discards all other data.
    Bolt11 {
        invoice: LNInvoice,
    },
    NodeId {
        node_id: String,
    },
    Url {
        url: String,
    },
    LnUrlPay {
        lnurl: String,
    },
    LnUrlWithdraw {
        lnurl: String,
    },
}

pub struct BitcoinAddressData {
    pub address: String,
    pub network: crate::models::Network,
    pub amount_sat: Option<u64>,
    pub label: Option<String>,
    pub message: Option<String>,
}

impl From<Uri<'_>> for BitcoinAddressData {
    fn from(uri: Uri) -> Self {
        BitcoinAddressData {
            address: uri.address.to_string(),
            network: uri.address.network.into(),
            amount_sat: uri.amount.map(|a| a.to_sat()),
            label: uri.label.map(|label| label.try_into().unwrap()),
            message: uri.message.map(|msg| msg.try_into().unwrap()),
        }
    }
}

#[cfg(test)]
mod tests {
    use anyhow::anyhow;
    use anyhow::Result;
    use bitcoin::secp256k1::{PublicKey, Secp256k1, SecretKey};

    use crate::input_parser::{parse, InputType};
    use crate::models::Network;

    #[test]
    fn test_generic_invalid_input() -> Result<(), Box<dyn std::error::Error>> {
        assert!(parse("invalid_input").is_err());

        Ok(())
    }

    #[test]
    fn test_bitcoin_address() -> Result<()> {
        assert!(matches!(
            parse("1andreas3batLhQa2FawWjeyjCqyBzypd")?,
            InputType::BitcoinAddress { data: _ }
        ));

        Ok(())
    }

    #[test]
    fn test_bitcoin_address_bip21() -> Result<()> {
        // Addresses from https://github.com/Kixunil/bip21/blob/master/src/lib.rs

        // Valid address with the `bitcoin:` prefix
        assert!(parse("bitcoin:1andreas3batLhQa2FawWjeyjCqyBzypd").is_ok());
        assert!(parse("bitcoin:testinvalidaddress").is_err());

        let addr = "1andreas3batLhQa2FawWjeyjCqyBzypd";

        // Address with amount
        let addr_1 = format!("bitcoin:{}?amount=0.00002000", addr);
        match parse(&addr_1)? {
            InputType::BitcoinAddress {
                data: addr_with_amount_parsed,
            } => {
                assert_eq!(addr_with_amount_parsed.address, addr);
                assert_eq!(addr_with_amount_parsed.network, Network::Bitcoin);
                assert_eq!(addr_with_amount_parsed.amount_sat, Some(2000));
                assert_eq!(addr_with_amount_parsed.label, None);
                assert_eq!(addr_with_amount_parsed.message, None);
            }
            _ => return Err(anyhow!("Invalid type parsed")),
        }

        // Address with amount and label
        let label = "test-label";
        let addr_2 = format!("bitcoin:{}?amount=0.00002000&label={}", addr, label);
        match parse(&addr_2)? {
            InputType::BitcoinAddress {
                data: addr_with_amount_parsed,
            } => {
                assert_eq!(addr_with_amount_parsed.address, addr);
                assert_eq!(addr_with_amount_parsed.network, Network::Bitcoin);
                assert_eq!(addr_with_amount_parsed.amount_sat, Some(2000));
                assert_eq!(addr_with_amount_parsed.label, Some(label.into()));
                assert_eq!(addr_with_amount_parsed.message, None);
            }
            _ => return Err(anyhow!("Invalid type parsed")),
        }

        // Address with amount, label and message
        let message = "test-message";
        let addr_3 = format!(
            "bitcoin:{}?amount=0.00002000&label={}&message={}",
            addr, label, message
        );
        match parse(&addr_3)? {
            InputType::BitcoinAddress {
                data: addr_with_amount_parsed,
            } => {
                assert_eq!(addr_with_amount_parsed.address, addr);
                assert_eq!(addr_with_amount_parsed.network, Network::Bitcoin);
                assert_eq!(addr_with_amount_parsed.amount_sat, Some(2000));
                assert_eq!(addr_with_amount_parsed.label, Some(label.into()));
                assert_eq!(addr_with_amount_parsed.message, Some(message.into()));
            }
            _ => return Err(anyhow!("Invalid type parsed")),
        }

        Ok(())
    }

    #[test]
    fn test_bolt11() -> Result<()> {
        let bolt11 = "lnbc110n1p38q3gtpp5ypz09jrd8p993snjwnm68cph4ftwp22le34xd4r8ftspwshxhmnsdqqxqyjw5qcqpxsp5htlg8ydpywvsa7h3u4hdn77ehs4z4e844em0apjyvmqfkzqhhd2q9qgsqqqyssqszpxzxt9uuqzymr7zxcdccj5g69s8q7zzjs7sgxn9ejhnvdh6gqjcy22mss2yexunagm5r2gqczh8k24cwrqml3njskm548aruhpwssq9nvrvz";

        // Invoice without prefix
        assert!(matches!(
            parse(bolt11)?,
            InputType::Bolt11 { invoice: _invoice }
        ));

        // Invoice with prefix
        let invoice_with_prefix = format!("lightning:{}", bolt11);
        assert!(matches!(
            parse(&invoice_with_prefix)?,
            InputType::Bolt11 { invoice: _invoice }
        ));

        Ok(())
    }

    #[test]
    fn test_bolt11_with_fallback_bitcoin_address() -> Result<()> {
        let addr = "1andreas3batLhQa2FawWjeyjCqyBzypd";
        let bolt11 = "lnbc110n1p38q3gtpp5ypz09jrd8p993snjwnm68cph4ftwp22le34xd4r8ftspwshxhmnsdqqxqyjw5qcqpxsp5htlg8ydpywvsa7h3u4hdn77ehs4z4e844em0apjyvmqfkzqhhd2q9qgsqqqyssqszpxzxt9uuqzymr7zxcdccj5g69s8q7zzjs7sgxn9ejhnvdh6gqjcy22mss2yexunagm5r2gqczh8k24cwrqml3njskm548aruhpwssq9nvrvz";

        // Address and invoice
        // BOLT11 is the first URI arg (preceded by '?')
        let addr_1 = format!("bitcoin:{}?lightning={}", addr, bolt11);
        assert!(matches!(
            parse(&addr_1)?,
            InputType::Bolt11 { invoice: _invoice }
        ));

        // Address, amount and invoice
        // BOLT11 is not the first URI arg (preceded by '&')
        let addr_2 = format!("bitcoin:{}?amount=0.00002000&lightning={}", addr, bolt11);
        assert!(matches!(
            parse(&addr_2)?,
            InputType::Bolt11 { invoice: _invoice }
        ));

        Ok(())
    }

    #[test]
    fn test_url() -> Result<()> {
        assert!(matches!(
            parse("https://breez.technology")?,
            InputType::Url { url: _url }
        ));
        assert!(matches!(
            parse("https://breez.technology/")?,
            InputType::Url { url: _url }
        ));
        assert!(matches!(
            parse("https://breez.technology/test-path")?,
            InputType::Url { url: _url }
        ));
        assert!(matches!(
            parse("https://breez.technology/test-path?arg1=val1&arg2=val2")?,
            InputType::Url { url: _url }
        ));

        Ok(())
    }

    #[test]
    fn test_node_id() -> Result<()> {
        let secp = Secp256k1::new();
        let secret_key = SecretKey::from_slice(&[0xab; 32])?;
        let public_key = PublicKey::from_secret_key(&secp, &secret_key);

        match parse(&public_key.to_string())? {
            InputType::NodeId { node_id } => {
                assert_eq!(node_id, public_key.to_string());
            }
            _ => return Err(anyhow!("Unexpected type")),
        }

        // Other formats and sizes
        assert!(parse("012345678901234567890123456789012345678901234567890123456789mnop").is_err());
        assert!(parse("0123456789").is_err());
        assert!(parse("abcdefghij").is_err());

        Ok(())
    }
}
