use std::sync::Arc;
use hex::FromHex;
use bitcoin_hashes::hex::ToHex;
use lightning_signer::persist::DummyPersister;
use lightning_signer::persist::Persist;
use vls_protocol::model::Bip32KeyVersion;
use vls_protocol::model::BlockId;
use vls_protocol_signer::handler;
use vls_protocol_signer::handler::Handler;
use vls_protocol_signer::vls_protocol::{msgs, msgs::Message, msgs::HsmdInit};

use bitcoin_hashes::{sha512, Hash, HashEngine, Hmac, HmacEngine};

pub fn _handle(hexsecret: String, hexmessage: String) -> String {
    let secret = <[u8; 32]>::from_hex(hexsecret).unwrap();
    let persister: Arc<dyn Persist> = Arc::new(DummyPersister {});
    let hsmd = handler::RootHandler::new(0, Some(secret), persister, Vec::new());
    let init_message = HsmdInit {
        key_version:  Bip32KeyVersion {
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
    //println!("init message: {}", hex::Encode(to_vec(init_message));
    let init = hsmd.handle(Message::HsmdInit(init_message)).unwrap();
    println!("{:?}", init);
    println!("init: {}", hex::encode(init.as_vec()));

    let m = msgs::from_vec(hex::decode(hexmessage).unwrap()).unwrap();
    println!("{:?}", m);
    let r =  hsmd.handle(m).unwrap();
    println!("{:?}", r);
    println!("signed: {}", hex::encode(r.as_vec()));
    return hex::encode(r.as_vec());
    //let a = hsmd.node.get_id().serialize();
    //println!("{}", hex::encode(a));

    //let mut hmac_engine: HmacEngine<sha512::Hash> = HmacEngine::new(b"Bitcoin seed");
    //hmac_engine.input(&secret);
    //let hmac_result: Hmac<sha512::Hash> = Hmac::from_engine(hmac_engine);
    //println!("hmac: {}", hmac_result.to_hex());
}
