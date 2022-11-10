use crate::fiat::{FiatCurrency, Rate};
use crate::lsp::LspInformation;
use lazy_static::lazy_static;
use std::future::Future;
use std::sync::Mutex;
use tokio::sync::mpsc;

use anyhow::{anyhow, Result};

use crate::invoice::LNInvoice;
use crate::models::{
    Config, FeeratePreset, GreenlightCredentials, LightningTransaction, Network, NodeState,
    PaymentTypeFilter,
};
use crate::node_service::NodeServiceBuilder;
use crate::{greenlight::Greenlight, node_service::NodeService};

use bip39::{Mnemonic, Language, Seed};
use crate::invoice::{self};

lazy_static! {
    static ref STATE: Mutex<Option<Greenlight>> = Mutex::new(None);
    static ref SIGNER_SHUTDOWN: Mutex<Option<mpsc::Sender::<()>>> = Mutex::new(None);
}

pub fn register_node(network: Network, seed: Vec<u8>) -> Result<GreenlightCredentials> {
    let creds = block_on(Greenlight::register(network, seed.clone()))?;
    create_node_services(crate::models::Config::default(), seed, creds.clone())?;
    Ok(creds)
}

pub fn recover_node(network: Network, seed: Vec<u8>) -> Result<GreenlightCredentials> {
    let creds = block_on(Greenlight::recover(network, seed.clone()))?;
    create_node_services(crate::models::Config::default(), seed, creds.clone())?;

    Ok(creds)
}

pub fn create_node_services(
    breez_config: Config,
    seed: Vec<u8>,
    creds: GreenlightCredentials,
) -> Result<()> {
    let greenlight = block_on(Greenlight::new(breez_config, seed, creds))?;
    *STATE.lock().unwrap() = Some(greenlight);
    block_on(build_services())
        .map(|_| ())
        .map_err(|e| anyhow!(e))?;
    run_signer()?;
    start_node()?;
    sync()
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
    block_on(async { build_services().await?.set_lsp_id(lsp_id).await })?;
    sync()
}

pub fn get_node_state() -> Result<Option<NodeState>> {
    block_on(async { build_services().await?.get_node_state() })
}

pub fn fetch_rates() -> Result<Vec<Rate>> {
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

pub fn pay(bolt11: String) -> Result<()> {
    block_on(async { build_services().await?.pay(bolt11).await })
}

pub fn keysend(node_id: String, amount_sats: u64) -> Result<()> {
    block_on(async { build_services().await?.keysend(node_id, amount_sats).await })
}

pub fn request_payment(amount_sats: u64, description: String) -> Result<LNInvoice> {
    block_on(async {
        build_services()
            .await?
            .request_payment(amount_sats, description.to_string())
            .await
    })
}

pub fn close_lsp_channels() -> Result<()> {
    block_on(async { build_services().await?.close_lsp_channels().await })
}

pub fn withdraw(to_address: String, feerate_preset: FeeratePreset) -> Result<()> {
    block_on(async {
        build_services()
            .await?
            .withdraw(to_address, feerate_preset)
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

// These functions are exposed temporarily for integration purposes

pub fn parse_invoice(invoice: String) -> Result<LNInvoice> {
 return invoice::parse_invoice(&invoice);
}

/// Attempts to convert the phrase to a mnemonic, then to a seed.
///
/// If the phrase is not a valid mnemonic, an error is returned.
pub fn mnemonic_to_seed(phrase: String) -> Result<Vec<u8>> {
 let mnemonic = Mnemonic::from_phrase(&phrase, Language::English)?;
 let seed = Seed::new(&mnemonic, "");
 Ok(seed.as_bytes().to_vec())
}
