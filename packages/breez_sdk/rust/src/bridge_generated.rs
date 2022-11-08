#![allow(
    non_camel_case_types,
    unused,
    clippy::redundant_closure,
    clippy::useless_conversion,
    clippy::unit_arg,
    clippy::double_parens,
    non_snake_case,
    clippy::too_many_arguments
)]
// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`@ 1.49.1.

use crate::binding::*;
use core::panic::UnwindSafe;
use flutter_rust_bridge::*;

// Section: imports

use crate::fiat::CurrencyInfo;
use crate::fiat::FiatCurrency;
use crate::fiat::LocaleOverrides;
use crate::fiat::LocalizedName;
use crate::fiat::Rate;
use crate::fiat::Symbol;
use crate::invoice::LNInvoice;
use crate::invoice::RouteHint;
use crate::invoice::RouteHintHop;
use crate::lsp::LspInformation;
use crate::models::Config;
use crate::models::GreenlightCredentials;
use crate::models::LightningTransaction;
use crate::models::Network;
use crate::models::NodeState;
use crate::models::PaymentTypeFilter;

// Section: wire functions

fn wire_register_node_impl(
    port_: MessagePort,
    network: impl Wire2Api<Network> + UnwindSafe,
    seed: impl Wire2Api<Vec<u8>> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "register_node",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_network = network.wire2api();
            let api_seed = seed.wire2api();
            move |task_callback| register_node(api_network, api_seed)
        },
    )
}
fn wire_recover_node_impl(
    port_: MessagePort,
    network: impl Wire2Api<Network> + UnwindSafe,
    seed: impl Wire2Api<Vec<u8>> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "recover_node",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_network = network.wire2api();
            let api_seed = seed.wire2api();
            move |task_callback| recover_node(api_network, api_seed)
        },
    )
}
fn wire_create_node_services_impl(
    port_: MessagePort,
    breez_config: impl Wire2Api<Config> + UnwindSafe,
    seed: impl Wire2Api<Vec<u8>> + UnwindSafe,
    creds: impl Wire2Api<GreenlightCredentials> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "create_node_services",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_breez_config = breez_config.wire2api();
            let api_seed = seed.wire2api();
            let api_creds = creds.wire2api();
            move |task_callback| create_node_services(api_breez_config, api_seed, api_creds)
        },
    )
}
fn wire_start_node_impl(port_: MessagePort) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "start_node",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || move |task_callback| start_node(),
    )
}
fn wire_run_signer_impl(port_: MessagePort) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "run_signer",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || move |task_callback| run_signer(),
    )
}
fn wire_stop_signer_impl(port_: MessagePort) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "stop_signer",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || move |task_callback| stop_signer(),
    )
}
fn wire_sync_impl(port_: MessagePort) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "sync",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || move |task_callback| sync(),
    )
}
fn wire_list_lsps_impl(port_: MessagePort) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "list_lsps",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || move |task_callback| list_lsps(),
    )
}
fn wire_set_lsp_id_impl(port_: MessagePort, lsp_id: impl Wire2Api<String> + UnwindSafe) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "set_lsp_id",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_lsp_id = lsp_id.wire2api();
            move |task_callback| set_lsp_id(api_lsp_id)
        },
    )
}
fn wire_get_node_state_impl(port_: MessagePort) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "get_node_state",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || move |task_callback| get_node_state(),
    )
}
fn wire_fetch_rates_impl(port_: MessagePort) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "fetch_rates",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || move |task_callback| fetch_rates(),
    )
}
fn wire_list_fiat_currencies_impl(port_: MessagePort) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "list_fiat_currencies",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || move |task_callback| list_fiat_currencies(),
    )
}
fn wire_list_transactions_impl(
    port_: MessagePort,
    filter: impl Wire2Api<PaymentTypeFilter> + UnwindSafe,
    from_timestamp: impl Wire2Api<Option<i64>> + UnwindSafe,
    to_timestamp: impl Wire2Api<Option<i64>> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "list_transactions",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_filter = filter.wire2api();
            let api_from_timestamp = from_timestamp.wire2api();
            let api_to_timestamp = to_timestamp.wire2api();
            move |task_callback| list_transactions(api_filter, api_from_timestamp, api_to_timestamp)
        },
    )
}
fn wire_pay_impl(port_: MessagePort, bolt11: impl Wire2Api<String> + UnwindSafe) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "pay",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_bolt11 = bolt11.wire2api();
            move |task_callback| pay(api_bolt11)
        },
    )
}
fn wire_request_payment_impl(
    port_: MessagePort,
    amount_sats: impl Wire2Api<u64> + UnwindSafe,
    description: impl Wire2Api<String> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "request_payment",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_amount_sats = amount_sats.wire2api();
            let api_description = description.wire2api();
            move |task_callback| request_payment(api_amount_sats, api_description)
        },
    )
}
// Section: wrapper structs

