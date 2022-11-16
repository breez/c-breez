use anyhow::{anyhow, Result};
use bip21::Uri;
use bitcoin::Network;

use crate::input_parser::InputType::{BitcoinAddress, Bolt11, Bolt11WithOnchainFallback};
use crate::invoice::{parse_invoice, LNInvoice};

/// Parses generic user input, typically pasted from clipboard or scanned from a QR
pub fn parse(s: &str) -> Result<InputType> {
    // Variants of the user input, with or without certain prefixes, which we consider for parsing
    // This lets us detect the input type even when the correct prefix is missing
    let variants = vec![
        // Raw user input
        // We try to parse it directly, in case it is already formatted correctly
        s.into(),
        // The bip21 crate, used for parsing bitcoin addresses, expects a `bitcoin:` prefix
        // To cover the case when the user input doesn't have it, we explicitly add it to have a valid bip21 string
        format!("bitcoin:{}", s),
        // The BOLT11 parsing works directly on a bolt11 string, without a prefix
        // For the case when the user input has the `lightning:` prefix, we strip it to have the right input for the bolt11 parsing function
        s.strip_prefix("lightning:").unwrap_or_default().into(),
    ];

    for val in variants {
        // Check if valid BTC onchain address
        if let Ok(uri) = val.parse::<Uri<'_>>() {
            let bitcoin_addr_data = BitcoinAddressData {
                address: uri.address.to_string(),
                network: match uri.address.network {
                    Network::Bitcoin => crate::models::Network::Bitcoin,
                    Network::Testnet => crate::models::Network::Testnet,
                    Network::Signet => crate::models::Network::Signet,
                    Network::Regtest => crate::models::Network::Regtest,
                },
                amount_sat: uri.amount.map(|a| a.to_sat()),
                label: uri.label.map(|label| label.try_into().unwrap()),
                message: uri.message.map(|msg| msg.try_into().unwrap()),
            };

            // Special case of LN BOLT11 with onchain fallback
            let mut invoice_param: Option<LNInvoice> = None;
            if val.starts_with("bitcoin:") && val.contains("lightning=") {
                if let Some(pos) = val.find('?') {
                    let params = &val[(pos + 1)..];
                    if let Some(ln_param) = params.split('&').find(|&p| p.starts_with("lightning="))
                    {
                        if let Some(eq_pos) = ln_param.find('=') {
                            let bolt11_raw = ln_param[(eq_pos + 1)..].to_string();

                            invoice_param = parse_invoice(&bolt11_raw).map(Some)?;
                        }
                    }
                }
            }

            return Ok(match invoice_param {
                None => BitcoinAddress(bitcoin_addr_data),
                Some(invoice) => Bolt11WithOnchainFallback(invoice, bitcoin_addr_data),
            });
        } else if let Ok(invoice) = parse_invoice(&val) {
            return Ok(Bolt11(invoice));
        }
        // TODO Parse the other InputTypes
    }
    Err(anyhow!("Unrecognized input type"))
}

pub enum InputType {
    BitcoinAddress(BitcoinAddressData),
    Bolt11(LNInvoice),
    /// Covers URIs like `bitcoin:...&lightning=bolt11` described in BOLT11:
    ///
    /// > "If a URI scheme is desired, the current recommendation is to either use 'lightning:'
    /// as a prefix before the BOLT-11 encoding (note: not 'lightning://'), or for fallback to
    /// Bitcoin payments, to use 'bitcoin:', as per BIP-21, with the key 'lightning' and the value
    /// equal to the BOLT-11 encoding."
    ///
    /// https://github.com/lightning/bolts/blob/master/11-payment-encoding.md#encoding-overview
    Bolt11WithOnchainFallback(LNInvoice, BitcoinAddressData),
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
        // Addresses from https://github.com/Kixunil/bip21/blob/master/src/lib.rs

        // Valid address but without prefix
        assert!(parse("1andreas3batLhQa2FawWjeyjCqyBzypd").is_ok());
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
        match parse(bolt11)? {
            InputType::Bolt11(_invoice) => {}
            _ => return Err(anyhow!("Invalid type parsed")),
        }

        // Invoice with prefix
        let invoice_with_prefix = format!("lightning:{}", bolt11);
        match parse(&invoice_with_prefix)? {
            InputType::Bolt11(_invoice) => {}
            _ => return Err(anyhow!("Invalid type parsed")),
        }

        Ok(())
    }

    #[test]
    fn test_bolt11_with_fallback_bitcoin_address() -> Result<()> {
        let addr = "1andreas3batLhQa2FawWjeyjCqyBzypd";
        let bolt11 = "lnbc110n1p38q3gtpp5ypz09jrd8p993snjwnm68cph4ftwp22le34xd4r8ftspwshxhmnsdqqxqyjw5qcqpxsp5htlg8ydpywvsa7h3u4hdn77ehs4z4e844em0apjyvmqfkzqhhd2q9qgsqqqyssqszpxzxt9uuqzymr7zxcdccj5g69s8q7zzjs7sgxn9ejhnvdh6gqjcy22mss2yexunagm5r2gqczh8k24cwrqml3njskm548aruhpwssq9nvrvz";

        // Address and invoice
        let addr_1 = format!("bitcoin:{}?lightning={}", addr, bolt11);
        match parse(&addr_1)? {
            InputType::Bolt11WithOnchainFallback(_invoice, btc_data) => {
                assert_eq!(btc_data.address, addr);
                assert_eq!(btc_data.network, Network::Bitcoin);
                assert_eq!(btc_data.amount_sat, None);
                assert_eq!(btc_data.label, None);
                assert_eq!(btc_data.message, None);
            }
            _ => return Err(anyhow!("Invalid type parsed")),
        }

        // Address, amount and invoice
        let addr_2 = format!("bitcoin:{}?amount=0.00002000&lightning={}", addr, bolt11);
        match parse(&addr_2)? {
            InputType::Bolt11WithOnchainFallback(_invoice, btc_data) => {
                assert_eq!(btc_data.address, addr);
                assert_eq!(btc_data.network, Network::Bitcoin);
                assert_eq!(btc_data.amount_sat, Some(2000));
                assert_eq!(btc_data.label, None);
                assert_eq!(btc_data.message, None);
            }
            _ => return Err(anyhow!("Invalid type parsed")),
        }

        Ok(())
    }
}
