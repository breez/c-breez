use anyhow::Result;

use crate::input_parser::InputType::BitcoinAddress;

/// Parses generic user input, typically pasted from clipboard or scanned from a QR
pub fn parse(s: &str) -> Result<InputType> {
    Ok(BitcoinAddress("test".into()))
}

pub enum InputType {
    BitcoinAddress(String),
    Bolt11(String),
    NodeId(String),
    Url(String),
    LnUrlPay(String),
    LnUrlWithdraw(String),
}
