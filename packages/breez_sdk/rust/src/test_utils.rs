use std::collections::HashMap;

use anyhow::Result;
use rand::distributions::{Alphanumeric, DistString, Standard};
use rand::Rng;

use crate::fiat::FiatCurrency;
use crate::grpc::PaymentInformation;
use crate::grpc::{LspInformation, RegisterPaymentReply};
use crate::models::{FiatAPI, LightningTransaction, LspAPI, NodeAPI, NodeState, SyncResponse};

pub struct MockNodeAPI {
    pub node_state: NodeState,
    pub transactions: Vec<LightningTransaction>,
}

#[tonic::async_trait]
impl NodeAPI for MockNodeAPI {
    async fn start(&self) -> Result<()> {
        Ok(())
    }

    async fn run_signer(&self) -> Result<()> {
        Ok(())
    }

    async fn pull_changed(&self, since_timestamp: i64) -> Result<SyncResponse> {
        Ok(SyncResponse {
            node_state: self.node_state.clone(),
            transactions: self.transactions.clone(),
        })
    }
}

pub struct MockBreezLSP {}

#[tonic::async_trait]
impl LspAPI for MockBreezLSP {
    async fn list_lsps(&self, _node_pubkey: String) -> Result<HashMap<String, LspInformation>> {
        Ok(HashMap::new())
    }

    async fn register_payment(
        &mut self,
        _lsp: &LspInformation,
        _payment_info: PaymentInformation,
    ) -> Result<RegisterPaymentReply> {
        Ok(RegisterPaymentReply {})
    }
}

#[tonic::async_trait]
impl FiatAPI for MockBreezLSP {
    fn list_fiat_currencies() -> Result<HashMap<std::string::String, FiatCurrency>> {
        Ok(HashMap::new())
    }

    async fn fetch_rates(&self) -> Result<HashMap<String, f64>> {
        Ok(HashMap::from_iter(vec![("USD".to_string(), 20_000.00)]))
    }
}

pub fn rand_string(len: usize) -> String {
    Alphanumeric.sample_string(&mut rand::thread_rng(), len)
}

pub fn rand_vec_u8(len: usize) -> Vec<u8> {
    rand::thread_rng().sample_iter(Standard).take(len).collect()
}
