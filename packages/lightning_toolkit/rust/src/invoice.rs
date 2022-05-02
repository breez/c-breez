use anyhow::Result;
use hex::ToHex;
use lightning_invoice::*;
use std::time::UNIX_EPOCH;

pub struct LNInvoice {
 pub payee_pubkey: String,
 pub description: String,
 pub amount: Option<u64>,
 pub timestamp: u64,
 pub expiry: u64,
}

// parse_invoice parse a bolt11 payment request and returns a structure contains the parsed fields.
pub fn _parse_invoice(invoice: String) -> Result<LNInvoice> {
 let signed = invoice
  .parse::<SignedRawInvoice>()
  .expect("Missing attribute");
 let invoice = Invoice::from_signed(signed).expect("Missing attribute");

 let since_the_epoch = invoice
  .timestamp()
  .duration_since(UNIX_EPOCH)
  .expect("Missing attribute");

 // make sure signature is valid
 invoice.check_signature().expect("wrong signature");

 // Try to take payee pubkey from the tagged fields, if doesn't exist recover it from the signature
 let payee_pubkey: String = match invoice.payee_pub_key() {
  Some(key) => key.serialize().encode_hex::<String>(),
  None => invoice
   .recover_payee_pub_key()
   .serialize()
   .encode_hex::<String>(),
 };

 // return the parsed invoice
 let ln_invoice = LNInvoice {
  payee_pubkey: payee_pubkey,
  expiry: invoice.expiry_time().as_secs(),
  description: match invoice.description() {
   InvoiceDescription::Direct(msg) => msg.to_string(),
   InvoiceDescription::Hash(_) => String::from(""),
  },
  amount: invoice.amount_milli_satoshis(),
  timestamp: since_the_epoch.as_secs(),
 };
 Ok(ln_invoice)
}
