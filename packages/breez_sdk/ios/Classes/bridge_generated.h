#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

typedef int64_t DartPort;

typedef bool (*DartPostCObjectFnType)(DartPort port_id, void *message);

typedef struct wire_uint_8_list {
  uint8_t *ptr;
  int32_t len;
} wire_uint_8_list;

typedef struct wire_Config {
  struct wire_uint_8_list *breezserver;
  struct wire_uint_8_list *mempoolspace_url;
  struct wire_uint_8_list *working_dir;
  int32_t network;
  uint32_t payment_timeout_sec;
} wire_Config;

typedef struct wire_GreenlightCredentials {
  struct wire_uint_8_list *device_key;
  struct wire_uint_8_list *device_cert;
} wire_GreenlightCredentials;

typedef struct WireSyncReturnStruct {
  uint8_t *ptr;
  int32_t len;
  bool success;
} WireSyncReturnStruct;

void store_dart_post_cobject(DartPostCObjectFnType ptr);

void wire_register_node(int64_t port_, int32_t network, struct wire_uint_8_list *seed);

void wire_recover_node(int64_t port_, int32_t network, struct wire_uint_8_list *seed);

void wire_create_node_services(int64_t port_,
                               struct wire_Config *breez_config,
                               struct wire_uint_8_list *seed,
                               struct wire_GreenlightCredentials *creds);

void wire_start_node(int64_t port_);

void wire_run_signer(int64_t port_);

void wire_stop_signer(int64_t port_);

void wire_sync(int64_t port_);

void wire_list_lsps(int64_t port_);

void wire_set_lsp_id(int64_t port_, struct wire_uint_8_list *lsp_id);

void wire_get_node_state(int64_t port_);

void wire_fetch_rates(int64_t port_);

void wire_list_fiat_currencies(int64_t port_);

void wire_list_transactions(int64_t port_,
                            int32_t filter,
                            int64_t *from_timestamp,
                            int64_t *to_timestamp);

void wire_pay(int64_t port_, struct wire_uint_8_list *bolt11);

void wire_keysend(int64_t port_, struct wire_uint_8_list *node_id, uint64_t amount_sats);

void wire_request_payment(int64_t port_,
                          uint64_t amount_sats,
                          struct wire_uint_8_list *description);

void wire_close_lsp_channels(int64_t port_);

void wire_sweep(int64_t port_, struct wire_uint_8_list *to_address, int32_t feerate_preset);

void wire_parse_invoice(int64_t port_, struct wire_uint_8_list *invoice);

void wire_mnemonic_to_seed(int64_t port_, struct wire_uint_8_list *phrase);

struct wire_Config *new_box_autoadd_config_0(void);

struct wire_GreenlightCredentials *new_box_autoadd_greenlight_credentials_0(void);

int64_t *new_box_autoadd_i64_0(int64_t value);

struct wire_uint_8_list *new_uint_8_list_0(int32_t len);

void free_WireSyncReturnStruct(struct WireSyncReturnStruct val);

static int64_t dummy_method_to_enforce_bundling(void) {
    int64_t dummy_var = 0;
    dummy_var ^= ((int64_t) (void*) wire_register_node);
    dummy_var ^= ((int64_t) (void*) wire_recover_node);
    dummy_var ^= ((int64_t) (void*) wire_create_node_services);
    dummy_var ^= ((int64_t) (void*) wire_start_node);
    dummy_var ^= ((int64_t) (void*) wire_run_signer);
    dummy_var ^= ((int64_t) (void*) wire_stop_signer);
    dummy_var ^= ((int64_t) (void*) wire_sync);
    dummy_var ^= ((int64_t) (void*) wire_list_lsps);
    dummy_var ^= ((int64_t) (void*) wire_set_lsp_id);
    dummy_var ^= ((int64_t) (void*) wire_get_node_state);
    dummy_var ^= ((int64_t) (void*) wire_fetch_rates);
    dummy_var ^= ((int64_t) (void*) wire_list_fiat_currencies);
    dummy_var ^= ((int64_t) (void*) wire_list_transactions);
    dummy_var ^= ((int64_t) (void*) wire_pay);
    dummy_var ^= ((int64_t) (void*) wire_keysend);
    dummy_var ^= ((int64_t) (void*) wire_request_payment);
    dummy_var ^= ((int64_t) (void*) wire_close_lsp_channels);
    dummy_var ^= ((int64_t) (void*) wire_sweep);
    dummy_var ^= ((int64_t) (void*) wire_parse_invoice);
    dummy_var ^= ((int64_t) (void*) wire_mnemonic_to_seed);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_config_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_greenlight_credentials_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_i64_0);
    dummy_var ^= ((int64_t) (void*) new_uint_8_list_0);
    dummy_var ^= ((int64_t) (void*) free_WireSyncReturnStruct);
    dummy_var ^= ((int64_t) (void*) store_dart_post_cobject);
    return dummy_var;
}