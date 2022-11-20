use std::str::FromStr;
use std::sync::Arc;

use crate::binding::parse_invoice;
use crate::chain::{MempoolSpace, OnchainTx};
use crate::chain_notifier::{ChainEvent, Listener};
use crate::grpc::{AddFundInitRequest, GetSwapPaymentRequest};
use anyhow::{anyhow, Result};
use bitcoin::blockdata::opcodes;
use bitcoin::blockdata::script::Builder;
use bitcoin::psbt::serialize::Serialize;
use bitcoin::secp256k1::{Message, PublicKey, Secp256k1, SecretKey};
use bitcoin::util::sighash::SighashCache;
use bitcoin::{
    Address, EcdsaSighashType, OutPoint, Script, Sequence, Transaction, TxIn, TxOut, Txid, Witness,
};
use bitcoin_hashes::hex::FromHex;
use bitcoin_hashes::sha256;
use rand::Rng;
use ripemd::{Digest, Ripemd160};

use crate::models::{Swap, SwapInfo, SwapStatus, SwapperAPI};
use crate::node_service::BreezServer;

struct Utxo {
    out: OutPoint,
    value: u32,
    block_height: u32,
}

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

    async fn complete_swap(&self, bolt11: String) -> Result<()> {
        let request = GetSwapPaymentRequest {
            payment_request: bolt11,
        };
        self.get_fund_manager_client()
            .await?
            .get_swap_payment(request)
            .await?
            .into_inner();
        Ok(())
    }
}

pub struct BTCReceiveSwap {
    swapper_api: Arc<dyn SwapperAPI>,
    persister: Arc<crate::persist::db::SqliteStorage>,
    chain_service: Arc<MempoolSpace>,
}

#[tonic::async_trait]
impl Listener for BTCReceiveSwap {
    fn on_event(&self, e: ChainEvent) {
        debug!("got chain event {:?}", e)
    }
}

impl BTCReceiveSwap {
    pub(crate) fn new(
        swapper_api: Arc<dyn SwapperAPI>,
        persister: Arc<crate::persist::db::SqliteStorage>,
        chain_service: Arc<MempoolSpace>,
    ) -> Self {
        let swapper = Self {
            swapper_api,
            persister,
            chain_service,
        };
        swapper
    }

    pub(crate) async fn create_swap_address(&self, node_id: String) -> Result<SwapInfo> {
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
            swap_reply.swapper_pubkey.clone(),
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
            swapper_public_key: swap_reply.swapper_pubkey.clone(),
            script: our_script.as_bytes().to_vec(),
            bolt11: None,
            paid_sats: 0,
            confirmed_sats: 0,
            status: SwapStatus::Initial,
        };

        // persist the address
        self.persister.insert_swap(swap_info.clone())?;
        Ok(swap_info)

