use crate::invoice::*;
use crate::hsmd::*;
use anyhow::Result;

pub fn parse_invoice(invoice: String) -> Result<LNInvoice> {
 return _parse_invoice(&invoice);
}

pub fn add_routing_hints(
 invoice: String,
 hints: Vec<RouteHint>,
 private_key: Vec<u8>,
) -> Result<String> {
 let mut private_key_slice: [u8; 32] = Default::default();
 private_key_slice.copy_from_slice(&private_key[0..32]);
 return _add_routing_hints(&invoice, hints, &private_key_slice);
}

pub fn hsmd_handle(hexsecret: String, hexmessage: String) -> String {
    return _handle(hexsecret, hexmessage);
}
