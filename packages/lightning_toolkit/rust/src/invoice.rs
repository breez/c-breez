use anyhow::{anyhow, Result};
use hex::ToHex;
use lightning::routing::*;
use lightning_invoice::*;
use secp256k1::key::PublicKey;
use secp256k1::Secp256k1;
use secp256k1::SecretKey;
use std::str::FromStr;
use std::time::UNIX_EPOCH;

pub struct LNInvoice {
 pub payee_pubkey: String,
 pub payment_hash: String,
 pub description: String,
 pub amount: Option<u64>,
 pub timestamp: u64,
 pub expiry: u64,
 pub routing_hints: Vec<RouteHint>,
}

#[derive(Default, Debug, PartialEq)]
pub struct RouteHintHop {
 /// The node_id of the non-target end of the route
 pub src_node_id: String,
 /// The short_channel_id of this channel
 pub short_channel_id: u64,
 /// The fees which must be paid to use this channel
 pub fees_base_msat: u32,
 pub fees_proportional_millionths: u32,

 /// The difference in CLTV values between this node and the next node.
 pub cltv_expiry_delta: u64,
 /// The minimum value, in msat, which must be relayed to the next hop.
 pub htlc_minimum_msat: Option<u64>,
 /// The maximum value in msat available for routing with a single HTLC.
 pub htlc_maximum_msat: Option<u64>,
}

#[derive(Default, Debug, PartialEq)]
pub struct RouteHint(pub Vec<RouteHintHop>);

impl RouteHint {
 pub fn to_ldk_hint(&self) -> Result<router::RouteHint> {
  let mut hops = Vec::new();
  for hop in self.0.iter() {
   let pubkey_res = PublicKey::from_str(&hop.src_node_id)?;

   let router_hop = router::RouteHintHop {
    src_node_id: pubkey_res,
    short_channel_id: hop.short_channel_id,
    fees: network_graph::RoutingFees {
     base_msat: hop.fees_base_msat,
     proportional_millionths: hop.fees_proportional_millionths,
    },
    cltv_expiry_delta: hop.cltv_expiry_delta as u16,
    htlc_minimum_msat: hop.htlc_minimum_msat,
    htlc_maximum_msat: hop.htlc_maximum_msat,
   };
   hops.push(router_hop);
  }
  Ok(router::RouteHint(hops))
 }

 pub fn from_ldk_hint(hint: &router::RouteHint) -> RouteHint {
  let mut hops = Vec::new();
  for hop in hint.0.iter() {
   let pubkey_res = hop.src_node_id.serialize().encode_hex::<String>();

   let router_hop = RouteHintHop {
    src_node_id: pubkey_res,
    short_channel_id: hop.short_channel_id,
    fees_base_msat: hop.fees.base_msat,
    fees_proportional_millionths: hop.fees.proportional_millionths,
    cltv_expiry_delta: u64::from(hop.cltv_expiry_delta),
    htlc_minimum_msat: hop.htlc_minimum_msat,
    htlc_maximum_msat: hop.htlc_maximum_msat,
   };
   hops.push(router_hop);
  }
  RouteHint(hops)
 }
}

pub fn _add_routing_hints(
 invoice: &String,
 hints: Vec<RouteHint>,
 private_key: &[u8; 32],
) -> Result<String> {
 let signed = invoice.parse::<SignedRawInvoice>()?;
 let invoice = Invoice::from_signed(signed)?;
 let description = match invoice.description() {
  InvoiceDescription::Direct(msg) => msg.to_string(),
  InvoiceDescription::Hash(_) => String::from(""),
 };

 let private_key = SecretKey::from_slice(private_key).unwrap();
 let mut invoice_builder = InvoiceBuilder::new(Currency::Bitcoin)
  .description(description)
  .payment_hash(*invoice.payment_hash())
  .timestamp(invoice.timestamp())
  .amount_milli_satoshis(match invoice.amount_milli_satoshis() {
   Some(amount) => amount,
   None => 0,
  })
  .expiry_time(invoice.expiry_time())
  .payment_secret(*invoice.payment_secret())
  .min_final_cltv_expiry(invoice.min_final_cltv_expiry());

 for hint in invoice.route_hints() {
  invoice_builder = invoice_builder.private_route(hint);
 }
 for hint in hints {
  invoice_builder = invoice_builder.private_route(hint.to_ldk_hint()?);
 }

 let invoice_builder = invoice_builder
  .build_signed(|hash| Secp256k1::new().sign_recoverable(hash, &private_key))
  .and_then(|op| Ok(op.to_string()));

 match invoice_builder {
  Ok(invoice) => Ok(invoice),
  Err(err) => Err(anyhow!(err)),
 }
}

