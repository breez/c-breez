use crate::fiat::{FiatCurrency, Rate};
use crate::lsp::LspInformation;
use lazy_static::lazy_static;
use std::future::Future;
use std::sync::{Arc, Mutex};
use tokio::sync::mpsc;

use anyhow::{anyhow, Result};

use crate::invoice::LNInvoice;
use crate::models::{
    Config, FeeratePreset, GreenlightCredentials, LightningTransaction, Network, NodeState,
    PaymentTypeFilter,
};
use crate::{greenlight::Greenlight, node_service::NodeService};

use crate::input_parser::InputType;
use crate::invoice::{self};
use bip39::{Language, Mnemonic, Seed};

lazy_static! {
    static ref NODE_SERVICE_STATE: Mutex<Option<Arc<NodeService>>> = Mutex::new(None);
    static ref SIGNER_SHUTDOWN: Mutex<Option<mpsc::Sender::<()>>> = Mutex::new(None);
}

/// Register a new node in the cloud and return credentials to interact with it
///
/// # Arguments
///
/// * `network` - The network type which is one of (Bitcoin, Testnet, Signet, Regtest)
/// * `seed` - The node private key
/// * `config` - The sdk configuration
pub fn register_node(
    network: Network,
    seed: Vec<u8>,
    config: Option<Config>,
) -> Result<GreenlightCredentials> {
    let creds = block_on(Greenlight::register(network, seed.clone()))?;
    init_node(config, seed, creds.clone())?;
    Ok(creds)
}

/// Recover an existing node from the cloud and return credentials to interact with it
///
/// # Arguments
///
/// * `network` - The network type which is one of (Bitcoin, Testnet, Signet, Regtest)
/// * `seed` - The node private key
/// * `config` - The sdk configuration
pub fn recover_node(
    network: Network,
    seed: Vec<u8>,
    config: Option<Config>,
) -> Result<GreenlightCredentials> {
    let creds = block_on(Greenlight::recover(network, seed.clone()))?;
    init_node(config, seed, creds.clone())?;

    Ok(creds)
}

/// init_node initialized the global NodeService, schedule the node to run in the cloud and
/// run the signer. This must be called in order to start comunicate with the node
///
/// # Arguments
///
/// * `config` - The sdk configuration
/// * `seed` - The node private key
/// * `creds` - The greenlight credentials
///
pub fn init_node(
    config: Option<Config>,
    seed: Vec<u8>,
    creds: GreenlightCredentials,
) -> Result<()> {
    let sdk_config = config.unwrap_or(Config::default());

    // greenlight is the implementation of NodeAPI
    let node_api = block_on(Greenlight::new(sdk_config.clone(), seed, creds))?;
    let node_services = NodeService::from_config(sdk_config.clone(), Box::new(node_api))?;
    *NODE_SERVICE_STATE.lock().unwrap() = Some(Arc::new(node_services));

    // run the signer, schedule the node in the cloud and sync state
    run_signer_in_thread()?;
    block_on(async { get_node_service()?.schedule_and_sync().await })
}

/// Cleanup node resources and stop the signer.
pub fn stop_node() -> Result<()> {
    stop_signer()?;
    *NODE_SERVICE_STATE.lock().unwrap() = None;
    Ok(())
}

/// pay a bolt11 invoice
///
/// # Arguments
///
/// * `bolt11` - The bolt11 invoice
pub fn send_payment(bolt11: String) -> Result<()> {
    block_on(async { get_node_service()?.send_payment(bolt11).await })
}

/// pay directly to a node id using keysend
///
/// # Arguments
///
/// * `node_id` - The destination node_id
/// * `amount_sats` - The amount to pay in satoshis
pub fn send_spontaneous_payment(node_id: String, amount_sats: u64) -> Result<()> {
    block_on(async {
        get_node_service()?
            .send_spontaneous_payment(node_id, amount_sats)
            .await
    })
}

