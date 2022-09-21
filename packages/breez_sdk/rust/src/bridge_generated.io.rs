use super::*;
// Section: wire functions

#[no_mangle]
pub extern "C" fn wire_init_hsmd(
    port_: i64,
    storage_path: *mut wire_uint_8_list,
    secret: *mut wire_uint_8_list,
) {
    wire_init_hsmd_impl(port_, storage_path, secret)
}

#[no_mangle]
pub extern "C" fn wire_create_swap(port_: i64) {
    wire_create_swap_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_create_submaring_swap_script(
    port_: i64,
    hash: *mut wire_uint_8_list,
    swapper_pub_key: *mut wire_uint_8_list,
    payer_pub_key: *mut wire_uint_8_list,
    lock_height: i64,
) {
    wire_create_submaring_swap_script_impl(port_, hash, swapper_pub_key, payer_pub_key, lock_height)
}

#[no_mangle]
pub extern "C" fn wire_encrypt(port_: i64, key: *mut wire_uint_8_list, msg: *mut wire_uint_8_list) {
    wire_encrypt_impl(port_, key, msg)
}

#[no_mangle]
pub extern "C" fn wire_decrypt(port_: i64, key: *mut wire_uint_8_list, msg: *mut wire_uint_8_list) {
    wire_decrypt_impl(port_, key, msg)
}

#[no_mangle]
pub extern "C" fn wire_parse_invoice(port_: i64, invoice: *mut wire_uint_8_list) {
    wire_parse_invoice_impl(port_, invoice)
}

#[no_mangle]
pub extern "C" fn wire_node_pubkey(
    port_: i64,
    storage_path: *mut wire_uint_8_list,
    secret: *mut wire_uint_8_list,
) {
    wire_node_pubkey_impl(port_, storage_path, secret)
}

#[no_mangle]
pub extern "C" fn wire_add_routing_hints(
    port_: i64,
    storage_path: *mut wire_uint_8_list,
    secret: *mut wire_uint_8_list,
    invoice: *mut wire_uint_8_list,
    hints: *mut wire_list_route_hint,
    new_amount: u64,
) {
    wire_add_routing_hints_impl(port_, storage_path, secret, invoice, hints, new_amount)
}

#[no_mangle]
pub extern "C" fn wire_sign_message(
    port_: i64,
    storage_path: *mut wire_uint_8_list,
    secret: *mut wire_uint_8_list,
    msg: *mut wire_uint_8_list,
) {
    wire_sign_message_impl(port_, storage_path, secret, msg)
}

#[no_mangle]
pub extern "C" fn wire_handle(
    port_: i64,
    storage_path: *mut wire_uint_8_list,
    secret: *mut wire_uint_8_list,
    msg: *mut wire_uint_8_list,
    peer_id: *mut wire_uint_8_list,
    db_id: u64,
) {
    wire_handle_impl(port_, storage_path, secret, msg, peer_id, db_id)
}

// Section: allocate functions

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

// Section: impl Wire2Api

impl Wire2Api<String> for *mut wire_uint_8_list {
    fn wire2api(self) -> String {
        let vec: Vec<u8> = self.wire2api();
        String::from_utf8_lossy(&vec).into_owned()
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

impl Wire2Api<RouteHint> for wire_RouteHint {
    fn wire2api(self) -> RouteHint {
        RouteHint(self.field0.wire2api())
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
pub struct wire_RouteHint {
    field0: *mut wire_list_route_hint_hop,
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

impl NewWithNullPtr for wire_RouteHint {
    fn new_with_null_ptr() -> Self {
        Self {
            field0: core::ptr::null_mut(),
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
