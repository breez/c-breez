use anyhow::{anyhow, Result};
use bip21::Uri;
use std::str::FromStr;

use crate::input_parser::InputType::{BitcoinAddress, Bolt11};
use crate::invoice::{parse_invoice, LNInvoice};

/// Parses generic user input, typically pasted from clipboard or scanned from a QR
pub fn parse(raw_input: &str) -> Result<InputType> {
    // If the `lightning:` prefix is there, strip it for the bolt11 parsing function
    let prepared_input = raw_input.trim_start_matches("lightning:");

    // Check if valid BTC onchain address
    if let Ok(addr) = bitcoin::Address::from_str(prepared_input) {
        return Ok(BitcoinAddress(BitcoinAddressData {
            address: prepared_input.into(),
            network: addr.network.into(),
            amount_sat: None,
            label: None,
            message: None,
        }));
    }
    // Check if valid BTC onchain address (BIP21)
    else if let Ok(uri) = prepared_input.parse::<Uri<'_>>() {
        let bitcoin_addr_data = BitcoinAddressData {
            address: uri.address.to_string(),
            network: uri.address.network.into(),
            amount_sat: uri.amount.map(|a| a.to_sat()),
            label: uri.label.map(|label| label.try_into().unwrap()),
            message: uri.message.map(|msg| msg.try_into().unwrap()),
        };

        // Special case of LN BOLT11 with onchain fallback
        // Search for the `lightning=bolt11` param in the BIP21 URI and, if found, extract the bolt11
        let invoice_param: Option<LNInvoice> = prepared_input
            .split(|c| c == '?' || c == '&')
            .collect::<Vec<&str>>()
            .iter()
            .find(|x| x.starts_with("lightning="))
            .map(|x| x.trim_start_matches("lightning="))
            .map(parse_invoice)
            .transpose()?;

        return match invoice_param {
            None => Ok(BitcoinAddress(bitcoin_addr_data)),
            Some(invoice) => Ok(Bolt11(invoice)),
        };
    } else if let Ok(invoice) = parse_invoice(prepared_input) {
        return Ok(Bolt11(invoice));
    }
    // TODO Parse the other InputTypes

    Err(anyhow!("Unrecognized input type"))
}

pub enum InputType {
    BitcoinAddress(BitcoinAddressData),
    /// Also covers URIs like `bitcoin:...&lightning=bolt11`. In this case, it returns the BOLT11
    /// and discards all other data.
    Bolt11(LNInvoice),
    NodeId(String),
    Url(String),
    LnUrlPay(String),
    LnUrlWithdraw(String),
}

pub struct BitcoinAddressData {
    pub address: String,
    pub network: crate::models::Network,
    pub amount_sat: Option<u64>,
    pub label: Option<String>,
    pub message: Option<String>,
}

#[cfg(test)]
mod tests {
    use anyhow::anyhow;
    use anyhow::Result;

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
            InputType::BitcoinAddress(_)
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
            InputType::BitcoinAddress(addr_with_amount_parsed) => {
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
            InputType::BitcoinAddress(addr_with_amount_parsed) => {
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
            InputType::BitcoinAddress(addr_with_amount_parsed) => {
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
        assert!(matches!(parse(bolt11)?, InputType::Bolt11(_invoice)));

        // Invoice with prefix
        let invoice_with_prefix = format!("lightning:{}", bolt11);
        assert!(matches!(
            parse(&invoice_with_prefix)?,
            InputType::Bolt11(_invoice)
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
        assert!(matches!(parse(&addr_1)?, InputType::Bolt11(_invoice)));

        // Address, amount and invoice
        // BOLT11 is not the first URI arg (preceded by '&')
        let addr_2 = format!("bitcoin:{}?amount=0.00002000&lightning={}", addr, bolt11);
        assert!(matches!(parse(&addr_2)?, InputType::Bolt11(_invoice)));

        Ok(())
    }
}
