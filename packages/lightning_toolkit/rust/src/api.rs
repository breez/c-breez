use crate::invoice::*;
use crate::hsmd::*;
use anyhow::Result;

pub fn parse_invoice(invoice: String) -> Result<LNInvoice> {
 return _parse_invoice(invoice);
}

pub fn hsmd_handle(hexsecret: String, hexmessage: String) -> String {
    return _handle(hexsecret, hexmessage);
}
