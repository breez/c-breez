use anyhow::{anyhow, Result};
use gl_client::pb::amount::Unit;
use gl_client::pb::{
    Amount, CloseChannelResponse, CloseChannelType, Invoice, Peer, WithdrawResponse,
};
use lightning_invoice::RawInvoice;
use rand::distributions::{Alphanumeric, DistString, Standard};
use rand::{random, Rng};
use tonic::Streaming;

use crate::fiat::{FiatCurrency, Rate};

use crate::grpc::{PaymentInformation, RegisterPaymentReply};
use crate::lsp::LspInformation;
use crate::models::{
    FeeratePreset, FiatAPI, LspAPI, NodeAPI, NodeState, Payment, Swap, SwapperAPI, SyncResponse,
};
use tokio::sync::mpsc;

pub struct MockNodeAPI {
    pub node_state: NodeState,
    pub transactions: Vec<Payment>,
}

#[tonic::async_trait]
impl NodeAPI for MockNodeAPI {
    async fn create_invoice(
        &self,
        amount_sats: u64,
        description: String,
        preimage: Option<Vec<u8>>,
    ) -> Result<Invoice> {
        Ok(Invoice {
            label: "".to_string(),
            description,
            amount: Some(Amount {
                unit: Some(Unit::Satoshi(amount_sats)),
            }),
            received: None,
            status: 0,
            payment_time: 0,
            expiry_time: 0,
            bolt11: "".to_string(),
            payment_hash: vec![],
            payment_preimage: vec![],
        })
    }

    async fn pull_changed(&self, _since_timestamp: i64) -> Result<SyncResponse> {
        Ok(SyncResponse {
            node_state: self.node_state.clone(),
            payments: self.transactions.clone(),
        })
    }

    async fn send_payment(
        &self,
        _bolt11: String,
        _amount_sats: Option<u64>,
    ) -> Result<gl_client::pb::Payment> {
        Ok(MockNodeAPI::get_dummy_payment())
    }

    async fn send_spontaneous_payment(
        &self,
        _node_id: String,
        _amount_sats: u64,
    ) -> Result<gl_client::pb::Payment> {
        Ok(MockNodeAPI::get_dummy_payment())
    }

    async fn start(&self) -> Result<()> {
        Ok(())
    }

    async fn sweep(
        &self,
        _to_address: String,
        _feerate_preset: FeeratePreset,
    ) -> Result<WithdrawResponse> {
        Ok(WithdrawResponse {
            tx: rand_vec_u8(32),
            txid: rand_vec_u8(32),
        })
    }

    fn start_signer(&self, _shutdown: mpsc::Receiver<()>) {}

    async fn list_peers(&self) -> Result<Vec<Peer>> {
        Ok(vec![])
    }

    async fn connect_peer(&self, node_id: String, addr: String) -> Result<()> {
        Ok(())
    }

    fn sign_invoice(&self, invoice: RawInvoice) -> Result<String> {
        Ok("".to_string())
    }

    async fn close_peer_channels(&self, node_id: String) -> Result<CloseChannelResponse> {
        Ok(CloseChannelResponse {
            txid: Vec::new(),
            tx: Vec::new(),
            close_type: CloseChannelType::Mutual.into(),
        })
    }
    async fn stream_incoming_payments(&self) -> Result<Streaming<gl_client::pb::IncomingPayment>> {
        Err(anyhow!("Not implemented"))
    }
}

impl MockNodeAPI {
    fn get_dummy_payment() -> gl_client::pb::Payment {
        gl_client::pb::Payment {
            payment_hash: rand_vec_u8(32),
            bolt11: rand_string(32),
            amount: Some(random())
                .map(Unit::Satoshi)
                .map(Some)
                .map(|amt| Amount { unit: amt }),
            amount_sent: Some(random())
                .map(Unit::Satoshi)
                .map(Some)
                .map(|amt| Amount { unit: amt }),
            payment_preimage: rand_vec_u8(32),
            status: 1,
            created_at: random(),
            destination: rand_vec_u8(32),
        }
    }
}

pub struct MockBreezServer {}

#[tonic::async_trait]
impl LspAPI for MockBreezServer {
    async fn list_lsps(&self, _node_pubkey: String) -> Result<Vec<LspInformation>> {
        Ok(Vec::new())
    }

    async fn register_payment(
        &self,
        _lsp_id: String,
        _lsp_pubkey: Vec<u8>,
        _payment_info: PaymentInformation,
    ) -> Result<RegisterPaymentReply> {
        Ok(RegisterPaymentReply {})
    }
}

#[tonic::async_trait]
impl FiatAPI for MockBreezServer {
    fn list_fiat_currencies(&self) -> Result<Vec<FiatCurrency>> {
        Ok(vec![])
    }

    async fn fetch_fiat_rates(&self) -> Result<Vec<Rate>> {
        Ok(vec![Rate {
            coin: "USD".to_string(),
            value: 20_000.00,
        }])
    }
}

pub struct MockSwapperAPI {}

#[tonic::async_trait]
impl SwapperAPI for MockSwapperAPI {
    async fn create_swap(
        &self,
        hash: Vec<u8>,
        payer_pubkey: Vec<u8>,
        node_pubkey: String,
    ) -> Result<Swap> {
        Err(anyhow!("Not implemented"))
    }

    async fn complete_swap(&self, bolt11: String) -> Result<()> {
        Ok(())
    }
}

pub fn rand_string(len: usize) -> String {
    Alphanumeric.sample_string(&mut rand::thread_rng(), len)
}

pub fn rand_vec_u8(len: usize) -> Vec<u8> {
    rand::thread_rng().sample_iter(Standard).take(len).collect()
}

pub fn create_test_config() -> crate::models::Config {
    let mut cfg = crate::models::Config::default();
    cfg.working_dir = get_test_working_dir();
    cfg
}

pub fn create_test_persister(config: crate::models::Config) -> crate::persist::db::SqliteStorage {
    let storage_path = format!("{}/storage.sql", config.working_dir);
    crate::persist::db::SqliteStorage::from_file(storage_path)
}

pub fn get_test_working_dir() -> String {
    std::env::temp_dir().to_str().unwrap().to_string()
}