// parse_invoice parse a bolt11 payment request and returns a structure contains the parsed fields.
pub fn _parse_invoice(invoice: &String) -> Result<LNInvoice> {
 let signed = invoice.parse::<SignedRawInvoice>()?;
 let invoice = Invoice::from_signed(signed)?;

 let since_the_epoch = invoice.timestamp().duration_since(UNIX_EPOCH)?;

 // make sure signature is valid
 invoice.check_signature()?;

 // Try to take payee pubkey from the tagged fields, if doesn't exist recover it from the signature
 let payee_pubkey: String = match invoice.payee_pub_key() {
  Some(key) => key.serialize().encode_hex::<String>(),
  None => invoice
   .recover_payee_pub_key()
   .serialize()
   .encode_hex::<String>(),
 };

 // convert hints to bridge interface
 let invoice_hints = invoice.route_hints();
 let converted_hints = invoice_hints
  .iter()
  .map(|h| {
   return RouteHint::from_ldk_hint(h);
  })
  .collect();

 // return the parsed invoice
 let ln_invoice = LNInvoice {
  payee_pubkey: payee_pubkey,
  expiry: invoice.expiry_time().as_secs(),
  amount: invoice.amount_milli_satoshis(),
  timestamp: since_the_epoch.as_secs(),
  routing_hints: converted_hints,
  payment_hash: invoice.payment_hash().encode_hex::<String>(),
  description: match invoice.description() {
   InvoiceDescription::Direct(msg) => msg.to_string(),
   InvoiceDescription::Hash(_) => String::from(""),
  },
 };
 Ok(ln_invoice)
}

#[cfg(test)]
mod tests {
 use crate::invoice::*;

 #[test]
 fn test_parse_invoice() {
  let payreq = String::from("lnbc110n1p38q3gtpp5ypz09jrd8p993snjwnm68cph4ftwp22le34xd4r8ftspwshxhmnsdqqxqyjw5qcqpxsp5htlg8ydpywvsa7h3u4hdn77ehs4z4e844em0apjyvmqfkzqhhd2q9qgsqqqyssqszpxzxt9uuqzymr7zxcdccj5g69s8q7zzjs7sgxn9ejhnvdh6gqjcy22mss2yexunagm5r2gqczh8k24cwrqml3njskm548aruhpwssq9nvrvz");
  let res = _parse_invoice(&payreq).unwrap();

  let private_key_vec =
   hex::decode("3e171115f50b2c355836dc026a6d54d525cf0d796eb50b3460a205d25c9d38fd").unwrap();
  let mut private_key: [u8; 32] = Default::default();
  private_key.copy_from_slice(&private_key_vec[0..32]);
  let hint_hop = RouteHintHop {
   src_node_id: res.payee_pubkey,
   short_channel_id: 1234,
   fees_base_msat: 1000,
   fees_proportional_millionths: 100,
   cltv_expiry_delta: 2000,
   htlc_minimum_msat: Some(3000),
   htlc_maximum_msat: Some(4000),
  };
  let route_hint = RouteHint(vec![hint_hop]);

  let encoded = _add_routing_hints(&payreq, vec![route_hint], &private_key).unwrap();

  print!("{}", encoded);
 }
}
