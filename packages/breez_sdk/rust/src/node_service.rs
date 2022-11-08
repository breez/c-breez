use std::cmp::max;
use std::str::FromStr;
use std::time::UNIX_EPOCH;

use anyhow::{anyhow, Result};
use bip39::*;
use bitcoin::secp256k1::{Secp256k1, SecretKey};
use gl_client::pb::Payment;
use lightning_invoice::{Invoice, RawInvoice, SignedRawInvoice};
use rand::Rng;
use tokio::sync::mpsc;
use tonic::transport::{Channel, Uri};

use crate::chain::MempoolSpace;
use crate::fiat::{FiatCurrency, Rate};
use crate::grpc::channel_opener_client::ChannelOpenerClient;
use crate::grpc::information_client::InformationClient;
use crate::grpc::PaymentInformation;
use crate::invoice::{add_routing_hints, LNInvoice, parse_invoice, RouteHint, RouteHintHop};
use crate::lsp::LspInformation;
use crate::models::{Config, FiatAPI, LightningTransaction, LspAPI, NodeAPI, NodeState, parse_short_channel_id, PaymentTypeFilter};
use crate::persist;

pub struct NodeService {
    config: Config,
    client: Box<dyn NodeAPI>,
    lsp: Box<dyn LspAPI>,
    fiat: Box<dyn FiatAPI>,
    chain_service: MempoolSpace,
    persister: persist::db::SqliteStorage,
}

impl NodeService {
    pub async fn start_node(&mut self) -> Result<()> {
        self.client.start().await
    }