/// Creates an bolt11 payment request.
/// This also works when the node doesn't have any channels and need inbound liquidity.
/// In such case when the invoice is paid a new zero-conf channel will be open by the LSP,
/// providing inbound liquidity and the payment will be routed via this new channel.
///
/// # Arguments
///
/// * `description` - The bolt11 payment request description
/// * `amount_sats` - The amount to receive in satoshis
pub fn receive_payment(amount_sats: u64, description: String) -> Result<LNInvoice> {
    block_on(async {
        get_node_service()?
            .receive_payment(amount_sats, description.to_string())
            .await
    })
}

/// get the node state from the persistent storage
pub fn get_node_state() -> Result<Option<NodeState>> {
    block_on(async { get_node_service()?.get_node_state() })
}

/// list transactions (incoming/outgoing payments) from the persistent storage
pub fn list_transactions(
    filter: PaymentTypeFilter,
    from_timestamp: Option<i64>,
    to_timestamp: Option<i64>,
) -> Result<Vec<LightningTransaction>> {
    block_on(async {
        get_node_service()?
            .list_transactions(filter, from_timestamp, to_timestamp)
            .await
    })
}

/// List available lsps that can be selected by the user
pub fn list_lsps() -> Result<Vec<LspInformation>> {
    block_on(async { get_node_service()?.list_lsps().await })
}

/// Select the lsp to be used and provide inbound liquidity
pub fn set_lsp_id(lsp_id: String) -> Result<()> {
    block_on(async { get_node_service()?.set_lsp_id(lsp_id).await })
}

/// Fetch live rates of fiat currencies
pub fn fetch_rates() -> Result<Vec<Rate>> {
    block_on(async { get_node_service()?.fetch_rates().await })
}

/// List all available fiat currencies
pub fn list_fiat_currencies() -> Result<Vec<FiatCurrency>> {
    block_on(async { get_node_service()?.list_fiat_currencies() })
}

/// close all channels with the current lsp
pub fn close_lsp_channels() -> Result<()> {
    block_on(async { get_node_service()?.close_lsp_channels().await })
}

/// Withdraw on-chain funds in the wallet to an external btc address
pub fn withdraw(to_address: String, feerate_preset: FeeratePreset) -> Result<()> {
    block_on(async {
        get_node_service()?
            .withdraw(to_address, feerate_preset)
            .await
    })
}

fn get_node_service() -> Result<Arc<NodeService>> {
    let n = (*NODE_SERVICE_STATE.lock().unwrap()).clone();
    match n {
        Some(a) => Ok(a),
        None => Err(anyhow!("Node service was not initialized")),
    }
}

/// Run the signer in a separate thread.
/// This intended for internal use of the SDK and not recommended to use unless
/// you know what you are doing.
fn run_signer_in_thread() -> Result<()> {
    let shutdown = SIGNER_SHUTDOWN.lock().unwrap().clone();
    match shutdown {
        Some(_) => Err(anyhow!("Signer is already running")),
        None => {
            let (tx, rec) = mpsc::channel::<()>(1);
            *SIGNER_SHUTDOWN.lock().unwrap() = Some(tx);
            std::thread::spawn(move || {
                block_on(async move { get_node_service()?.run_signer(rec).await })
            });

            Ok(())
        }
    }
}

/// Stop the signer thread.
/// This intended for internal use of the SDK and not recommended to use unless
/// you know what you are doing.
fn stop_signer() -> Result<()> {
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

pub fn parse(s: String) -> Result<InputType> {
    crate::input_parser::parse(&s)
}

/// Attempts to convert the phrase to a mnemonic, then to a seed.
///
/// If the phrase is not a valid mnemonic, an error is returned.
pub fn mnemonic_to_seed(phrase: String) -> Result<Vec<u8>> {
    let mnemonic = Mnemonic::from_phrase(&phrase, Language::English)?;
    let seed = Seed::new(&mnemonic, "");
    Ok(seed.as_bytes().to_vec())
}
