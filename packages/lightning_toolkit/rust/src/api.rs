use crate::hsmd::*;
use crate::invoice::*;
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

pub fn handle(
 secret: Vec<u8>,
 msg: Vec<u8>,
 peer_id: Option<Vec<u8>>,
 db_id: u64,
) -> Result<Vec<u8>> {
 let mut private_key_slice: [u8; 32] = [0; 32];
 private_key_slice.copy_from_slice(&secret[0..32]);
 match _new_hsmd(private_key_slice) {
  Ok(hsmd) => hsmd.handle(msg, peer_id, db_id),
  Err(err) => Err(err),
 }
}
