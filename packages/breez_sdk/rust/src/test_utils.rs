use std::collections::HashMap;

use anyhow::Result;
use gl_client::pb::{Amount, Invoice};
use gl_client::pb::amount::Unit;
use rand::distributions::{Alphanumeric, DistString, Standard};
use rand::Rng;

use crate::grpc::PaymentInformation;
use crate::grpc::{LspInformation, RegisterPaymentReply};
use crate::models::{LightningTransaction, LspAPI, NodeAPI, NodeState, SyncResponse};

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

    async fn create_invoice(&self, amount_sats: u64, description: String) -> Result<Invoice> {
        Ok(Invoice {
            label: "".to_string(),
            description,
            amount: Some(Amount{ unit: Some(Unit::Satoshi(amount_sats))}),
            received: None,
            status: 0,
            payment_time: 0,
            expiry_time: 0,
            bolt11: "".to_string(),
            payment_hash: vec![],
            payment_preimage: vec![]
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

pub fn rand_string(len: usize) -> String {
    Alphanumeric.sample_string(&mut rand::thread_rng(), len)
}

pub fn rand_vec_u8(len: usize) -> Vec<u8> {
    rand::thread_rng().sample_iter(Standard).take(len).collect()
}