        // return swap.bitcoinAddress;
    }

    pub(crate) async fn list_swaps(&self) -> Result<Vec<SwapInfo>> {
        self.persister.list_swaps()
    }

    async fn refresh_swap_on_chain_status(
        &self,
        bitcoin_address: String,
        current_tip: u32,
    ) -> Result<()> {
        let swap_info = self
            .persister
            .get_swap_info(bitcoin_address.clone())?
            .ok_or_else(|| {
                anyhow!(format!(
                    "swap address {} was not found",
                    bitcoin_address.clone()
                ))
            })?;
        let txs = self
            .chain_service
            .address_transactions(bitcoin_address.clone())
            .await?;
        let utxos = get_utxos(bitcoin_address.clone(), txs)?;
        let confirmed_sats: u32 = utxos.iter().fold(0, |accum, item| accum + item.value);

        let confirmed_block = utxos.iter().fold(0, |b, item| {
            if item.block_height > b {
                item.block_height
            } else {
                b
            }
        });

        let mut swap_status = swap_info.status;
        if swap_status != SwapStatus::Refunded
            && current_tip - confirmed_block >= swap_info.lock_height as u32
        {
            swap_status = SwapStatus::Expired
        }
        self.persister
            .update_swap_chain_info(bitcoin_address, confirmed_sats, swap_status)?;

        Ok(())
    }

    /// redeem_swap executes the final step of receiving lightning payment
    /// in exchange for the on chain funds.
    async fn redeem_swap(
        &self,
        bitcoin_address: String,
        invoice_creator: fn(amount_sats: u32) -> Result<String>,
    ) -> Result<()> {
        let mut swap_info = self
            .persister
            .get_swap_info(bitcoin_address.clone())?
            .ok_or_else(|| anyhow!(format!("swap address {} was not found", bitcoin_address)))?;

        // we are creating and invoice for this swap if we didn't
        // do it already
        if swap_info.bolt11.is_none() {
            let bolt11 = invoice_creator(swap_info.confirmed_sats)?;
            self.persister
                .update_swap_bolt11(bitcoin_address.clone(), bolt11)?;
            swap_info = self
                .persister
                .get_swap_info(bitcoin_address.clone())?
                .unwrap();
        }

        // Making sure the invoice amount matches the on-chain amount
        let payreq = swap_info.bolt11.unwrap();
        let ln_invoice = parse_invoice(payreq.clone())?;
        if ln_invoice.amount_msat.unwrap() != (swap_info.confirmed_sats * 1000) as u64 {
            return Err(anyhow!("invoice amount doesn't match confirmed sats"));
        }

        // Asking the service to initiate the lightning payment
        let result = self.swapper_api.complete_swap(payreq.clone()).await;
        match result {
            Ok(r) => self
                .persister
                .update_swap_paid_amount(bitcoin_address, swap_info.confirmed_sats),
            Err(e) => Err(e),
        }
    }

    // refund_swap is the user way to receive on-chain refund for failed swaps.
    pub(crate) async fn refund_swap(
        &self,
        swap_address: String,
        to_address: String,
    ) -> Result<Vec<u8>> {
        let swap_info = self
            .persister
            .get_swap_info(swap_address.clone())?
            .ok_or_else(|| anyhow!(format!("swap address {} was not found", swap_address)))?;

        let transactions = self
            .chain_service
            .address_transactions(swap_address.clone())
            .await?;
        let utxos = get_utxos(swap_address, transactions)?;

        let script = create_submarine_swap_script(
            swap_info.payment_hash,
            swap_info.swapper_public_key,
            swap_info.public_key,
            swap_info.lock_height,
        )?;
        create_refund_tx(
            utxos,
            swap_info.private_key,
            to_address,
            swap_info.lock_height as u32,
            script,
        )
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

fn get_utxos(swap_address: String, transactions: Vec<OnchainTx>) -> Result<Vec<Utxo>> {
    // calcualte confirmed amount associated with this address
    let mut spent_outputs: Vec<OutPoint> = Vec::new();
    let mut utxos: Vec<Utxo> = Vec::new();
    for (_, tx) in transactions.iter().enumerate() {
        for (_, vin) in tx.vin.iter().enumerate() {
            if tx.status.confirmed && vin.prevout.scriptpubkey_address == swap_address.clone() {
                spent_outputs.push(OutPoint {
                    txid: Txid::from_hex(vin.txid.as_str())?,
                    vout: vin.vout,
                })
            }
        }
    }

    for (i, tx) in transactions.iter().enumerate() {
        for (_, vout) in tx.vout.iter().enumerate() {
            if tx.status.confirmed && vout.scriptpubkey_address == swap_address {
                let outpoint = OutPoint {
                    txid: Txid::from_hex(tx.txid.as_str())?,
                    vout: i as u32,
                };
                if !spent_outputs.contains(&outpoint) {
                    utxos.push(Utxo {
                        out: outpoint,
                        value: vout.value,
                        block_height: tx.status.block_height,
                    });
                }
            }
        }
    }
    Ok(utxos)
}

fn create_refund_tx(
    utxos: Vec<Utxo>,
    private_key: Vec<u8>,
    to_address: String,
    lock_delay: u32,
    input_script: Script,
) -> Result<Vec<u8>> {
    if utxos.len() == 0 {
        return Err(anyhow!("must have at least one input"));
    }

    let lock_time = utxos.iter().fold(0, |accum, item| {
        if accum >= item.block_height + lock_delay {
            accum
        } else {
            item.block_height + lock_delay
        }
    });

    let confirmed_amount: u64 = utxos
        .iter()
        .fold(0, |accum, item| accum + item.value as u64);

    // create the tx inputs
    let txins: Vec<TxIn> = utxos
        .iter()
        .map(|utxo| TxIn {
            previous_output: utxo.out,
            script_sig: Script::new(),
            sequence: Sequence(lock_delay),
            witness: Witness::default(),
        })
        .collect();

    // create the tx outputs
    let btc_address = Address::from_str(&to_address)?;
    let mut tx_out: Vec<TxOut> = Vec::new();
    tx_out.push(TxOut {
        value: confirmed_amount,
        script_pubkey: btc_address.script_pubkey(),
    });

    // construct the transaction
    let mut tx = Transaction {
        version: 2,
        lock_time: bitcoin::PackedLockTime(lock_time),
        input: txins,
        output: tx_out,
    };

    let scpt = Secp256k1::signing_only();

    // go over all inputs and sign them
    let mut signed_inputs: Vec<TxIn> = Vec::new();
    for (index, input) in tx.input.iter().enumerate() {
        let mut signer = SighashCache::new(&tx);
        let sig = signer.segwit_signature_hash(
            index,
            &input_script,
            utxos[index].value as u64,
            bitcoin::EcdsaSighashType::All,
        )?;
        let msg = Message::from_slice(&sig[..])?;
        let secret_key = SecretKey::from_slice(private_key.as_slice())?;
        let sig = scpt.sign_ecdsa(&msg, &secret_key);

        let mut sigvec = sig.serialize_der().to_vec();
        sigvec.push(EcdsaSighashType::All as u8);

        let mut witness: Vec<Vec<u8>> = Vec::new();
        witness.push(sigvec);
        witness.push(vec![]);
        witness.push(input_script.serialize());

        let mut signed_input = input.clone();
        let w = Witness::from_vec(witness);
        signed_input.witness = w;
        signed_inputs.push(signed_input);
    }
    tx.input = signed_inputs;
    Ok(tx.serialize())
}

mod tests {
    use bitcoin::{
        secp256k1::{Message, PublicKey, Secp256k1, SecretKey},
        OutPoint, Txid,
    };
    use bitcoin_hashes::{hex::FromHex, sha256};
    use ripemd::{Digest, Ripemd160};

    use crate::{
        swap::{BTCReceiveSwap, Utxo},
        test_utils::{create_test_config, create_test_persister, MockSwapperAPI},
    };

    use super::{create_refund_tx, create_submarine_swap_script, create_swap_keys};

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

    #[test]
    fn test_refund() {
        // test parameters
        let payer_priv_key_raw = [1; 32].to_vec();
        let swapper_priv_key_raw = [2; 32].to_vec();
        let preimage: [u8; 32] = [3; 32];
        let to_address = String::from("bc1qvhykeqcpdzu0pdvy99xnh9ckhwzcfskct6h6l2");
        let lock_time = 288;

        let utxos: Vec<Utxo> = vec![Utxo {
            out: OutPoint {
                txid: Txid::from_hex(
                    "1ab3fe9f94ff1332d6f198484c3677832d1162781f86ce85f6d7587fa97f0330",
                )
                .unwrap(),
                vout: 0,
            },
            value: 20000,
            block_height: 700000,
        }];

        // payer keys
        let secp = Secp256k1::new();
        let payer_private_key = SecretKey::from_slice(&payer_priv_key_raw).unwrap();
        let payer_pub_key = PublicKey::from_secret_key(&secp, &payer_private_key)
            .serialize()
            .to_vec();

        // swapper keys
        let swapper_private_key = SecretKey::from_slice(&swapper_priv_key_raw).unwrap();
        let swapper_pub_key = PublicKey::from_secret_key(&secp, &swapper_private_key)
            .serialize()
            .to_vec();

        // calculate payment hash
        let payment_hash = Message::from_hashed_data::<sha256::Hash>(&preimage.clone()[..])
            .as_ref()
            .to_vec();

        let script =
            create_submarine_swap_script(payment_hash, swapper_pub_key, payer_pub_key, lock_time)
                .unwrap();

        let refund_tx = create_refund_tx(
            utxos,
            payer_priv_key_raw,
            to_address,
            lock_time as u32,
            script,
        )
        .unwrap();

        /*  We test that the refund transaction looks like this
           {
            "addresses": [
                "bc1qvhykeqcpdzu0pdvy99xnh9ckhwzcfskct6h6l2"
            ],
            "block_height": -1,
            "block_index": -1,
            "confirmations": 0,
            "double_spend": false,
            "fees": 0,
            "hash": "3f9cf5bef98a0ed82c0ef8e4bd34e3624bbedf60b4cbaae3b1180569d562f2fb",
            "inputs": [
                {
                    "age": 0,
                    "output_index": 0,
                    "prev_hash": "1ab3fe9f94ff1332d6f198484c3677832d1162781f86ce85f6d7587fa97f0330",
                    "script_type": "empty",
                    "sequence": 288
                }
            ],
            "lock_time": 700288,
            "opt_in_rbf": true,
            "outputs": [
                {
                    "addresses": [
                        "bc1qvhykeqcpdzu0pdvy99xnh9ckhwzcfskct6h6l2"
                    ],
                    "script": "001465c96c830168b8f0b584294d3b9716bb8584c2d8",
                    "script_type": "pay-to-witness-pubkey-hash",
                    "value": 20000
                }
            ],
            "preference": "low",
            "received": "2022-11-16T10:24:20.100655728Z",
            "relayed_by": "3.235.183.11",
            "size": 157,
            "total": 20000,
            "ver": 2,
            "vin_sz": 1,
            "vout_sz": 1,
            "vsize": 101
        }
        */
        assert_eq!(hex::encode(refund_tx), "0200000000010130037fa97f58d7f685ce861f7862112d8377364c4898f1d63213ff949ffeb31a00000000002001000001204e00000000000016001465c96c830168b8f0b584294d3b9716bb8584c2d80347304402203285efcf44640551a56c53bde677988964ef1b4d11182d5d6634096042c320120220227b625f7827993aca5b9d2f4690c5e5fae44d8d42fdd5f3778ba21df8ba7c7b010064a9148a486ff2e31d6158bf39e2608864d63fefd09d5b876321024d4b6cd1361032ca9bd2aeb9d900aa4d45d9ead80ac9423374c451a7254d076667022001b27521031b84c5567b126440995d3ed5aaba0565d71e1834604819ff9c17f5e9d5dd078f68ac80af0a00");
    }
}
