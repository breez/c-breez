use anyhow::{anyhow, Result};
use bip21::Uri;

use crate::input_parser::InputType::BitcoinAddress;
use crate::invoice::LNInvoice;

/// Parses generic user input, typically pasted from clipboard or scanned from a QR
pub fn parse(s: &str) -> Result<InputType> {
    match s.parse::<Uri<'_>>() {
        Ok(uri) => Ok(BitcoinAddress(uri.address.to_string())),
        Err(e) => Err(anyhow!(e)),
    }
    // TODO Parse the other InputTypes
}

pub enum InputType {
    BitcoinAddress(String),
    Bolt11(LNInvoice),
    NodeId(String),
    Url(String),
    LnUrlPay(String),
    LnUrlWithdraw(String),
}

#[cfg(test)]
mod tests {
    use crate::input_parser::parse;

    #[test]
    fn test_generic_invalid_input() -> Result<(), Box<dyn std::error::Error>> {
        assert!(parse("invalid_input").is_err());

        Ok(())
    }

    #[test]
    fn test_bitcoin_address() -> Result<(), Box<dyn std::error::Error>> {
        // Addresses from https://github.com/Kixunil/bip21/blob/master/src/lib.rs

        // Valid address but without prefix
        assert!(parse("1andreas3batLhQa2FawWjeyjCqyBzypd").is_err());
        assert!(parse("bitcoin:1andreas3batLhQa2FawWjeyjCqyBzypd").is_ok());
        assert!(parse("bitcoin:testinvalidaddress").is_err());

        Ok(())
    }
}
