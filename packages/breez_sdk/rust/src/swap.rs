//use lightning_signer::bitcoin::{secp256k1};
use anyhow::{anyhow, Result};
use bitcoin_hashes::sha256;
use lightning_signer::bitcoin::blockdata::opcodes;
use lightning_signer::bitcoin::blockdata::script::Builder;
use lightning_signer::bitcoin::secp256k1::{Message, PublicKey, Secp256k1, SecretKey};
use rand::Rng;
use ripemd::{Digest, Ripemd160, Ripemd320};

pub struct SwapKeys {
    pub privkey: Vec<u8>,
    pub pubkey: Vec<u8>,
    pub preimage: Vec<u8>,
    pub hash: Vec<u8>,
}

pub fn create_swap() -> Result<SwapKeys> {
    let secp = Secp256k1::new();
    let seed = rand::thread_rng().gen::<[u8; 32]>();
    let secret_key = SecretKey::from_slice(&seed).expect("32 bytes, within curve order");
    let public_key = PublicKey::from_secret_key(&secp, &secret_key);
    let random_bytes = rand::thread_rng().gen::<[u8; 32]>();
    let preimage_hash = Message::from_hashed_data::<sha256::Hash>(&random_bytes.to_vec()[..]);

    Ok(SwapKeys {
        privkey: seed.to_vec(),
        pubkey: public_key.serialize().to_vec(),
        preimage: random_bytes.to_vec(),
        hash: preimage_hash.as_ref().to_vec(),
    })
}

pub fn create_submaring_swap_script(
    hash: Vec<u8>,
    swapper_pub_key: Vec<u8>,
    payer_pub_key: Vec<u8>,
    lock_height: i64,
) -> Result<Vec<u8>> {
    let mut hasher = Ripemd160::new();
    hasher.update(hash);
    let result = hasher.finalize();

    Ok(Builder::new()
        .push_opcode(opcodes::all::OP_HASH160)
        .push_slice(&result[..])
        .push_opcode(opcodes::all::OP_EQUAL)
        .push_opcode(opcodes::all::OP_IF)
        .push_slice(&swapper_pub_key[..])
        .push_opcode(opcodes::all::OP_ELSE)
        .push_int(lock_height)
        .push_opcode(opcodes::all::OP_CSV)
        .push_opcode(opcodes::all::OP_DROP)
        .push_slice(&payer_pub_key[..])
        .push_opcode(opcodes::all::OP_ENDIF)
        .push_opcode(opcodes::all::OP_CHECKSIG)
        .into_script()
        .as_bytes()
        .to_vec())
}
