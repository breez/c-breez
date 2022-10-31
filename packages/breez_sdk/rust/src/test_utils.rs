use std::collections::HashMap;

use anyhow::Result;
use rand::distributions::{Alphanumeric, DistString, Standard};
use rand::Rng;

use crate::grpc::breez::{LspInformation, RegisterPaymentReply};
use crate::grpc::lspd::PaymentInformation;
use crate::models::{LightningTransaction, LspAPI, NodeAPI, NodeState, SyncResponse};
use gl_client::pb::Peer;

pub struct MockNodeAPI {
    pub node_state: NodeState,
    pub transactions: Vec<LightningTransaction>,
}

#[tonic::async_trait]
impl NodeAPI for MockNodeAPI {
    async fn start(&mut self) -> Result<()> {
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

    async fn list_peers(&self) -> Result<Vec<Peer>> {
        Ok(vec![])
    }
}

pub struct MockBreezLSP {}

#[tonic::async_trait]
impl LspAPI for MockBreezLSP {
    async fn list_lsps(&mut self, _node_pubkey: String) -> Result<HashMap<String, LspInformation>> {
        Ok(HashMap::new())
    }

    async fn register_payment(&mut self, _lsp: &LspInformation, _payment_info: PaymentInformation) -> Result<RegisterPaymentReply> {
        Ok(RegisterPaymentReply { })
    }
}

pub fn rand_string(len: usize) -> String {
    Alphanumeric.sample_string(&mut rand::thread_rng(), len)
}

pub fn rand_vec_u8(len: usize) -> Vec<u8> {
    rand::thread_rng().sample_iter(Standard).take(len).collect()
}