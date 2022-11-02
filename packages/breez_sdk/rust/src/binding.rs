use std::future::Future;
use std::sync::Mutex;

use anyhow::{anyhow, Result};
use once_cell::sync::Lazy;

use crate::models::{
    Config, GreenlightCredentials, LightningTransaction, Network, PaymentTypeFilter,
};
use crate::node_service::NodeServiceBuilder;
use crate::{greenlight::Greenlight, node_service::NodeService};

static STATE: Lazy<Mutex<Option<Greenlight>>> = Lazy::new(|| Mutex::new(None));

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
    *STATE.lock().unwrap() = Some(greenlight);
    build_services()
}

pub fn start_node() -> Result<()> {
    block_on(build_services()?.start_node())
}

pub fn run_signer() -> Result<()> {
    block_on(build_services()?.run_signer())
}

pub fn sync() -> Result<()> {
    block_on(build_services()?.sync())
}

pub fn list_transactions(
    filter: PaymentTypeFilter,
    from_timestamp: Option<i64>,
    to_timestamp: Option<i64>,
) -> Result<Vec<LightningTransaction>> {
    block_on(build_services()?.list_transactions(filter, from_timestamp, to_timestamp))
}

fn build_services() -> Result<NodeService> {
    let g = STATE.lock().unwrap().clone();
    let greenlight = g
        .ok_or("greenlight is not initialized")
        .map_err(|e| anyhow!(e))?;

    Ok(block_on(
        block_on(
            NodeServiceBuilder::default()
                .config(Config::default())
                .client(Box::new(greenlight))
                .client_grpc_init_from_config(),
        )
        .build(),
    ))
}

fn block_on<F: Future>(future: F) -> F::Output {
    tokio::runtime::Builder::new_current_thread()
        .enable_all()
        .build()
        .unwrap()
        .block_on(future)
}
