use super::*;
// Section: wire functions

#[no_mangle]
pub extern "C" fn wire_register_node(port_: i64, network: i32, seed: *mut wire_uint_8_list) {
    wire_register_node_impl(port_, network, seed)
}

#[no_mangle]
pub extern "C" fn wire_recover_node(port_: i64, network: i32, seed: *mut wire_uint_8_list) {
    wire_recover_node_impl(port_, network, seed)
}

#[no_mangle]
pub extern "C" fn wire_start_node(port_: i64) {
    wire_start_node_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_run_signer(port_: i64) {
    wire_run_signer_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_stop_signer(port_: i64) {
    wire_stop_signer_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_sync(port_: i64) {
    wire_sync_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_list_lsps(port_: i64) {
    wire_list_lsps_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_set_lsp_id(port_: i64, lsp_id: *mut wire_uint_8_list) {
    wire_set_lsp_id_impl(port_, lsp_id)
}

#[no_mangle]
pub extern "C" fn wire_get_node_state(port_: i64) {
    wire_get_node_state_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_fetch_rates(port_: i64) {
    wire_fetch_rates_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_list_fiat_currencies(port_: i64) {
    wire_list_fiat_currencies_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_list_transactions(
    port_: i64,
    filter: i32,
    from_timestamp: *mut i64,
    to_timestamp: *mut i64,
) {
    wire_list_transactions_impl(port_, filter, from_timestamp, to_timestamp)
}

#[no_mangle]
pub extern "C" fn wire_pay(port_: i64, bolt11: *mut wire_uint_8_list) {
    wire_pay_impl(port_, bolt11)
}

#[no_mangle]
pub extern "C" fn wire_keysend(port_: i64, node_id: *mut wire_uint_8_list, amount_sats: u64) {
    wire_keysend_impl(port_, node_id, amount_sats)
}

#[no_mangle]
pub extern "C" fn wire_request_payment(
    port_: i64,
    amount_sats: u64,
    description: *mut wire_uint_8_list,
) {
    wire_request_payment_impl(port_, amount_sats, description)
}

#[no_mangle]
pub extern "C" fn wire_close_lsp_channels(port_: i64) {
    wire_close_lsp_channels_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_withdraw(
    port_: i64,
    to_address: *mut wire_uint_8_list,
    feerate_preset: i32,
) {
    wire_withdraw_impl(port_, to_address, feerate_preset)
}

#[no_mangle]
pub extern "C" fn wire_parse_invoice(port_: i64, invoice: *mut wire_uint_8_list) {
    wire_parse_invoice_impl(port_, invoice)
}

#[no_mangle]
pub extern "C" fn wire_mnemonic_to_seed(port_: i64, phrase: *mut wire_uint_8_list) {
    wire_mnemonic_to_seed_impl(port_, phrase)
}

// Section: allocate functions

#[no_mangle]
pub extern "C" fn new_box_autoadd_i64_0(value: i64) -> *mut i64 {
    support::new_leak_box_ptr(value)
}

#[no_mangle]
pub extern "C" fn new_uint_8_list_0(len: i32) -> *mut wire_uint_8_list {
    let ans = wire_uint_8_list {
        ptr: support::new_leak_vec_ptr(Default::default(), len),
        len,
    };
    support::new_leak_box_ptr(ans)
}

// Section: impl Wire2Api

impl Wire2Api<String> for *mut wire_uint_8_list {
    fn wire2api(self) -> String {
        let vec: Vec<u8> = self.wire2api();
        String::from_utf8_lossy(&vec).into_owned()
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

// Section: sync execution mode utility

#[no_mangle]
pub extern "C" fn free_WireSyncReturnStruct(val: support::WireSyncReturnStruct) {
    unsafe {
        let _ = support::vec_from_leak_ptr(val.ptr, val.len);
    }
}