// Section: static checks

// Section: allocate functions

// Section: impl Wire2Api

pub trait Wire2Api<T> {
    fn wire2api(self) -> T;
}

impl<T, S> Wire2Api<Option<T>> for *mut S
where
    *mut S: Wire2Api<T>,
{
    fn wire2api(self) -> Option<T> {
        (!self.is_null()).then(|| self.wire2api())
    }
}

impl Wire2Api<i64> for *mut i64 {
    fn wire2api(self) -> i64 {
        unsafe { *support::box_from_leak_ptr(self) }
    }
}

impl Wire2Api<i32> for i32 {
    fn wire2api(self) -> i32 {
        self
    }
}
impl Wire2Api<i64> for i64 {
    fn wire2api(self) -> i64 {
        self
    }
}
impl Wire2Api<Network> for i32 {
    fn wire2api(self) -> Network {
        match self {
            0 => Network::Bitcoin,
            1 => Network::Testnet,
            2 => Network::Signet,
            3 => Network::Regtest,
            _ => unreachable!("Invalid variant for Network: {}", self),
        }
    }
}

impl Wire2Api<PaymentTypeFilter> for i32 {
    fn wire2api(self) -> PaymentTypeFilter {
        match self {
            0 => PaymentTypeFilter::Sent,
            1 => PaymentTypeFilter::Received,
            2 => PaymentTypeFilter::All,
            _ => unreachable!("Invalid variant for PaymentTypeFilter: {}", self),
        }
    }
}
impl Wire2Api<u32> for u32 {
    fn wire2api(self) -> u32 {
        self
    }
}
impl Wire2Api<u64> for u64 {
    fn wire2api(self) -> u64 {
        self
    }
}
impl Wire2Api<u8> for u8 {
    fn wire2api(self) -> u8 {
        self
    }
}

// Section: impl IntoDart

impl support::IntoDart for CurrencyInfo {
    fn into_dart(self) -> support::DartAbi {
        vec![
            self.name.into_dart(),
            self.fraction_size.into_dart(),
            self.spacing.into_dart(),
            self.symbol.into_dart(),
            self.uniq_symbol.into_dart(),
            self.localized_name.into_dart(),
            self.locale_overrides.into_dart(),
        ]
        .into_dart()
    }
}
impl support::IntoDartExceptPrimitive for CurrencyInfo {}

impl support::IntoDart for FiatCurrency {
    fn into_dart(self) -> support::DartAbi {
        vec![self.id.into_dart(), self.info.into_dart()].into_dart()
    }
}
impl support::IntoDartExceptPrimitive for FiatCurrency {}

impl support::IntoDart for GreenlightCredentials {
    fn into_dart(self) -> support::DartAbi {
        vec![self.device_key.into_dart(), self.device_cert.into_dart()].into_dart()
    }
}
impl support::IntoDartExceptPrimitive for GreenlightCredentials {}

impl support::IntoDart for LightningTransaction {
    fn into_dart(self) -> support::DartAbi {
        vec![
            self.payment_type.into_dart(),
            self.payment_hash.into_dart(),
            self.payment_time.into_dart(),
            self.label.into_dart(),
            self.destination_pubkey.into_dart(),
            self.amount_msat.into_dart(),
            self.fees_msat.into_dart(),
            self.payment_preimage.into_dart(),
            self.keysend.into_dart(),
            self.bolt11.into_dart(),
            self.pending.into_dart(),
            self.description.into_dart(),
        ]
        .into_dart()
    }
}
impl support::IntoDartExceptPrimitive for LightningTransaction {}