    pub async fn run_signer(&self, shutdown: mpsc::Receiver<()>) -> Result<()> {
        self.client.run_signer(shutdown).await
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

    pub async fn fetch_rates(&self) -> Result<Vec<Rate>> {
        self.fiat.fetch_rates().await
    }

    pub fn list_fiat_currencies(&self) -> Result<Vec<FiatCurrency>> {
        self.fiat.list_fiat_currencies()
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

    pub async fn list_lsps(&self) -> Result<Vec<LspInformation>> {
        self.lsp
            .list_lsps(self.get_node_state()?.ok_or(anyhow!("err"))?.id)
            .await
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

    pub fn set_lsp_id(&self, lsp_id: String) -> Result<()> {
        self.persister.update_setting("lsp".to_string(), lsp_id)?;
        Ok(())
    }

    /// Convenience method to look up LSP info based on current LSP ID
    async fn get_lsp(&mut self) -> Result<LspInformation> {
        let lsp_id = self.get_lsp_id()?
            .ok_or("No LSP ID found")
            .map_err(|err| anyhow!(err))?;

        let node_pubkey = self.get_node_state()?
            .ok_or("No NodeState found")
            .map_err(|err| anyhow!(err))?
            .id;
        self.lsp.list_lsps(node_pubkey).await?
            .iter()
            .find(|&lsp| lsp.id == lsp_id)
            .ok_or("No LSO found for given LSP ID")
            .map_err(|err| anyhow!(err))
            .cloned()
    }

    pub async fn pay(&mut self, bolt11: String) -> Result<Payment> {
        let payment = self.client.send_payment(bolt11, None).await?;

        Ok(payment)
    }

    pub async fn request_payment(&mut self, amount_sats: u64, description: String) -> Result<LNInvoice> {
        let lsp_info = &self.get_lsp().await?;
        let node_state = self.get_node_state()?
            .ok_or("Failed to retrieve node state")
            .map_err(|err| anyhow!(err))?;

        let amount_msats = amount_sats * 1000;

        let mut short_channel_id = parse_short_channel_id("1x0x0")?;
        let mut destination_invoice_amount_sats = amount_msats;

        // check if we need to open channel
        if node_state.inbound_liquidity_msats < amount_msats {
            info!("We need to open a channel");

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
            info!("Finding channel ID for routing hint");
            for peer in self.client.list_peers().await? {
                if peer.id == lsp_info.lsp_pubkey && !peer.channels.is_empty() {
                    let active_channel = peer.channels.iter()
                        .find(|&c| c.state == "OPEN")
                        .ok_or("No open channel found")
                        .map_err(|err| anyhow!(err))?;
                    short_channel_id = parse_short_channel_id(&active_channel.short_channel_id)?;
                    info!("Found channel ID: {}", short_channel_id);
                    break;
                }
            }
        }

        info!("Creating invoice on NodeAPI");
        let invoice = &self.client.create_invoice(amount_sats, description).await?;
        info!("Invoice created");

        info!("Adding routing hint");
        let lsp_hop = RouteHintHop {
            src_node_id: lsp_info.pubkey.clone(), // TODO correct?
            short_channel_id: short_channel_id as u64,
            fees_base_msat: lsp_info.base_fee_msat as u32,
            fees_proportional_millionths: 100, // TODO
            cltv_expiry_delta: lsp_info.time_lock_delta as u64,
            htlc_minimum_msat: Some(lsp_info.min_htlc_msat as u64), // TODO correct?
            htlc_maximum_msat: Some(4000), // TODO ?
        };
        let raw_invoice_with_hint = add_routing_hints(
            &invoice.bolt11,
            vec![ RouteHint(vec![lsp_hop]) ],
            amount_sats
        )?;
        info!("Routing hint added");

        // TODO Mock signing. Replace with actual signing of raw_invoice_with_hint
        let secp = Secp256k1::new();
        let seed = rand::thread_rng().gen::<[u8; 32]>();
        let secret_key = SecretKey::from_slice(&seed).expect("32 bytes, within curve order");
        let signed_invoice_with_hint = raw_invoice_with_hint.sign(|&x|
            Ok::<bitcoin::secp256k1::ecdsa::RecoverableSignature, anyhow::Error>(secp.sign_ecdsa_recoverable(&x, &secret_key)))?;

        let parsed_invoice = parse_invoice(&signed_invoice_with_hint.to_string())?;

        // register the payment at the lsp if needed
        if destination_invoice_amount_sats < amount_sats {
            info!("Registering payment with LSP");
            self.lsp.register_payment(
                lsp_info.id.clone(),
                lsp_info.lsp_pubkey.clone(),
                PaymentInformation {
                    payment_hash: Vec::from(parsed_invoice.payment_hash.clone()),
                    payment_secret: parsed_invoice.payment_secret.clone(),
                    destination: Vec::from(parsed_invoice.payee_pubkey.clone()),
                    incoming_amount_msat: amount_msats as i64,
                    outgoing_amount_msat: (destination_invoice_amount_sats * 1000) as i64
                }).await?;
            info!("Payment registered");
        }

        // return the signed, converted invoice with hints
        Ok(parsed_invoice)
    }
}

#[derive(Default)]
pub struct NodeServiceBuilder {
    config: Option<Config>,
    client: Option<Box<dyn NodeAPI>>,
    lsp: Option<Box<dyn LspAPI>>,
    fiat: Option<Box<dyn FiatAPI>>,
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
    pub fn client_grpc(mut self, lsp: Box<dyn LspAPI>, fiat: Box<dyn FiatAPI>) -> Self {
        self.lsp = Some(lsp);
        self.fiat = Some(fiat);
        self
    }

    /// Initializes the Breez gRPC Client based on the configured Breez endpoint in the config
    pub async fn client_grpc_init_from_config(mut self) -> Self {
        let breez_server_endpoint = BreezServer::new(
            self.config
                .as_ref()
                .expect(
                    "Config not set. Please set config before calling this method in the builder.",
                )
                .breezserver
                .clone(),
        )
        .await;
        self.lsp = Some(Box::new(breez_server_endpoint.clone()));
        self.fiat = Some(Box::new(breez_server_endpoint.clone()));
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
            lsp: self.lsp.unwrap(),
            fiat: self.fiat.unwrap(),
            chain_service,
            persister: persist::db::SqliteStorage::open(persist_file).unwrap(),
        }
    }
}

#[derive(Clone)]
pub struct BreezServer {
    server_url: String,
}

impl BreezServer {
    pub async fn new(server_url: String) -> Self {
        Self { server_url }
    }

    pub(crate) async fn get_channel_opener_client(&self) -> Result<ChannelOpenerClient<Channel>> {
        ChannelOpenerClient::connect(Uri::from_str(&self.server_url)?)
            .await
            .map_err(|e| anyhow!(e))
    }

    pub(crate) async fn get_information_client(&self) -> Result<InformationClient<Channel>> {
        InformationClient::connect(Uri::from_str(&self.server_url)?)
            .await
            .map_err(|e| anyhow!(e))
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
    use anyhow::anyhow;

    use crate::fiat::Rate;
    use crate::models::{LightningTransaction, NodeState, PaymentTypeFilter};
    use crate::node_service::{Config, NodeService, NodeServiceBuilder};
    use crate::test_utils::{MockBreezServer, MockNodeAPI};

    #[test]
    fn test_config() {
        // Before the state is initialized, the config defaults to using ::default() for its values
        let config = Config::default();
        assert_eq!(config.breezserver, "https://bs1-st.breez.technology:443");
        assert_eq!(config.mempoolspace_url, "https://mempool.space");
    }

    #[tokio::test]
    async fn test_node_state() -> Result<(), Box<dyn std::error::Error>> {
        std::fs::remove_file("./storage.sql").expect("Failed to delete file");
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
            .client_grpc(Box::new(MockBreezServer {}), Box::new(MockBreezServer {}))
            .build()
            .await;

        node_service.sync().await?;
        let fetched_state = node_service.get_node_state()?
            .ok_or("No NodeState found")
            .map_err(|err| anyhow!(err))?;
        assert_eq!(fetched_state, dummy_node_state);

        let all = node_service
            .list_transactions(PaymentTypeFilter::All, None, None)
            .await?;
        assert_eq!(dummy_transactions, all);

        let received = node_service
            .list_transactions(PaymentTypeFilter::Received, None, None)
            .await?;
        assert_eq!(received, vec![all[0].clone()]);

        let sent = node_service
            .list_transactions(PaymentTypeFilter::Sent, None, None)
            .await?;
        assert_eq!(sent, vec![all[1].clone()]);

        Ok(())
    }

    #[tokio::test]
    async fn test_list_lsps() -> Result<(), Box<dyn std::error::Error>> {
        let node_service = build_mock_node_service().await;
        node_service.sync().await?;

        let node_pubkey = node_service
            .get_node_state()?
            .ok_or("No NodeState found")
            .map_err(|err| anyhow!(err))?
            .id;
        let lsps = node_service.lsp.list_lsps(node_pubkey).await?;
        assert!(lsps.is_empty()); // The mock returns an empty list

        Ok(())
    }

    #[tokio::test]
    async fn test_fetch_rates() -> Result<(), Box<dyn std::error::Error>> {
        let node_service = node_service().await;
        node_service.sync().await?;

        let rates = node_service.fiat.fetch_rates().await?;
        assert_eq!(rates.len(), 1);
        assert_eq!(
            rates[0],
            Rate {
                coin: "USD".to_string(),
                value: 20_000.00
            }
        );

        Ok(())
    }

    /// build node service for tests
    async fn node_service() -> NodeService {
        NodeServiceBuilder::default()
            .config(Config::default())
            .client(Box::new(MockNodeAPI {
                node_state: get_dummy_node_state(),
                transactions: vec![],
            }))
            .client_grpc(Box::new(MockBreezServer {}), Box::new(MockBreezServer {}))
            .build()
            .await
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

    async fn build_mock_node_service() -> NodeService {
        NodeServiceBuilder::default()
            .config(Config::default())
            .client(Box::new(MockNodeAPI {
                node_state: get_dummy_node_state(),
                transactions: vec![],
            }))
            .client_grpc(Box::new(MockBreezServer {}), Box::new(MockBreezServer {}))
            .build()
            .await
    }
}
