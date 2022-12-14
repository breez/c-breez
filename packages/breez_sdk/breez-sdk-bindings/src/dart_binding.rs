use anyhow::{anyhow, Result};
use lightning_toolkit::{
    mnemonic_to_seed as sdk_mnemonic_to_seed, parse as sdk_parse_input,
    parse_invoice as sdk_parse_invoice, BitcoinAddressData, BreezEvent, BreezServices, Config,
    CurrencyInfo, EventListener, FeeratePreset, FiatCurrency, GreenlightCredentials, InputType,
    InvoicePaidDetails, LNInvoice, LocaleOverrides, LocalizedName, LogEntry, LspInformation,
    Network, NodeState, Payment, PaymentTypeFilter, Rate, RouteHint, RouteHintHop, SwapInfo,
    Symbol,
};

use flutter_rust_bridge::StreamSink;
use once_cell::sync::OnceCell;
use std::sync::Arc;

use crate::uniffi_binding::{self, BlockingBreezServices, LogStream, SDKError};

static BREEZ_SERVICES_INSTANCE: OnceCell<Arc<BlockingBreezServices>> = OnceCell::new();
static NOTIFICATION_STREAM: OnceCell<StreamSink<BreezEvent>> = OnceCell::new();
static LOG_STREAM: OnceCell<StreamSink<LogEntry>> = OnceCell::new();

struct DartEventListener;

impl EventListener for DartEventListener {
    fn on_event(&self, e: BreezEvent) {
        let s = NOTIFICATION_STREAM.get();
        if s.is_some() {
            s.unwrap().add(e);
        }
    }
}

struct DartLogStream {}

impl LogStream for DartLogStream {
    fn log(&self, l: LogEntry) {
        if let Some(s) = LOG_STREAM.get() {
            s.add(l);
        }
    }
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
    crate::uniffi_binding::register_node(network, seed, config)
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
    crate::uniffi_binding::recover_node(network, seed, config)
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
pub fn start(config: Option<Config>, seed: Vec<u8>, creds: GreenlightCredentials) -> Result<()> {
    let breez_services =
        crate::uniffi_binding::start(config, seed, creds, Box::new(DartEventListener {}))?;
    BREEZ_SERVICES_INSTANCE
        .set(breez_services.clone())
        .map_err(|_| anyhow!("static node services already set"))?;
    Ok(())
}

pub fn breez_events_stream(s: StreamSink<BreezEvent>) -> Result<()> {
    NOTIFICATION_STREAM
        .set(s)
        .map_err(|_| anyhow!("events stream already created"))?;
    Ok(())
}

pub fn breez_log_stream(s: StreamSink<LogEntry>) -> Result<()> {
    crate::uniffi_binding::set_log_stream(Box::new(DartLogStream {}))
}

/// Cleanup node resources and stop the signer.
pub fn stop_node() -> Result<()> {
    if let Some(s) = BREEZ_SERVICES_INSTANCE.get() {
        return s.stop();
    }

    Ok(())
}

/// pay a bolt11 invoice
///
/// # Arguments
///
/// * `bolt11` - The bolt11 invoice
pub fn send_payment(bolt11: String) -> Result<(), SDKError> {
    get_breez_services()?.send_payment(bolt11)
}

/// pay directly to a node id using keysend
///
/// # Arguments
///
/// * `node_id` - The destination node_id
/// * `amount_sats` - The amount to pay in satoshis
pub fn send_spontaneous_payment(node_id: String, amount_sats: u64) -> Result<(), SDKError> {
    get_breez_services()?.send_spontaneous_payment(node_id, amount_sats)
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
pub fn receive_payment(amount_sats: u64, description: String) -> Result<LNInvoice, SDKError> {
    get_breez_services()?.receive_payment(amount_sats, description.to_string())
}

/// get the node state from the persistent storage
pub fn node_info() -> Result<Option<NodeState>, SDKError> {
    get_breez_services()?.node_info()
}

/// list transactions (incoming/outgoing payments) from the persistent storage
pub fn list_payments(
    filter: PaymentTypeFilter,
    from_timestamp: Option<i64>,
    to_timestamp: Option<i64>,
) -> Result<Vec<Payment>, SDKError> {
    get_breez_services()?.list_payments(filter, from_timestamp, to_timestamp)
}

/// List available lsps that can be selected by the user
pub fn list_lsps() -> Result<Vec<LspInformation>, SDKError> {
    get_breez_services()?.list_lsps()
}

/// Select the lsp to be used and provide inbound liquidity
pub fn connect_lsp(lsp_id: String) -> Result<(), SDKError> {
    get_breez_services()?.connect_lsp(lsp_id)
}

/// Convenience method to look up LSP info based on current LSP ID
pub fn lsp_info() -> Result<LspInformation, SDKError> {
    get_breez_services()?.lsp_info()
}

/// Fetch live rates of fiat currencies
pub fn fetch_fiat_rates() -> Result<Vec<Rate>, SDKError> {
    get_breez_services()?.fetch_fiat_rates()
}

/// List all available fiat currencies
pub fn list_fiat_currencies() -> Result<Vec<FiatCurrency>, SDKError> {
    get_breez_services()?.list_fiat_currencies()
}

/// close all channels with the current lsp
pub fn close_lsp_channels() -> Result<(), SDKError> {
    get_breez_services()?.close_lsp_channels()
}

/// Withdraw on-chain funds in the wallet to an external btc address
pub fn sweep(to_address: String, feerate_preset: FeeratePreset) -> Result<(), SDKError> {
    get_breez_services()?.sweep(to_address, feerate_preset)
}

/// swaps

/// Onchain receive swap API
pub fn receive_onchain() -> Result<SwapInfo, SDKError> {
    get_breez_services()?.receive_onchain()
}

// list swaps history (all of them: expired, refunded and active)
pub fn list_refundables() -> Result<Vec<SwapInfo>, SDKError> {
    get_breez_services()?.list_refundables()
}

// construct and broadcast a refund transaction for a faile/expired swap
pub fn refund(
    swap_address: String,
    to_address: String,
    sat_per_vbyte: u32,
) -> Result<String, SDKError> {
    get_breez_services()?.refund(swap_address, to_address, sat_per_vbyte)
}

fn get_breez_services() -> Result<&'static BlockingBreezServices> {
    let n = BREEZ_SERVICES_INSTANCE.get();
    match n {
        Some(a) => Ok(a),
        None => Err(anyhow!("Node service was not initialized")),
    }
}

// These functions are exposed temporarily for integration purposes

pub fn parse_invoice(invoice: String) -> Result<LNInvoice> {
    return sdk_parse_invoice(&invoice);
}

pub fn parse(s: String) -> Result<InputType> {
    crate::uniffi_binding::parse_input(s).map_err(anyhow::Error::msg)
}

/// Attempts to convert the phrase to a mnemonic, then to a seed.
///
/// If the phrase is not a valid mnemonic, an error is returned.
pub fn mnemonic_to_seed(phrase: String) -> Result<Vec<u8>> {
    sdk_mnemonic_to_seed(phrase)
}
