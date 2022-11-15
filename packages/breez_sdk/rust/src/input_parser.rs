use anyhow::{anyhow, Result};
use bip21::Uri;
use bitcoin::Network;

use crate::input_parser::InputType::BitcoinAddress;
use crate::invoice::LNInvoice;

/// Parses generic user input, typically pasted from clipboard or scanned from a QR
pub fn parse(s: &str) -> Result<InputType> {
    match s.parse::<Uri<'_>>() {
        Ok(uri) => Ok(BitcoinAddress(BitcoinAddressData {
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
        })),
        Err(e) => Err(anyhow!(e)),
    }
    // TODO Parse the other InputTypes
}

pub enum InputType {
    BitcoinAddress(BitcoinAddressData),
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

    use crate::input_parser::{InputType, parse};
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
        assert!(parse("1andreas3batLhQa2FawWjeyjCqyBzypd").is_err());
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
}
