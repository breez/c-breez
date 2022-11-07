use crate::fiat::FiatCurrency;
use crate::lsp::LspInformation;
use lazy_static::lazy_static;
use std::future::Future;
use std::sync::Mutex;
use tokio::sync::mpsc;

use anyhow::{anyhow, Result};
use lightning_invoice::RawInvoice;

use crate::models::{
    Config, GreenlightCredentials, LightningTransaction, Network, NodeState, PaymentTypeFilter,
};
use crate::node_service::NodeServiceBuilder;
use crate::{greenlight::Greenlight, node_service::NodeService};

lazy_static! {
    static ref STATE: Mutex<Option<Greenlight>> = Mutex::new(None);
    static ref SIGNER_SHUTDOWN: Mutex<Option<mpsc::Sender::<()>>> = Mutex::new(None);
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
) -> Result<()> {
    let greenlight = block_on(Greenlight::new(network, seed, creds))?;
    *STATE.lock().unwrap() = Some(greenlight.clone());
    block_on(build_services())
        .map(|_| ())
        .map_err(|e| anyhow!(e))
}

pub fn start_node() -> Result<()> {
    block_on(async { build_services().await?.start_node().await })
}

pub fn run_signer() -> Result<()> {
    let shutdown = SIGNER_SHUTDOWN.lock().unwrap().clone();
    match shutdown {
        Some(_) => Err(anyhow!("Signer is already running")),
        None => {
            let (tx, rec) = mpsc::channel::<()>(1);
            *SIGNER_SHUTDOWN.lock().unwrap() = Some(tx);
            std::thread::spawn(move || {
                block_on(async move { build_services().await?.run_signer(rec).await })
            });

            Ok(())
        }
    }
}

pub fn stop_signer() -> Result<()> {
    let shutdown = SIGNER_SHUTDOWN.lock().unwrap().clone();
    match shutdown {
        None => Err(anyhow!("Signer is not running")),
        Some(s) => {
            block_on(async move { s.send(()).await })?;
            *SIGNER_SHUTDOWN.lock().unwrap() = None;
            Ok(())
        }
    }
}

pub fn sync() -> Result<()> {
    block_on(async { build_services().await?.sync().await })
}

pub fn list_lsps() -> Result<Vec<LspInformation>> {
    block_on(async { build_services().await?.list_lsps().await })
}

pub fn set_lsp_id(lsp_id: String) -> Result<()> {
    block_on(async { build_services().await?.set_lsp_id(lsp_id) })
}

pub fn get_node_state() -> Result<Option<NodeState>> {
    block_on(async { build_services().await?.get_node_state() })
}

pub fn fetch_rates() -> Result<Vec<(String, f64)>> {
    block_on(async { build_services().await?.fetch_rates().await })
}

pub fn list_fiat_currencies() -> Result<Vec<FiatCurrency>> {
    block_on(async { build_services().await?.list_fiat_currencies() })
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

pub fn request_payment(
    amount_sats: u64,
    description: String
) -> Result<RawInvoice> {
    block_on(async {
        build_services()
            .await?
            .request_payment(amount_sats, description.to_string())
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
