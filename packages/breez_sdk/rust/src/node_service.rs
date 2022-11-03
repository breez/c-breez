use std::cmp::max;
use std::collections::HashMap;
use std::str::FromStr;

use anyhow::{anyhow, Result};
use bip39::*;
use prost::Message;
use rand::random;
use tonic::Request;
use tonic::transport::{Channel, Uri};

use crate::chain::MempoolSpace;
use crate::crypto::encrypt;
use crate::grpc::breez::{LspInformation, LspListRequest, RegisterPaymentReply, RegisterPaymentRequest};
use crate::grpc::breez::channel_opener_client::ChannelOpenerClient;
use crate::models::{LspAPI, Config, LightningTransaction, NodeAPI, NodeState, PaymentTypeFilter, parse_short_channel_id};
use crate::grpc::lspd::PaymentInformation;
use crate::persist;
use crate::test_utils::rand_vec_u8;

pub struct NodeService {
    config: Config,
    client: Box<dyn NodeAPI>,
    client_grpc: Box<dyn LspAPI>,
    chain_service: MempoolSpace,
    persister: persist::db::SqliteStorage,
}

impl NodeService {
    pub async fn start_node(&mut self) -> Result<()> {
        self.client.start().await
    }

    pub async fn run_signer(&self) -> Result<()> {
        self.client.run_signer().await
    }

    pub async fn sync(&self) -> Result<()> {
        let since_timestamp = self
            .persister
            .get_cached_item("last_sync_timestamp".to_string())?
            .unwrap_or("0".to_string())
            .parse::<i64>()?;

        let new_data = &self.client.pull_changed(since_timestamp).await?;

        self.set_node_state(&new_data.node_state)?;
        self.persister
            .insert_ln_transactions(&new_data.transactions)?;

        Ok(())
    }

    pub async fn list_transactions(
        &self,
        filter: PaymentTypeFilter,
        from_timestamp: Option<i64>,
        to_timestamp: Option<i64>,
    ) -> Result<Vec<LightningTransaction>> {
        self.persister
            .list_ln_transactions(filter, from_timestamp, to_timestamp)
            .map_err(|err| anyhow!(err))
    }

    pub fn get_node_state(&self) -> Result<Option<NodeState>> {
        let state_str = self.persister.get_cached_item("node_state".to_string())?;
        Ok(match state_str {
            Some(str) => serde_json::from_str(str.as_str())?,
            None => None,
        })
    }

    fn set_node_state(&self, state: &NodeState) -> Result<()> {
        let serialized_state = serde_json::to_string(state)?;
        self.persister
            .update_cached_item("node_state".to_string(), serialized_state.to_string())?;
        Ok(())
    }

    fn get_lsp_id(&self) -> Result<Option<String>> {
        self.persister
            .get_setting("lsp".to_string())
            .map_err(|err| anyhow!(err))
    }

    fn set_lsp_id(&self, lsp_id: String) -> Result<()> {
        self.persister.update_setting("lsp".to_string(), lsp_id)?;
        Ok(())
    }

    /// Convenience method to look up LSP info based on current LSP ID
    async fn get_lsp(&mut self) -> Result<LspInformation> {
        let lsp_id = self.get_lsp_id()
            .expect("Failed to lookup LSP ID")
            .expect("LSP ID not set");

        let node_pubkey = self.get_node_state()?.unwrap().id;
        self.client_grpc.list_lsps(node_pubkey).await?
            .get(&lsp_id)
            .ok_or("Invalid LSP ID")
            .map_err(|err| anyhow!(err))
            .cloned()
    }

