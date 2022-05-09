use anyhow::{anyhow, Result};
use lightning_signer::persist::DummyPersister;
use lightning_signer::persist::Persist;
use std::sync::Arc;
use vls_protocol::model::Bip32KeyVersion;
use vls_protocol::model::BlockId;
use vls_protocol::model::PubKey;
use vls_protocol_signer::handler;
use vls_protocol_signer::handler::Handler;
use vls_protocol_signer::vls_protocol::{msgs, msgs::HsmdInit, msgs::Message};

pub fn _new_hsmd(secret: [u8; 32]) -> Result<Hsmd> {
 // TODO: use a file based storage instead
 let persister: Arc<dyn Persist> = Arc::new(DummyPersister {});

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
  Ok(_) => Ok(Hsmd::new(root)),
  Err(err) => Err(anyhow!("failed to handle init message")),
 }
}

pub struct Hsmd {
 pub _inner: handler::RootHandler,
}

impl Hsmd {
 pub fn new(root: handler::RootHandler) -> Self {
  Self { _inner: root }
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
  let m = msgs::from_vec(msg);
  if let Err(e) = m {
   return Err(anyhow!("failed to deserialize message"));
  }
  let m = m?;
  let channel_handler = self._inner.for_new_client(2, optional_peer, db_id);

  // check if the message should be signed by the root handler or the channel handler.
  // Ideally this should be abstracted in the lightning signer.
  let root = self.is_root_handler(&m);
  let sign_res = match root {
   true => self._inner.handle(m),
   false => channel_handler.handle(m),
  };

  match sign_res {
   Ok(s) => Ok(s.as_vec()),
   Err(err) => Err(anyhow!("failed to sign message")),
  }
 }

 fn is_root_handler(&self, m: &Message) -> bool {
  match m {
   Message::Ping(_msg) => true,
   Message::Pong(_msg) => true,
   Message::SignBolt12(msg) => true,
   Message::SignBolt12Reply(msg) => true,
   Message::Memleak(msg) => true,
   Message::MemleakReply(msg) => true,
   Message::HsmdInit(msg) => true,
   Message::HsmdInitReply(msg) => true,
   Message::HsmdInit2(msg) => true,
   Message::HsmdInit2Reply(msg) => true,
   Message::SignInvoice(msg) => true,
   Message::SignInvoiceReply(msg) => true,
   Message::SignWithdrawal(msg) => true,
   Message::SignWithdrawalReply(msg) => true,
   Message::SignMessage(msg) => true,
   Message::SignMessageReply(msg) => true,
   Message::GetChannelBasepoints(msg) => true,
   Message::GetChannelBasepointsReply(msg) => true,
   Message::SignRemoteCommitmentTx(msg) => true,
   Message::SignNodeAnnouncement(msg) => true,
   Message::SignNodeAnnouncementReply(msg) => true,
   Message::SignChannelUpdate(msg) => true,
   Message::SignChannelUpdateReply(msg) => true,
   Message::SignChannelAnnouncement(msg) => true,
   Message::SignChannelAnnouncementReply(msg) => true,
   Message::SignCommitmentTxReply(msg) => true,
   _ => false,
  }
 }
}
