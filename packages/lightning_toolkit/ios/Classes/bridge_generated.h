#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

typedef struct wire_uint_8_list {
  uint8_t *ptr;
  int32_t len;
} wire_uint_8_list;

typedef struct wire_RouteHintHop {
  struct wire_uint_8_list *src_node_id;
  uint64_t short_channel_id;
  uint32_t fees_base_msat;
  uint32_t fees_proportional_millionths;
  uint64_t cltv_expiry_delta;
  uint64_t *htlc_minimum_msat;
  uint64_t *htlc_maximum_msat;
} wire_RouteHintHop;

typedef struct wire_list_route_hint_hop {
  struct wire_RouteHintHop *ptr;
  int32_t len;
} wire_list_route_hint_hop;

typedef struct wire_RouteHint {
  struct wire_list_route_hint_hop *field0;
} wire_RouteHint;

typedef struct wire_list_route_hint {
  struct wire_RouteHint *ptr;
  int32_t len;
} wire_list_route_hint;

typedef struct WireSyncReturnStruct {
  uint8_t *ptr;
  int32_t len;
  bool success;
} WireSyncReturnStruct;

typedef int64_t DartPort;

typedef bool (*DartPostCObjectFnType)(DartPort port_id, void *message);

void wire_init_hsmd(int64_t port_,
                    struct wire_uint_8_list *storage_path,
                    struct wire_uint_8_list *secret);

void wire_parse_invoice(int64_t port_, struct wire_uint_8_list *invoice);

void wire_node_pubkey(int64_t port_,
                      struct wire_uint_8_list *storage_path,
                      struct wire_uint_8_list *secret);

void wire_add_routing_hints(int64_t port_,
                            struct wire_uint_8_list *storage_path,
                            struct wire_uint_8_list *secret,
                            struct wire_uint_8_list *invoice,
                            struct wire_list_route_hint *hints);

void wire_sign_message(int64_t port_,
                       struct wire_uint_8_list *storage_path,
                       struct wire_uint_8_list *secret,
                       struct wire_uint_8_list *msg);

void wire_handle(int64_t port_,
                 struct wire_uint_8_list *storage_path,
                 struct wire_uint_8_list *secret,
                 struct wire_uint_8_list *msg,
                 struct wire_uint_8_list *peer_id,
                 uint64_t db_id);

uint64_t *new_box_autoadd_u64(uint64_t value);

struct wire_list_route_hint *new_list_route_hint(int32_t len);

struct wire_list_route_hint_hop *new_list_route_hint_hop(int32_t len);

struct wire_uint_8_list *new_uint_8_list(int32_t len);

void free_WireSyncReturnStruct(struct WireSyncReturnStruct val);

void store_dart_post_cobject(DartPostCObjectFnType ptr);

static int64_t dummy_method_to_enforce_bundling(void) {
    int64_t dummy_var = 0;
    dummy_var ^= ((int64_t) (void*) wire_init_hsmd);
    dummy_var ^= ((int64_t) (void*) wire_parse_invoice);
    dummy_var ^= ((int64_t) (void*) wire_node_pubkey);
    dummy_var ^= ((int64_t) (void*) wire_add_routing_hints);
    dummy_var ^= ((int64_t) (void*) wire_sign_message);
    dummy_var ^= ((int64_t) (void*) wire_handle);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_u64);
    dummy_var ^= ((int64_t) (void*) new_list_route_hint);
    dummy_var ^= ((int64_t) (void*) new_list_route_hint_hop);
    dummy_var ^= ((int64_t) (void*) new_uint_8_list);
    dummy_var ^= ((int64_t) (void*) free_WireSyncReturnStruct);
    dummy_var ^= ((int64_t) (void*) store_dart_post_cobject);
    return dummy_var;
}