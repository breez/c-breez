use anyhow::Result;
use bip39::*;
use lightning_signer::lightning_invoice::RawInvoice;

use crate::crypto::*;
use crate::hsmd::*;
use crate::invoice::*;
use crate::swap::*;

pub fn init_hsmd(storage_path: String, secret: Vec<u8>) -> Result<Vec<u8>> {
 let mut private_key_slice: [u8; 32] = [0; 32];
 private_key_slice.copy_from_slice(&secret[0..32]);
 _new_hsmd(private_key_slice, &storage_path).map(|hsmd| hsmd.init)
}

/// Attempts to convert the phrase to a mnemonic, then to a seed.
///
/// If the phrase is not a valid mnemonic, an error is returned.
pub fn mnemonic_to_seed(phrase: String) -> Result<Vec<u8>> {
 let mnemonic = Mnemonic::from_phrase(&phrase, Language::English)?;
 let seed = Seed::new(&mnemonic, "");
 Ok(seed.as_bytes().to_vec())
}

pub fn create_swap() -> Result<SwapKeys> {
 return _create_swap();
}

pub fn create_submaring_swap_script(
 hash: Vec<u8>,
 swapper_pub_key: Vec<u8>,
 payer_pub_key: Vec<u8>,
 lock_height: i64,
) -> Result<Vec<u8>> {
 return _create_submaring_swap_script(hash, swapper_pub_key, payer_pub_key, lock_height);
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
 new_amount: u64,
) -> Result<String> {
 let mut private_key_slice: [u8; 32] = [0; 32];
 private_key_slice.copy_from_slice(&secret[0..32]);
 let hsmd = _new_hsmd(private_key_slice, &storage_path)?;
 // create a new raw (not signed) invoice with the new routing hints
 let raw_invoice: RawInvoice = _add_routing_hints(&invoice, hints, new_amount)?;
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

#[cfg(test)]
mod tests {
    use std::sync::Mutex;
    use std::{fs::File, io::Read};

    use once_cell::sync::Lazy;

    use super::handle;

    /// Internal SDK state. Stored in memory, not persistent across restarts.
    /// Available only internally, not exposed to callers of SDK.
    static STATE: Lazy<Mutex<NodeState>> = Lazy::new(|| Mutex::new( NodeState::default() ));

    #[derive(Clone, Debug, Default, PartialEq)]
    struct NodeState {
        test_field: Option<String>
    }

    fn get_state() -> NodeState {
        STATE.lock().unwrap().clone()
    }

    fn set_state(state: NodeState) {
        *STATE.lock().unwrap() = state;
    }

    fn read_a_file(name: String) -> std::io::Result<Vec<u8>> {
        match File::open(name) {
            Ok(mut file) => {
                let mut data = Vec::new();
                match file.read_to_end(&mut data) {
                    Ok(_) => Ok(data),
                    Err(err) => Err(err),
                }
            },
            Err(err) => Err(err),
        }
    }

    #[test]
    fn test_hsmd_handle() {
        let secret_file = read_a_file(String::from("/Users/roeierez/greenlight-keys/hsm_secret"));
        if secret_file.is_err() {
            println!("Secret file not found, skipping test");
            return;
        }
        let secret = secret_file.unwrap();
        let msg =
        hex::decode("000103e9a89bf95cc797a0c535234d79497a632bb17ae5b8520b67cb59b22ea1ce60d4").unwrap();
        let peer_id =
        Some(hex::decode("03f27b2fe75f44eeabdbb64ccfc759d3c2a540f6a7461673138d8cf425530d5bb4").unwrap());
        let path = String::from("/Users/roeierez/greenlight-keys2");
        handle(path, secret, msg, peer_id, 0).unwrap();
    }

    #[test]
    fn test_state() {
        assert_eq!(get_state(), NodeState::default());

        let n1 = NodeState { test_field: Some("abc".to_string()) };
        set_state(n1.clone());
        assert_eq!(get_state(), n1);

        let mut n2 = n1;
        n2.test_field = Some("def".to_string());
        set_state(n2.clone());
        assert_eq!(get_state(), n2);
    }
}
