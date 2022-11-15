use anyhow::Result;

use crate::input_parser::InputType::BitcoinAddress;
use crate::invoice::LNInvoice;

/// Parses generic user input, typically pasted from clipboard or scanned from a QR
pub fn parse(s: &str) -> Result<InputType> {
    Ok(BitcoinAddress("test".into()))
}

pub enum InputType {
    BitcoinAddress(String),
    Bolt11(LNInvoice),
    NodeId(String),
    Url(String),
    LnUrlPay(String),
    LnUrlWithdraw(String),
}
