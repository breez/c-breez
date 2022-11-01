use std::collections::HashMap;

use anyhow::Result;
use serde::{Deserialize, Serialize};

use crate::grpc::PaymentInformation;
use crate::grpc::{LspInformation, RegisterPaymentReply};
use crate::models::Network::Bitcoin;

pub const PAYMENT_TYPE_SENT: &str = "sent";
pub const PAYMENT_TYPE_RECEIVED: &str = "received";

#[tonic::async_trait]
pub trait NodeAPI {
    async fn pull_changed(&self, since_timestamp: i64) -> Result<SyncResponse>;
    async fn start(&mut self) -> Result<()>;
    async fn run_signer(&self) -> Result<()>;
}

#[tonic::async_trait]
pub trait LspAPI {
    async fn list_lsps(&mut self, node_pubkey: String) -> Result<HashMap<String, LspInformation>>;
    async fn register_payment(
        &mut self,
        lsp: &LspInformation,
        payment_info: PaymentInformation,
    ) -> Result<RegisterPaymentReply>;
}

#[derive(Clone)]
pub struct Config {
    pub breezserver: String,
    pub mempoolspace_url: String,
    pub working_dir: String,
    pub network: Network,
}

impl Default for Config {
    fn default() -> Self {
        Config {
            breezserver: "https://bs1-st.breez.technology:443".to_string(),
            mempoolspace_url: "https://mempool.space".to_string(),
            working_dir: ".".to_string(),
            network: Bitcoin,
        }
    }
}

pub struct GreenlightCredentials {
    pub device_key: Vec<u8>,
    pub device_cert: Vec<u8>,
}

#[derive(Clone)]
pub enum Network {
    /// Mainnet
    Bitcoin,
    Testnet,
    Signet,
    Regtest,
}

pub enum PaymentTypeFilter {
    Sent,
    Received,
    All,
}

#[derive(Serialize, Deserialize, Clone, PartialEq, Eq, Debug)]
pub struct NodeState {
    pub id: String,
    pub block_height: u32,
    pub channels_balance_msat: u64,
    pub onchain_balance_msat: u64,
    pub max_payable_msat: u64,
    pub max_receivable_msat: u64,
    pub max_single_payment_amount_msat: u64,
    pub max_chan_reserve_msats: u64,
    pub connected_peers: Vec<String>,
    pub inbound_liquidity_msats: u64,
}

pub struct SyncResponse {
    pub node_state: NodeState,
    pub transactions: Vec<LightningTransaction>,
}

#[derive(PartialEq, Eq, Debug, Clone)]
pub struct LightningTransaction {
    pub payment_type: String,
    pub payment_hash: String,
    pub payment_time: i64,
    pub label: String,
    pub destination_pubkey: String,
    pub amount_msat: i32,
    pub fees_msat: i32,
    pub payment_preimage: String,
    pub keysend: bool,
    pub bolt11: String,
    pub pending: bool,
    pub description: Option<String>,
}

#[cfg(test)]
mod tests {
    use crate::grpc::PaymentInformation;
    use prost::Message;
    use rand::random;

    use crate::test_utils::rand_vec_u8;

    #[test]
    fn test_payment_information_ser_de() -> Result<(), Box<dyn std::error::Error>> {
        let dummy_payment_info = PaymentInformation {
            payment_hash: rand_vec_u8(10),
            payment_secret: rand_vec_u8(10),
            destination: rand_vec_u8(10),
            incoming_amount_msat: random(),
            outgoing_amount_msat: random(),
        };

        let mut buf = Vec::new();
        buf.reserve(dummy_payment_info.encoded_len());
        dummy_payment_info.encode(&mut buf)?;

        let decoded_payment_info: PaymentInformation = PaymentInformation::decode(&*buf)?;

        assert_eq!(dummy_payment_info, decoded_payment_info);

        Ok(())
    }
}
