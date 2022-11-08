use anyhow::Result;
use gl_client::pb::{Amount, Invoice, Payment, Peer};
use gl_client::pb::amount::Unit;
use rand::distributions::{Alphanumeric, DistString, Standard};
use rand::{random, Rng};

use crate::fiat::{FiatCurrency, Rate};

use crate::grpc::{PaymentInformation, RegisterPaymentReply};
use crate::lsp::LspInformation;
use crate::models::{FiatAPI, LightningTransaction, LspAPI, NodeAPI, NodeState, SyncResponse};
use tokio::sync::mpsc;

pub struct MockNodeAPI {
    pub node_state: NodeState,
    pub transactions: Vec<LightningTransaction>,
}

#[tonic::async_trait]
impl NodeAPI for MockNodeAPI {
    async fn start(&self) -> Result<()> {
        Ok(())
    }

    async fn run_signer(&self, shutdown: mpsc::Receiver<()>) -> Result<()> {
        Ok(())
    }

    async fn pull_changed(&self, since_timestamp: i64) -> Result<SyncResponse> {
        Ok(SyncResponse {
            node_state: self.node_state.clone(),
            transactions: self.transactions.clone(),
        })
    }

    async fn list_peers(&self) -> Result<Vec<Peer>> {
        Ok(vec![])
    }

    async fn create_invoice(&self, amount_sats: u64, description: String) -> Result<Invoice> {
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

    async fn send_payment(&self, amount_sats: u64, bolt11: String) -> Result<Payment> {
        Ok(Payment {
            payment_hash: rand_vec_u8(32),
            bolt11,
            amount: Some(Amount {
                unit: Some(Unit::Satoshi(amount_sats)),
            }),
            amount_sent: Some(Amount {
                unit: Some(Unit::Satoshi(amount_sats)),
            }),
            payment_preimage: rand_vec_u8(32),
            status: 1,
            created_at: random(),
            destination: rand_vec_u8(32),
        })
    }
}

pub struct MockBreezServer {}

#[tonic::async_trait]
impl LspAPI for MockBreezServer {
    async fn list_lsps(&self, _node_pubkey: String) -> Result<Vec<LspInformation>> {
        Ok(Vec::new())
    }

    async fn register_payment(
        &mut self,
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

    async fn fetch_rates(&self) -> Result<Vec<Rate>> {
        Ok(vec![Rate {
            coin: "USD".to_string(),
            value: 20_000.00,
        }])
    }
}

pub fn rand_string(len: usize) -> String {
    Alphanumeric.sample_string(&mut rand::thread_rng(), len)
}

pub fn rand_vec_u8(len: usize) -> Vec<u8> {
    rand::thread_rng().sample_iter(Standard).take(len).collect()
}