    // TODO Returns invoice. New struct? Or return as bolt11?
    async fn request_payment(&mut self, amount_sats: u64) -> Result<()> {
        let lsp_info = &self.get_lsp().await?;
        let node_state = self.get_node_state()?.expect("Failed to retrieve node state");

        let amount_msats = amount_sats * 1000;

        let mut short_channel_id = parse_short_channel_id("1x0x0");
        let mut destination_invoice_amount_sats = amount_msats;

        // check if we need to open channel
        if node_state.inbound_liquidity_msats < amount_msats {
            // TODO logging

            // we need to open channel so we are calculating the fees for the LSP
            let channel_fees_msat_calculated = amount_msats * lsp_info.channel_fee_permyriad as u64 / 10_000 / 1_000_000;
            let channel_fees_msat = max(channel_fees_msat_calculated, lsp_info.channel_minimum_fee_msat as u64);

            if amount_msats < channel_fees_msat + 1000 {
                return Err(anyhow!("requestPayment: Amount should be more than the minimum fees {} sats", lsp_info.channel_minimum_fee_msat / 1000));
            }

            // remove the fees from the amount to get the small amount on the current node invoice.
            destination_invoice_amount_sats = amount_sats - channel_fees_msat / 1000;
        }
        else {
            // not opening a channel so we need to get the real channel id into the routing hints
            for peer in self.client.list_peers().await? {
                if peer.id == lsp_info.lsp_pubkey && !peer.channels.is_empty() {
                    let active_channel = peer.channels.iter().find(|&c| c.state == "OPEN").expect("No open channel found");
                    short_channel_id = parse_short_channel_id(&active_channel.short_channel_id);
                    break;
                }
            }
        }

        // TODO nodeAPI.addInvoice();

        // TODO create RouteHintHop

        // TODO Create bolt11 via signer?
        // TODO bolt11WithHints =   await _signer!.addRoutingHints

        // register the payment at the lsp if needed
        if destination_invoice_amount_sats < amount_sats {

            // TODO Find / build args for PaymentInformation
            self.client_grpc.register_payment(
                lsp_info,
                PaymentInformation {
                    payment_hash: rand_vec_u8(10),
                    payment_secret: rand_vec_u8(10),
                    destination: rand_vec_u8(10),
                    incoming_amount_msat: random(),
                    outgoing_amount_msat: random()
                }).await
                .expect("Failed to register payment");
        }

        // return the converted invoice
        // TODO invoice.copyWithNewAmount(amountMsats: amountMSat, bolt11: bolt11WithHints);

        Ok(())
    }
}

#[derive(Default)]
pub struct NodeServiceBuilder {
    config: Option<Config>,
    client: Option<Box<dyn NodeAPI>>,
    client_grpc: Option<Box<dyn LspAPI>>,
}

impl NodeServiceBuilder {
    pub fn config(mut self, config: Config) -> Self {
        self.config = Some(config);
        self
    }

    pub fn client(mut self, client: Box<dyn NodeAPI>) -> Self {
        self.client = Some(client);
        self
    }

    /// Initialize the Breez gRPC Client to a custom implementation
    pub fn client_grpc(mut self, client_grpc: Box<dyn LspAPI>) -> Self {
        self.client_grpc = Some(client_grpc);
        self
    }

    /// Initializes the Breez gRPC Client based on the configured Breez endpoint in the config
    pub async fn client_grpc_init_from_config(mut self) -> Self {
        let breez_server_endpoint = BreezLSP::new(
            &self.config.as_ref()
                .expect("Config not set. Please set config before calling this method in the builder.")
                .breezserver
        ).await;
        self.client_grpc = Some(Box::new(breez_server_endpoint));
        self
    }

    pub async fn build(self) -> NodeService {
        let config = self.config.as_ref().unwrap().clone();

        let chain_service = MempoolSpace {
            base_url: config.clone().mempoolspace_url,
        };

        let persist_file = format!("{}/storage.sql", config.working_dir);
        NodeService {
            config,
            client: self.client.unwrap(),
            client_grpc: self.client_grpc.unwrap(),
            chain_service,
            persister: persist::db::SqliteStorage::open(persist_file).unwrap(),
        }
    }
}

pub struct BreezLSP {
    client_grpc: ChannelOpenerClient<Channel>,
}

impl BreezLSP {
    pub async fn new(breezserver: &str) -> Self {
        Self {
            client_grpc: ChannelOpenerClient::connect(Uri::from_str(breezserver).unwrap()).await.unwrap()
        }
    }
}

#[tonic::async_trait]
impl LspAPI for BreezLSP {
    async fn list_lsps(&mut self, pubkey: String) -> Result<HashMap<String, LspInformation>> {
        let client = &mut self.client_grpc;

        let request = Request::new(LspListRequest { pubkey });
        let response = client.lsp_list(request).await?;
        Ok(response.into_inner().lsps)
    }

    async fn register_payment(&mut self, lsp: &LspInformation, payment_info: PaymentInformation) -> Result<RegisterPaymentReply> {
        let client = &mut self.client_grpc;

        let mut buf = Vec::new();
        buf.reserve(payment_info.encoded_len());
        payment_info.encode(&mut buf)?;

        let request = Request::new(RegisterPaymentRequest {
            lsp_id: lsp.name.clone(),
            blob: encrypt(lsp.lsp_pubkey.clone(), buf)?
        });
        let response = client.register_payment(request).await?;

        Ok(response.into_inner())
    }
}

