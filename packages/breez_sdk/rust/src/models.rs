use anyhow::Result;
use gl_client::pb::{Invoice, Payment, WithdrawResponse};
use gl_client::pb::Peer;
use serde::{Deserialize, Serialize};
use tokio::sync::mpsc;

use crate::fiat::{FiatCurrency, Rate};
use crate::grpc::{PaymentInformation, RegisterPaymentReply};
use crate::lsp::LspInformation;
use crate::models::Network::Bitcoin;

pub const PAYMENT_TYPE_SENT: &str = "sent";
pub const PAYMENT_TYPE_RECEIVED: &str = "received";

#[tonic::async_trait]
pub trait NodeAPI {
    async fn create_invoice(&self, amount_sats: u64, description: String) -> Result<Invoice>;
    async fn pull_changed(&self, since_timestamp: i64) -> Result<SyncResponse>;
    /// As per the `pb::PayRequest` docs, `amount_sats` is only needed when the invoice doesn't specify an amount
    async fn send_payment(&self, bolt11: String, amount_sats: Option<u64>) -> Result<Payment>;
    async fn send_spontaneous_payment(&self, node_id: String, amount_sats: u64) -> Result<Payment>;
    async fn start(&self) -> Result<()>;
    /// `feerate_preset` is the int value of `gl_client::greenlight::FeeratePreset`:
    ///
    /// 0 = normal, 1 = slow, 2 = urgent
    async fn sweep(&self, to_address: String, feerate_preset: i32) -> Result<WithdrawResponse>;
    async fn run_signer(&self, shutdown: mpsc::Receiver<()>) -> Result<()>;
    async fn list_peers(&self) -> Result<Vec<Peer>>;
}

#[tonic::async_trait]
pub trait LspAPI {
    async fn list_lsps(&self, node_pubkey: String) -> Result<Vec<LspInformation>>;
    async fn register_payment(
        &mut self,
        lsp_id: String,
        lsp_pubkey: Vec<u8>,
        payment_info: PaymentInformation,
    ) -> Result<RegisterPaymentReply>;
}

#[tonic::async_trait]
pub trait FiatAPI {
    fn list_fiat_currencies(&self) -> Result<Vec<FiatCurrency>>;
    async fn fetch_rates(&self) -> Result<Vec<Rate>>;
}

#[derive(Clone)]
pub struct Config {
    pub breezserver: String,
    pub mempoolspace_url: String,
    pub working_dir: String,
    pub network: Network,
    pub payment_timeout_sec: u32
}

impl Default for Config {
    fn default() -> Self {
        Config {
            breezserver: "https://bs1-st.breez.technology:443".to_string(),
            mempoolspace_url: "https://mempool.space".to_string(),
            working_dir: ".".to_string(),
            network: Bitcoin,
            payment_timeout_sec: 30
        }
    }
}

#[derive(Clone)]
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

pub fn parse_short_channel_id(id_str: &str) -> Result<i64> {
    let parts : Vec<&str> = id_str.split('x').collect();
    if parts.len() != 3 {
        return Ok(0);
    }
    let block_num = parts[0].parse::<i64>()?;
    let tx_num = parts[1].parse::<i64>()?;
    let tx_out = parts[2].parse::<i64>()?;

    Ok((block_num & 0xFFFFFF) << 40 | (tx_num & 0xFFFFFF) << 16 | (tx_out & 0xFFFF))
}
#[cfg(test)]
mod tests {
    use prost::Message;
    use rand::random;

    use crate::grpc::PaymentInformation;
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