impl support::IntoDart for LNInvoice {
    fn into_dart(self) -> support::DartAbi {
        vec![
            self.bolt11.into_dart(),
            self.payee_pubkey.into_dart(),
            self.payment_hash.into_dart(),
            self.description.into_dart(),
            self.amount_msat.into_dart(),
            self.timestamp.into_dart(),
            self.expiry.into_dart(),
            self.routing_hints.into_dart(),
            self.payment_secret.into_dart(),
        ]
        .into_dart()
    }
}
impl support::IntoDartExceptPrimitive for LNInvoice {}

impl support::IntoDart for LocaleOverrides {
    fn into_dart(self) -> support::DartAbi {
        vec![
            self.locale.into_dart(),
            self.spacing.into_dart(),
            self.symbol.into_dart(),
        ]
        .into_dart()
    }
}
impl support::IntoDartExceptPrimitive for LocaleOverrides {}

impl support::IntoDart for LocalizedName {
    fn into_dart(self) -> support::DartAbi {
        vec![self.locale.into_dart(), self.name.into_dart()].into_dart()
    }
}
impl support::IntoDartExceptPrimitive for LocalizedName {}

impl support::IntoDart for LspInformation {
    fn into_dart(self) -> support::DartAbi {
        vec![
            self.id.into_dart(),
            self.name.into_dart(),
            self.widget_url.into_dart(),
            self.pubkey.into_dart(),
            self.host.into_dart(),
            self.channel_capacity.into_dart(),
            self.target_conf.into_dart(),
            self.base_fee_msat.into_dart(),
            self.fee_rate.into_dart(),
            self.time_lock_delta.into_dart(),
            self.min_htlc_msat.into_dart(),
            self.channel_fee_permyriad.into_dart(),
            self.lsp_pubkey.into_dart(),
            self.max_inactive_duration.into_dart(),
            self.channel_minimum_fee_msat.into_dart(),
        ]
        .into_dart()
    }
}
impl support::IntoDartExceptPrimitive for LspInformation {}

impl support::IntoDart for NodeState {
    fn into_dart(self) -> support::DartAbi {
        vec![
            self.id.into_dart(),
            self.block_height.into_dart(),
            self.channels_balance_msat.into_dart(),
            self.onchain_balance_msat.into_dart(),
            self.max_payable_msat.into_dart(),
            self.max_receivable_msat.into_dart(),
            self.max_single_payment_amount_msat.into_dart(),
            self.max_chan_reserve_msats.into_dart(),
            self.connected_peers.into_dart(),
            self.inbound_liquidity_msats.into_dart(),
        ]
        .into_dart()
    }
}
impl support::IntoDartExceptPrimitive for NodeState {}

impl support::IntoDart for Rate {
    fn into_dart(self) -> support::DartAbi {
        vec![self.coin.into_dart(), self.value.into_dart()].into_dart()
    }
}
impl support::IntoDartExceptPrimitive for Rate {}

impl support::IntoDart for RouteHint {
    fn into_dart(self) -> support::DartAbi {
        vec![self.0.into_dart()].into_dart()
    }
}
impl support::IntoDartExceptPrimitive for RouteHint {}

impl support::IntoDart for RouteHintHop {
    fn into_dart(self) -> support::DartAbi {
        vec![
            self.src_node_id.into_dart(),
            self.short_channel_id.into_dart(),
            self.fees_base_msat.into_dart(),
            self.fees_proportional_millionths.into_dart(),
            self.cltv_expiry_delta.into_dart(),
            self.htlc_minimum_msat.into_dart(),
            self.htlc_maximum_msat.into_dart(),
        ]
        .into_dart()
    }
}
impl support::IntoDartExceptPrimitive for RouteHintHop {}

impl support::IntoDart for Symbol {
    fn into_dart(self) -> support::DartAbi {
        vec![
            self.grapheme.into_dart(),
            self.template.into_dart(),
            self.rtl.into_dart(),
            self.position.into_dart(),
        ]
        .into_dart()
    }
}
impl support::IntoDartExceptPrimitive for Symbol {}

// Section: executor

support::lazy_static! {
    pub static ref FLUTTER_RUST_BRIDGE_HANDLER: support::DefaultHandler = Default::default();
}

#[cfg(not(target_family = "wasm"))]
#[path = "bridge_generated.io.rs"]
mod io;
#[cfg(not(target_family = "wasm"))]
pub use io::*;