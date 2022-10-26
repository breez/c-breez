use crate::models::{LightningTransaction, NodeAPI, NodeState, SyncResponse};
use anyhow::Result;

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
}
