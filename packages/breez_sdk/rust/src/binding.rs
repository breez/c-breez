use lazy_static::lazy_static;
use std::future::Future;
use std::sync::Mutex;

use anyhow::{anyhow, Result};

use crate::models::{
    Config, GreenlightCredentials, LightningTransaction, Network, NodeState, PaymentTypeFilter,
};
use crate::node_service::NodeServiceBuilder;
use crate::{greenlight::Greenlight, node_service::NodeService};

lazy_static! {
    static ref STATE: Mutex<Option<Greenlight>> = Mutex::new(None);
}

pub fn register_node(network: Network, seed: Vec<u8>) -> Result<GreenlightCredentials> {
    block_on(Greenlight::register(network, seed))
}

pub fn recover_node(network: Network, seed: Vec<u8>) -> Result<GreenlightCredentials> {
    block_on(Greenlight::recover(network, seed))
}

pub fn create_node_services(
    network: Network,
    seed: Vec<u8>,
    creds: GreenlightCredentials,
) -> Result<NodeService> {
    let greenlight = block_on(Greenlight::new(network, seed, creds))?;
    *STATE.lock().unwrap() = Some(greenlight.clone());
    block_on(build_services())
}

pub fn start_node() -> Result<()> {
    block_on(async { build_services().await?.start_node().await })
}

pub fn run_signer() -> Result<()> {
    block_on(async { build_services().await?.run_signer().await })
}

pub fn sync() -> Result<()> {
    block_on(async { build_services().await?.sync().await })
}

pub fn get_node_state() -> Result<Option<NodeState>> {
    block_on(async { build_services().await?.get_node_state() })
}

pub fn list_transactions(
    filter: PaymentTypeFilter,
    from_timestamp: Option<i64>,
    to_timestamp: Option<i64>,
) -> Result<Vec<LightningTransaction>> {
    block_on(async {
        build_services()
            .await?
            .list_transactions(filter, from_timestamp, to_timestamp)
            .await
    })
}

async fn build_services() -> Result<NodeService> {
    let g = STATE.lock().unwrap().clone();
    let greenlight = g
        .ok_or("greenlight is not initialized")
        .map_err(|e| anyhow!(e))?;

    Ok(NodeServiceBuilder::default()
        .config(Config::default())
        .client(Box::new(greenlight))
        .client_grpc_init_from_config()
        .await
        .build()
        .await)
}

fn block_on<F: Future>(future: F) -> F::Output {
    tokio::runtime::Builder::new_current_thread()
        .enable_all()
        .build()
        .unwrap()
        .block_on(future)
}
