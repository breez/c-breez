use crate::crypto::*;
use crate::hsmd::*;
use crate::invoice::*;
use anyhow::Result;
use lightning_invoice::RawInvoice;

pub fn init_hsmd(storage_path: String, secret: Vec<u8>) -> Result<Vec<u8>> {
 let mut private_key_slice: [u8; 32] = [0; 32];
 private_key_slice.copy_from_slice(&secret[0..32]);
 _new_hsmd(private_key_slice, &storage_path).map(|hsmd| hsmd.init)
}

pub fn encrypt(key: Vec<u8>, msg: Vec<u8>) -> Result<Vec<u8>> {
 _encrypt(key, msg)
}

pub fn decrypt(key: Vec<u8>, msg: Vec<u8>) -> Result<Vec<u8>> {
 _decrypt(key, msg)
}

pub fn parse_invoice(invoice: String) -> Result<LNInvoice> {
 return _parse_invoice(&invoice);
}

pub fn node_pubkey(storage_path: String, secret: Vec<u8>) -> Result<Vec<u8>> {
 let mut private_key_slice: [u8; 32] = [0; 32];
 private_key_slice.copy_from_slice(&secret[0..32]);
 _new_hsmd(private_key_slice, &storage_path).map(|h| h.node_pubkey())
}

pub fn add_routing_hints(
 storage_path: String,
 secret: Vec<u8>,
 invoice: String,
 hints: Vec<RouteHint>,
) -> Result<String> {
 let mut private_key_slice: [u8; 32] = [0; 32];
 private_key_slice.copy_from_slice(&secret[0..32]);
 let hsmd = _new_hsmd(private_key_slice, &storage_path)?;
 // create a new raw (not signed) invoice with the new routing hints
 let raw_invoice: RawInvoice = _add_routing_hints(&invoice, hints)?;
 hsmd.handle_sign_invoice(raw_invoice)
}

pub fn sign_message(storage_path: String, secret: Vec<u8>, msg: Vec<u8>) -> Result<Vec<u8>> {
 let mut private_key_slice: [u8; 32] = [0; 32];
 private_key_slice.copy_from_slice(&secret[0..32]);
 let hsmd = _new_hsmd(private_key_slice, &storage_path)?;
 hsmd.handle_sign_message(msg)
}

pub fn handle(
 storage_path: String,
 secret: Vec<u8>,
 msg: Vec<u8>,
 peer_id: Option<Vec<u8>>,
 db_id: u64,
) -> Result<Vec<u8>> {
 let mut private_key_slice: [u8; 32] = [0; 32];
 private_key_slice.copy_from_slice(&secret[0..32]);
 match _new_hsmd(private_key_slice, &storage_path) {
  Ok(hsmd) => hsmd.handle(msg, peer_id, db_id),
  Err(err) => Err(err),
 }
}
