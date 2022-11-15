use crate::grpc::{AddFundInitReply, AddFundInitRequest};
use anyhow::{anyhow, Result};
use bitcoin::blockdata::opcodes;
use bitcoin::blockdata::script::Builder;
use bitcoin::secp256k1::{Message, PublicKey, Secp256k1, SecretKey};
use bitcoin::Script;
use bitcoin_hashes::sha256;
use rand::Rng;
use ripemd::{Digest, Ripemd160};

use crate::models::{Swap, SwapInfo, SwapStatus, SwapperAPI};
use crate::node_service::BreezServer;

#[tonic::async_trait]
impl SwapperAPI for BreezServer {
    async fn create_swap(
        &self,
        hash: Vec<u8>,
        payer_pubkey: Vec<u8>,
        node_id: String,
    ) -> Result<Swap> {
        let mut fund_client = self.get_fund_manager_client().await?;
        let request = AddFundInitRequest {
            hash: hash.clone(),
            pubkey: payer_pubkey.clone(),
            node_id,
            notification_token: "".to_string(),
        };

        let result = fund_client.add_fund_init(request).await?.into_inner();
        Ok(Swap {
            bitcoin_address: result.address,
            swapper_pubkey: result.pubkey,
            lock_height: result.lock_height,
            max_allowed_deposit: result.max_allowed_deposit,
            error_message: result.error_message,
            required_reserve: result.required_reserve,
            min_allowed_deposit: result.min_allowed_deposit,
        })
    }
}

pub struct BTCReceiveSwap {
    pub(crate) swapper_api: Box<dyn SwapperAPI>,
    pub(crate) persister: crate::persist::db::SqliteStorage,
}

impl BTCReceiveSwap {
    async fn create_swap_address(&self, node_id: String) -> Result<SwapInfo> {
        // create swap keys
        let swap_keys = create_swap_keys()?;
        let secp = Secp256k1::new();
        let private_key = SecretKey::from_slice(&swap_keys.priv_key)?;
        let pubkey = PublicKey::from_secret_key(&secp, &private_key)
            .serialize()
            .to_vec();
        let hash = Message::from_hashed_data::<sha256::Hash>(&swap_keys.preimage[..])
            .as_ref()
            .to_vec();

        // use swap API to fetch a new swap address
        let swap_reply = self
            .swapper_api
            .create_swap(hash.clone(), pubkey.clone(), node_id)
            .await?;

        // calculate the submarine swap script
        let our_script = create_submarine_swap_script(
            hash.clone(),
            swap_reply.swapper_pubkey,
            pubkey.clone(),
            swap_reply.lock_height,
        )?;

        let address = bitcoin::Address::p2wsh(&our_script, bitcoin::Network::Bitcoin);
        let address_str = address.to_string();

        // Ensure our address generation match the service
        if address_str != swap_reply.bitcoin_address {
            return Err(anyhow!("wrong address"));
        }

        let swap_info = SwapInfo {
            bitcoin_address: swap_reply.bitcoin_address,
            created_at: 0,
            lock_height: swap_reply.lock_height,
            payment_hash: hash.clone(),
            preimage: swap_keys.preimage,
            private_key: swap_keys.priv_key.to_vec(),
            public_key: pubkey.clone(),
            paid_sats: 0,
            confirmed_sat: 0,
            script: our_script.as_bytes().to_vec(),
            status: SwapStatus::Initial,
        };

        // persist the address
        self.persister.save_swap_info(swap_info.clone())?;
        Ok(swap_info)

        // return swap.bitcoinAddress;
    }

    async fn list_swaps(&self) -> Result<Vec<SwapInfo>> {
        Err(anyhow!("Not implemented"))
    }

    async fn redeem_swap(&self, swap_address: String) -> Result<()> {
        Err(anyhow!("Not implemented"))
    }

    async fn refund_swap(&self, swap_address: String, to_address: String) -> Result<()> {
        Err(anyhow!("Not implemented"))
    }
}

struct SwapKeys {
    pub priv_key: Vec<u8>,
    pub preimage: Vec<u8>,
}

fn create_swap_keys() -> Result<SwapKeys> {
    let priv_key = rand::thread_rng().gen::<[u8; 32]>().to_vec();
    let preimage = rand::thread_rng().gen::<[u8; 32]>().to_vec();
    Ok(SwapKeys { priv_key, preimage })
}

fn create_submarine_swap_script(
    invoice_hash: Vec<u8>,
    swapper_pub_key: Vec<u8>,
    payer_pub_key: Vec<u8>,
    lock_height: i64,
) -> Result<Script> {
    let mut hasher = Ripemd160::new();
    hasher.update(invoice_hash);
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
        .into_script())
}

mod tests {
    use bitcoin::secp256k1::{Message, PublicKey, Secp256k1, SecretKey};
    use bitcoin_hashes::sha256;
    use ripemd::{Digest, Ripemd160};

    use crate::{
        swap::BTCReceiveSwap,
        test_utils::{create_test_config, create_test_persister, MockSwapperAPI},
    };

    use super::create_submarine_swap_script;

    #[test]
    fn test_build_swap_script() {
        // swap payer private/public key pair
        // swap payer public key
        let secp = Secp256k1::new();
        let private_key = SecretKey::from_slice(
            &hex::decode("1ab3fe9f94ff1332d6f198484c3677832d1162781f86ce85f6d7587fa97f0330")
                .unwrap(),
        )
        .unwrap();
        let pub_key = PublicKey::from_secret_key(&secp, &private_key)
            .serialize()
            .to_vec();

        // Another pair for preimage/hash
        let preimage =
            hex::decode("4bedf04d0e1ed625e8863163e26abe4e1e6e3e9e5a25fa28cf4fe89500aadd46")
                .unwrap();
        let hash = Message::from_hashed_data::<sha256::Hash>(&preimage.clone()[..])
            .as_ref()
            .to_vec();

        // refund lock height
        let lock_height = 288;

        // swapper pubkey
        let swapper_pubkey =
            hex::decode("02b7952870655802bf863fd180de26ceec466d5454da949b159da8c1bf0cb3fe88")
                .unwrap();

        let expected_address = "bc1qwxgj02vc9esa32ylkrqnhmvcamwtd95wndxqpdwk4mh9pj4629uqcjwv8l";

        // create the script
        let script =
            create_submarine_swap_script(hash, swapper_pubkey, pub_key, lock_height).unwrap();

        // compare the expected and created script
        let expected_script = "a91458163502b02967cfb7c0f3859874db702121b5d487632102b7952870655802bf863fd180de26ceec466d5454da949b159da8c1bf0cb3fe8867022001b27521024ad3b16767cf68d59c41b9544e42340959479447a82a5cd24c320e1ce92adb0968ac".to_string();
        let serialized_script = hex::encode(script.as_bytes().to_vec());
        assert_eq!(expected_script, serialized_script);

        // compare the expected and created swap address
        let address = bitcoin::Address::p2wsh(&script, bitcoin::Network::Bitcoin);
        let address_str = address.to_string();
        assert_eq!(address_str, expected_address);
    }
}
