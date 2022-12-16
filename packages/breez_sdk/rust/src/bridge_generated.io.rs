use super::*;
// Section: wire functions

#[no_mangle]
pub extern "C" fn wire_register_node(
    port_: i64,
    network: i32,
    seed: *mut wire_uint_8_list,
    config: *mut wire_Config,
) {
    wire_register_node_impl(port_, network, seed, config)
}

#[no_mangle]
pub extern "C" fn wire_recover_node(
    port_: i64,
    network: i32,
    seed: *mut wire_uint_8_list,
    config: *mut wire_Config,
) {
    wire_recover_node_impl(port_, network, seed, config)
}

#[no_mangle]
pub extern "C" fn wire_init_node(
    port_: i64,
    config: *mut wire_Config,
    seed: *mut wire_uint_8_list,
    creds: *mut wire_GreenlightCredentials,
) {
    wire_init_node_impl(port_, config, seed, creds)
}

#[no_mangle]
pub extern "C" fn wire_breez_events_stream(port_: i64) {
    wire_breez_events_stream_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_breez_log_stream(port_: i64) {
    wire_breez_log_stream_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_stop_node(port_: i64) {
    wire_stop_node_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_send_payment(port_: i64, bolt11: *mut wire_uint_8_list) {
    wire_send_payment_impl(port_, bolt11)
}

#[no_mangle]
pub extern "C" fn wire_send_spontaneous_payment(
    port_: i64,
    node_id: *mut wire_uint_8_list,
    amount_sats: u64,
) {
    wire_send_spontaneous_payment_impl(port_, node_id, amount_sats)
}

#[no_mangle]
pub extern "C" fn wire_receive_payment(
    port_: i64,
    amount_sats: u64,
    description: *mut wire_uint_8_list,
) {
    wire_receive_payment_impl(port_, amount_sats, description)
}

#[no_mangle]
pub extern "C" fn wire_node_info(port_: i64) {
    wire_node_info_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_list_payments(
    port_: i64,
    filter: i32,
    from_timestamp: *mut i64,
    to_timestamp: *mut i64,
) {
    wire_list_payments_impl(port_, filter, from_timestamp, to_timestamp)
}

#[no_mangle]
pub extern "C" fn wire_list_lsps(port_: i64) {
    wire_list_lsps_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_connect_lsp(port_: i64, lsp_id: *mut wire_uint_8_list) {
    wire_connect_lsp_impl(port_, lsp_id)
}

#[no_mangle]
pub extern "C" fn wire_lsp_info(port_: i64) {
    wire_lsp_info_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_fetch_fiat_rates(port_: i64) {
    wire_fetch_fiat_rates_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_list_fiat_currencies(port_: i64) {
    wire_list_fiat_currencies_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_close_lsp_channels(port_: i64) {
    wire_close_lsp_channels_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_sweep(port_: i64, to_address: *mut wire_uint_8_list, feerate_preset: i32) {
    wire_sweep_impl(port_, to_address, feerate_preset)
}

#[no_mangle]
pub extern "C" fn wire_receive_onchain(port_: i64) {
    wire_receive_onchain_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_list_refundables(port_: i64) {
    wire_list_refundables_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_refund(
    port_: i64,
    swap_address: *mut wire_uint_8_list,
    to_address: *mut wire_uint_8_list,
    sat_per_vbyte: u32,
) {
    wire_refund_impl(port_, swap_address, to_address, sat_per_vbyte)
}

#[no_mangle]
pub extern "C" fn wire_parse_invoice(port_: i64, invoice: *mut wire_uint_8_list) {
    wire_parse_invoice_impl(port_, invoice)
}

#[no_mangle]
pub extern "C" fn wire_parse(port_: i64, s: *mut wire_uint_8_list) {
    wire_parse_impl(port_, s)
}

#[no_mangle]
pub extern "C" fn wire_pay_lnurl(
    port_: i64,
    user_amount_sat: u64,
    comment: *mut wire_uint_8_list,
    req_data: *mut wire_LnUrlPayRequestData,
) {
    wire_pay_lnurl_impl(port_, user_amount_sat, comment, req_data)
}

#[no_mangle]
pub extern "C" fn wire_withdraw_lnurl(
    port_: i64,
    req_data: *mut wire_LnUrlWithdrawRequestData,
    invoice: *mut wire_LNInvoice,
) {
    wire_withdraw_lnurl_impl(port_, req_data, invoice)
}

#[no_mangle]
pub extern "C" fn wire_mnemonic_to_seed(port_: i64, phrase: *mut wire_uint_8_list) {
    wire_mnemonic_to_seed_impl(port_, phrase)
}

// Section: allocate functions

#[no_mangle]
pub extern "C" fn new_box_autoadd_config_0() -> *mut wire_Config {
    support::new_leak_box_ptr(wire_Config::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_greenlight_credentials_0() -> *mut wire_GreenlightCredentials {
    support::new_leak_box_ptr(wire_GreenlightCredentials::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_i64_0(value: i64) -> *mut i64 {
    support::new_leak_box_ptr(value)
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_ln_invoice_0() -> *mut wire_LNInvoice {
    support::new_leak_box_ptr(wire_LNInvoice::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_ln_url_pay_request_data_0() -> *mut wire_LnUrlPayRequestData {
    support::new_leak_box_ptr(wire_LnUrlPayRequestData::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_ln_url_withdraw_request_data_0(
) -> *mut wire_LnUrlWithdrawRequestData {
    support::new_leak_box_ptr(wire_LnUrlWithdrawRequestData::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_u64_0(value: u64) -> *mut u64 {
    support::new_leak_box_ptr(value)
}

#[no_mangle]
pub extern "C" fn new_list_route_hint_0(len: i32) -> *mut wire_list_route_hint {
    let wrap = wire_list_route_hint {
        ptr: support::new_leak_vec_ptr(<wire_RouteHint>::new_with_null_ptr(), len),
        len,
    };
    support::new_leak_box_ptr(wrap)
}

#[no_mangle]
pub extern "C" fn new_list_route_hint_hop_0(len: i32) -> *mut wire_list_route_hint_hop {
    let wrap = wire_list_route_hint_hop {
        ptr: support::new_leak_vec_ptr(<wire_RouteHintHop>::new_with_null_ptr(), len),
        len,
    };
    support::new_leak_box_ptr(wrap)
}

#[no_mangle]
pub extern "C" fn new_uint_8_list_0(len: i32) -> *mut wire_uint_8_list {
    let ans = wire_uint_8_list {
        ptr: support::new_leak_vec_ptr(Default::default(), len),
        len,
    };
    support::new_leak_box_ptr(ans)
}

// Section: related functions

// Section: impl Wire2Api

impl Wire2Api<String> for *mut wire_uint_8_list {
    fn wire2api(self) -> String {
        let vec: Vec<u8> = self.wire2api();
        String::from_utf8_lossy(&vec).into_owned()
    }
}
impl Wire2Api<Config> for *mut wire_Config {
    fn wire2api(self) -> Config {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<Config>::wire2api(*wrap).into()
    }
}
impl Wire2Api<GreenlightCredentials> for *mut wire_GreenlightCredentials {
    fn wire2api(self) -> GreenlightCredentials {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<GreenlightCredentials>::wire2api(*wrap).into()
    }
}

impl Wire2Api<LNInvoice> for *mut wire_LNInvoice {
    fn wire2api(self) -> LNInvoice {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<LNInvoice>::wire2api(*wrap).into()
    }
}
impl Wire2Api<LnUrlPayRequestData> for *mut wire_LnUrlPayRequestData {
    fn wire2api(self) -> LnUrlPayRequestData {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<LnUrlPayRequestData>::wire2api(*wrap).into()
    }
}
impl Wire2Api<LnUrlWithdrawRequestData> for *mut wire_LnUrlWithdrawRequestData {
    fn wire2api(self) -> LnUrlWithdrawRequestData {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<LnUrlWithdrawRequestData>::wire2api(*wrap).into()
    }
}

impl Wire2Api<Config> for wire_Config {
    fn wire2api(self) -> Config {
        Config {
            breezserver: self.breezserver.wire2api(),
            mempoolspace_url: self.mempoolspace_url.wire2api(),
            working_dir: self.working_dir.wire2api(),
            network: self.network.wire2api(),
            payment_timeout_sec: self.payment_timeout_sec.wire2api(),
            default_lsp_id: self.default_lsp_id.wire2api(),
        }
    }
}

impl Wire2Api<GreenlightCredentials> for wire_GreenlightCredentials {
    fn wire2api(self) -> GreenlightCredentials {
        GreenlightCredentials {
            device_key: self.device_key.wire2api(),
            device_cert: self.device_cert.wire2api(),
        }
    }
}

impl Wire2Api<Vec<RouteHint>> for *mut wire_list_route_hint {
    fn wire2api(self) -> Vec<RouteHint> {
        let vec = unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        };
        vec.into_iter().map(Wire2Api::wire2api).collect()
    }
}
impl Wire2Api<Vec<RouteHintHop>> for *mut wire_list_route_hint_hop {
    fn wire2api(self) -> Vec<RouteHintHop> {
        let vec = unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        };
        vec.into_iter().map(Wire2Api::wire2api).collect()
    }
}
impl Wire2Api<LNInvoice> for wire_LNInvoice {
    fn wire2api(self) -> LNInvoice {
        LNInvoice {
            bolt11: self.bolt11.wire2api(),
            payee_pubkey: self.payee_pubkey.wire2api(),
            payment_hash: self.payment_hash.wire2api(),
            description: self.description.wire2api(),
            description_hash: self.description_hash.wire2api(),
            amount_msat: self.amount_msat.wire2api(),
            timestamp: self.timestamp.wire2api(),
            expiry: self.expiry.wire2api(),
            routing_hints: self.routing_hints.wire2api(),
            payment_secret: self.payment_secret.wire2api(),
        }
    }
}
impl Wire2Api<LnUrlPayRequestData> for wire_LnUrlPayRequestData {
    fn wire2api(self) -> LnUrlPayRequestData {
        LnUrlPayRequestData {
            callback: self.callback.wire2api(),
            min_sendable: self.min_sendable.wire2api(),
            max_sendable: self.max_sendable.wire2api(),
            metadata_str: self.metadata_str.wire2api(),
            comment_allowed: self.comment_allowed.wire2api(),
        }
    }
}
impl Wire2Api<LnUrlWithdrawRequestData> for wire_LnUrlWithdrawRequestData {
    fn wire2api(self) -> LnUrlWithdrawRequestData {
        LnUrlWithdrawRequestData {
            callback: self.callback.wire2api(),
            k1: self.k1.wire2api(),
            default_description: self.default_description.wire2api(),
            min_withdrawable: self.min_withdrawable.wire2api(),
            max_withdrawable: self.max_withdrawable.wire2api(),
        }
    }
}

impl Wire2Api<RouteHint> for wire_RouteHint {
    fn wire2api(self) -> RouteHint {
        RouteHint {
            hops: self.hops.wire2api(),
        }
    }
}
impl Wire2Api<RouteHintHop> for wire_RouteHintHop {
    fn wire2api(self) -> RouteHintHop {
        RouteHintHop {
            src_node_id: self.src_node_id.wire2api(),
            short_channel_id: self.short_channel_id.wire2api(),
            fees_base_msat: self.fees_base_msat.wire2api(),
            fees_proportional_millionths: self.fees_proportional_millionths.wire2api(),
            cltv_expiry_delta: self.cltv_expiry_delta.wire2api(),
            htlc_minimum_msat: self.htlc_minimum_msat.wire2api(),
            htlc_maximum_msat: self.htlc_maximum_msat.wire2api(),
        }
    }
}

impl Wire2Api<Vec<u8>> for *mut wire_uint_8_list {
    fn wire2api(self) -> Vec<u8> {
        unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        }
    }
}

// Section: wire structs

#[repr(C)]
#[derive(Clone)]
pub struct wire_Config {
    breezserver: *mut wire_uint_8_list,
    mempoolspace_url: *mut wire_uint_8_list,
    working_dir: *mut wire_uint_8_list,
    network: i32,
    payment_timeout_sec: u32,
    default_lsp_id: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_GreenlightCredentials {
    device_key: *mut wire_uint_8_list,
    device_cert: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_list_route_hint {
    ptr: *mut wire_RouteHint,
    len: i32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_list_route_hint_hop {
    ptr: *mut wire_RouteHintHop,
    len: i32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_LNInvoice {
    bolt11: *mut wire_uint_8_list,
    payee_pubkey: *mut wire_uint_8_list,
    payment_hash: *mut wire_uint_8_list,
    description: *mut wire_uint_8_list,
    description_hash: *mut wire_uint_8_list,
    amount_msat: *mut u64,
    timestamp: u64,
    expiry: u64,
    routing_hints: *mut wire_list_route_hint,
    payment_secret: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_LnUrlPayRequestData {
    callback: *mut wire_uint_8_list,
    min_sendable: u64,
    max_sendable: u64,
    metadata_str: *mut wire_uint_8_list,
    comment_allowed: usize,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_LnUrlWithdrawRequestData {
    callback: *mut wire_uint_8_list,
    k1: *mut wire_uint_8_list,
    default_description: *mut wire_uint_8_list,
    min_withdrawable: u64,
    max_withdrawable: u64,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_RouteHint {
    hops: *mut wire_list_route_hint_hop,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_RouteHintHop {
    src_node_id: *mut wire_uint_8_list,
    short_channel_id: u64,
    fees_base_msat: u32,
    fees_proportional_millionths: u32,
    cltv_expiry_delta: u64,
    htlc_minimum_msat: *mut u64,
    htlc_maximum_msat: *mut u64,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_uint_8_list {
    ptr: *mut u8,
    len: i32,
}

// Section: impl NewWithNullPtr

pub trait NewWithNullPtr {
    fn new_with_null_ptr() -> Self;
}

impl<T> NewWithNullPtr for *mut T {
    fn new_with_null_ptr() -> Self {
        std::ptr::null_mut()
    }
}

impl NewWithNullPtr for wire_Config {
    fn new_with_null_ptr() -> Self {
        Self {
            breezserver: core::ptr::null_mut(),
            mempoolspace_url: core::ptr::null_mut(),
            working_dir: core::ptr::null_mut(),
            network: Default::default(),
            payment_timeout_sec: Default::default(),
            default_lsp_id: core::ptr::null_mut(),
        }
    }
}

impl NewWithNullPtr for wire_GreenlightCredentials {
    fn new_with_null_ptr() -> Self {
        Self {
            device_key: core::ptr::null_mut(),
            device_cert: core::ptr::null_mut(),
        }
    }
}

impl NewWithNullPtr for wire_LNInvoice {
    fn new_with_null_ptr() -> Self {
        Self {
            bolt11: core::ptr::null_mut(),
            payee_pubkey: core::ptr::null_mut(),
            payment_hash: core::ptr::null_mut(),
            description: core::ptr::null_mut(),
            description_hash: core::ptr::null_mut(),
            amount_msat: core::ptr::null_mut(),
            timestamp: Default::default(),
            expiry: Default::default(),
            routing_hints: core::ptr::null_mut(),
            payment_secret: core::ptr::null_mut(),
        }
    }
}

impl NewWithNullPtr for wire_LnUrlPayRequestData {
    fn new_with_null_ptr() -> Self {
        Self {
            callback: core::ptr::null_mut(),
            min_sendable: Default::default(),
            max_sendable: Default::default(),
            metadata_str: core::ptr::null_mut(),
            comment_allowed: Default::default(),
        }
    }
}

impl NewWithNullPtr for wire_LnUrlWithdrawRequestData {
    fn new_with_null_ptr() -> Self {
        Self {
            callback: core::ptr::null_mut(),
            k1: core::ptr::null_mut(),
            default_description: core::ptr::null_mut(),
            min_withdrawable: Default::default(),
            max_withdrawable: Default::default(),
        }
    }
}

impl NewWithNullPtr for wire_RouteHint {
    fn new_with_null_ptr() -> Self {
        Self {
            hops: core::ptr::null_mut(),
        }
    }
}

impl NewWithNullPtr for wire_RouteHintHop {
    fn new_with_null_ptr() -> Self {
        Self {
            src_node_id: core::ptr::null_mut(),
            short_channel_id: Default::default(),
            fees_base_msat: Default::default(),
            fees_proportional_millionths: Default::default(),
            cltv_expiry_delta: Default::default(),
            htlc_minimum_msat: core::ptr::null_mut(),
            htlc_maximum_msat: core::ptr::null_mut(),
        }
    }
}

// Section: sync execution mode utility

#[no_mangle]
pub extern "C" fn free_WireSyncReturnStruct(val: support::WireSyncReturnStruct) {
    unsafe {
        let _ = support::vec_from_leak_ptr(val.ptr, val.len);
    }
}
