use anyhow::{anyhow, Result};
use lightning_invoice::RawInvoice;
use lightning_signer::bitcoin::bech32::ToBase32;
use lightning_signer::persist::Persist;
use lightning_signer_server::persist::persist_json::KVJsonPersister;
use std::sync::Arc;
use vls_protocol::model::Bip32KeyVersion;
use vls_protocol::model::BlockId;
use vls_protocol::model::PubKey;
use vls_protocol_signer::handler;
use vls_protocol_signer::handler::Handler;
use vls_protocol_signer::vls_protocol::{msgs, msgs::HsmdInit, msgs::Message};

pub fn _new_hsmd(secret: [u8; 32], storage_path: &String) -> Result<Hsmd> {
 // TODO: use a file based storage instead
 let storage = KVJsonPersister::new(storage_path);
 let persister: Arc<dyn Persist> = Arc::new(storage);

 // create the root handler
 let root = handler::RootHandler::new(0, Some(secret), persister, Vec::new());

 // construct the init message
 let init_message = HsmdInit {
  key_version: Bip32KeyVersion {
   pubkey_version: 0,
   privkey_version: 0,
  },
  chain_params: BlockId([0; 32]),
  encryption_key: None,
  dev_privkey: None,
  dev_bip32_seed: None,
  dev_channel_secrets: None,
  dev_channel_secrets_shaseed: None,
 };

 // initialize the root handler
 let init_result = root.handle(Message::HsmdInit(init_message));
 match init_result {
  Ok(init) => Ok(Hsmd::new(root, init.as_vec())),
  Err(err) => Err(anyhow!(format!("failed to init hsmd {:?}", err))),
 }
}

pub struct Hsmd {
 pub _inner: handler::RootHandler,
 pub init: Vec<u8>,
}

impl Hsmd {
 pub fn new(root: handler::RootHandler, init: Vec<u8>) -> Self {
  Self {
   _inner: root,
   init: init,
  }
 }

 pub fn node_pubkey(&self) -> Vec<u8> {
  self._inner.node.get_id().serialize().to_vec()
 }

 pub fn handle_sign_invoice(&self, raw_invoice: RawInvoice) -> Result<String> {
  // extract hrp & data parts
  let hrp_str = raw_invoice.hrp.to_string();
  let hrp_bytes = hrp_str.as_bytes().to_vec();
  let invoice_data = raw_invoice.data.to_base32();
  // initialize a new hsmd for signing and sign the invoice
  let sig = self._inner.node.sign_invoice(&hrp_bytes, &invoice_data);
  let signed_invoice = raw_invoice.sign(|_| sig);
  match signed_invoice {
   Ok(signed) => Ok(signed.to_string()),
   Err(err) => Err(anyhow!(format!("failed to sign invoice {:?}", err))),
  }
 }

 pub fn handle_sign_message(&self, msg: Vec<u8>) -> Result<Vec<u8>> {
  let sign_message = Message::SignMessage(msgs::SignMessage { message: msg });
  let res = self._inner.handle(sign_message).map(|r| r.as_vec());
  match res {
   Ok(r) => Ok(r[2..66].to_vec()),
   Err(err) => Err(anyhow!(format!("failed to sign message {:?}", err))),
  }
 }

 // handle message to sign
 pub fn handle(&self, msg: Vec<u8>, peer_id: Option<Vec<u8>>, db_id: u64) -> Result<Vec<u8>> {
  // convert to PubKey if peer_id exists
  let optional_peer = peer_id.map(|raw| {
   let mut node_id_slice: [u8; 33] = [0; 33];
   node_id_slice.copy_from_slice(&raw[0..33]);
   PubKey(node_id_slice)
  });

  // deserialize the message
  let m = msgs::from_vec(msg.clone());
  if let Err(e) = m {
   return Err(anyhow!("failed to deserialize message"));
  }
  let m = m?;
  match m {
   Message::GetChannelBasepoints(msg) => {
    let nc: msgs::NewChannel = msgs::NewChannel {
     node_id: msg.node_id,
     dbid: msg.dbid,
    };
    let _ = self._inner.handle(Message::NewChannel(nc)).unwrap();
   }
   _ => {}
  }
  // check if the message should be signed by the root handler or the channel handler.
  // Ideally this should be abstracted in the lightning signer.
  let m = msgs::from_vec(msg.clone());
  if let Err(e) = m {
   return Err(anyhow!(format!(
    "failed to sign message {:?}  {:?}",
    e,
    msgs::from_vec(msg.clone()).unwrap()
   )));
  }
  let m = m?;
  let root = self.is_root_handler(&m);
  let sign_res = match root {
   true => self._inner.handle(m),
   false => self
    ._inner
    .for_new_client(
     0,
     optional_peer.ok_or(anyhow!(format!(
      "failed to get optional peer messag={:?}",
      m
     )))?,
     db_id,
    )
    .handle(m),
  };

  match sign_res {
   Ok(s) => Ok(s.as_vec()),
   Err(err) => Err(anyhow!(format!(
    "failed to sign message {:?} err: {:?}",
    msgs::from_vec(msg.clone()).unwrap(),
    err
   ))),
  }
 }

 fn is_root_handler(&self, m: &Message) -> bool {
  match m {
   Message::Ecdh(_msg) => true,
   Message::Ping(_msg) => true,
   Message::Pong(_msg) => true,
   Message::NewChannel(_msg) => true,
   Message::SignBolt12(_msg) => true,
   Message::SignBolt12Reply(_msg) => true,
   Message::Memleak(_msg) => true,
   Message::MemleakReply(_msg) => true,
   Message::HsmdInit(_msg) => true,
   Message::HsmdInitReply(_msg) => true,
   Message::HsmdInit2(_msg) => true,
   Message::HsmdInit2Reply(_msg) => true,
   Message::SignInvoice(_msg) => true,
   Message::SignInvoiceReply(_msg) => true,
   Message::SignWithdrawal(_msg) => true,
   Message::SignWithdrawalReply(_msg) => true,
   Message::SignMessage(_msg) => true,
   Message::SignMessageReply(_msg) => true,
   Message::GetChannelBasepoints(_msg) => true,
   Message::GetChannelBasepointsReply(_msg) => true,
   Message::SignNodeAnnouncement(_msg) => true,
   Message::SignNodeAnnouncementReply(_msg) => true,
   Message::SignChannelUpdate(_msg) => true,
   Message::SignChannelUpdateReply(_msg) => true,
   Message::SignChannelAnnouncement(_msg) => true,
   Message::SignChannelAnnouncementReply(_msg) => true,
   Message::SignCommitmentTxReply(_msg) => true,
   Message::SignCommitmentTx(_msg) => true,
   _ => false,
  }
 }
}