/// Attempts to convert the phrase to a mnemonic, then to a seed.
///
/// If the phrase is not a valid mnemonic, an error is returned.
pub fn mnemonic_to_seed(phrase: String) -> Result<Vec<u8>> {
    let mnemonic = Mnemonic::from_phrase(&phrase, Language::English)?;
    let seed = Seed::new(&mnemonic, "");
    Ok(seed.as_bytes().to_vec())
}

mod test {
    use crate::models::{LightningTransaction, LspAPI, NodeAPI, NodeState, PaymentTypeFilter};
    use crate::node_service::{Config, NodeService, NodeServiceBuilder};
    use crate::test_utils::{MockBreezLSP, MockNodeAPI};

    #[test]
    fn test_config() {
        // Before the state is initialized, the config defaults to using ::default() for its values
        let config = Config::default();
        assert_eq!(config.breezserver, "https://bs1-st.breez.technology:443");
        assert_eq!(config.mempoolspace_url, "https://mempool.space");
    }

    #[tokio::test]
    async fn test_node_state() {
        std::fs::remove_file("./storage.sql").ok();
        let dummy_node_state = get_dummy_node_state();

        let dummy_transactions = vec![
            LightningTransaction {
                payment_type: crate::models::PAYMENT_TYPE_RECEIVED.to_string(),
                payment_hash: "1111".to_string(),
                payment_time: 100000,
                label: "".to_string(),
                destination_pubkey: "1111".to_string(),
                amount_msat: 10,
                fees_msat: 0,
                payment_preimage: "2222".to_string(),
                keysend: false,
                bolt11: "1111".to_string(),
                pending: false,
                description: Some("test receive".to_string()),
            },
            LightningTransaction {
                payment_type: crate::models::PAYMENT_TYPE_SENT.to_string(),
                payment_hash: "3333".to_string(),
                payment_time: 200000,
                label: "".to_string(),
                destination_pubkey: "123".to_string(),
                amount_msat: 8,
                fees_msat: 2,
                payment_preimage: "4444".to_string(),
                keysend: false,
                bolt11: "123".to_string(),
                pending: false,
                description: Some("test payment".to_string()),
            },
        ];

        let node_service = NodeServiceBuilder::default()
            .config(Config::default())
            .client(Box::new(MockNodeAPI {
                node_state: dummy_node_state.clone(),
                transactions: dummy_transactions.clone(),
            }))
            .client_grpc(Box::new(MockBreezLSP {}))
            .build()
            .await;

        node_service.sync().await.unwrap();
        let fetched_state = node_service.get_node_state().unwrap().unwrap();
        assert_eq!(fetched_state, dummy_node_state);

        let all = node_service
            .list_transactions(PaymentTypeFilter::All, None, None)
            .await
            .unwrap();
        assert_eq!(dummy_transactions, all);

        let received = node_service
            .list_transactions(PaymentTypeFilter::Received, None, None)
            .await
            .unwrap();
        assert_eq!(received, vec![all[0].clone()]);

        let sent = node_service
            .list_transactions(PaymentTypeFilter::Sent, None, None)
            .await
            .unwrap();
        assert_eq!(sent, vec![all[1].clone()]);
    }

    #[tokio::test]
    async fn test_list_lsps() -> Result<(), Box<dyn std::error::Error>>  {
        let mut node_service = NodeServiceBuilder::default()
            .config(Config::default())
            .client(Box::new(MockNodeAPI {
                node_state: get_dummy_node_state(),
                transactions: vec![],
            }))
            .client_grpc(Box::new(MockBreezLSP {}))
            .build()
            .await;

        let node_pubkey = node_service.get_node_state()?.unwrap().id;
        let lsps = node_service.client_grpc.list_lsps(node_pubkey).await?;
        assert!(lsps.is_empty()); // The mock returns an empty list

        Ok(())
    }

    /// Build dummy NodeState for tests
    fn get_dummy_node_state() -> NodeState {
        NodeState {
            id: "tx1".to_string(),
            block_height: 1,
            channels_balance_msat: 100,
            onchain_balance_msat: 1000,
            max_payable_msat: 95,
            max_receivable_msat: 1000,
            max_single_payment_amount_msat: 1000,
            max_chan_reserve_msats: 0,
            connected_peers: vec!["1111".to_string()],
            inbound_liquidity_msats: 2000,
        }
    }
}
