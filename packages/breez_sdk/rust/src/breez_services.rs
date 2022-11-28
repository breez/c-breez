use std::cmp::max;
use std::str::FromStr;
use std::sync::Arc;

use crate::chain::MempoolSpace;
use crate::chain_notifier::{self, ChainEvent, ChainNotifier, Listener};
use crate::fiat::{FiatCurrency, Rate};
use crate::grpc::channel_opener_client::ChannelOpenerClient;
use crate::grpc::fund_manager_client::FundManagerClient;
use crate::grpc::information_client::InformationClient;
use crate::grpc::PaymentInformation;
use crate::invoice::{add_routing_hints, parse_invoice, LNInvoice, RouteHint, RouteHintHop};
use crate::lsp::LspInformation;
use crate::models::{
    parse_short_channel_id, Config, FeeratePreset, FiatAPI, LspAPI, Network, NodeAPI, NodeState,
    Payment, PaymentTypeFilter, SwapInfo, SwapperAPI,
};
use crate::persist;
use crate::persist::db::SqliteStorage;
use crate::swap::BTCReceiveSwap;
use anyhow::{anyhow, Result};
use bip39::*;
use tokio::sync::mpsc;
use tonic::transport::{Channel, Uri};

/// starts the BreezServices background threads.
pub async fn start(breez_services: Arc<BreezServices>) -> Result<ShutdownHandler> {
    // start the signer
    let (signer_signal, signer_receive) = mpsc::channel(1);
    breez_services.node_api.start_signer(signer_receive);

    // sync node state
    breez_services.sync().await?;

    // create the chain notifier
    let (chain_signal, chain_receive) = mpsc::channel(1);
    let mut chain_notifier = ChainNotifier::new(breez_services.chain_service.clone());
    let listeners: Vec<Arc<dyn Listener>> = vec![
        breez_services.btc_receive_swapper.clone(),
        breez_services.clone(),
    ];
    for l in listeners {
        chain_notifier.add_listener(l);
    }

    // start notifying events
    chain_notifier::start(Arc::new(chain_notifier), chain_receive);

    let shutdown_handler = ShutdownHandler {
        shutdown_signer: signer_signal,
        shutdown_chain: chain_signal,
    };

    Ok(shutdown_handler)
}

impl BreezServices {
    pub async fn send_payment(&self, bolt11: String) -> Result<()> {
        self.start_node().await?;
        self.node_api.send_payment(bolt11, None).await?;
        self.sync().await?;
        Ok(())
    }

    pub async fn send_spontaneous_payment(&self, node_id: String, amount_sats: u64) -> Result<()> {
        self.start_node().await?;
        self.node_api
            .send_spontaneous_payment(node_id, amount_sats)
            .await?;
        self.sync().await?;
        Ok(())
    }

    pub async fn receive_payment(
        &self,
        amount_sats: u64,
        description: String,
    ) -> Result<LNInvoice> {
        self.payment_receiver
            .receive_payment(amount_sats, description, None)
            .await
    }

    pub fn node_info(&self) -> Result<Option<NodeState>> {
        self.persister.get_node_state()
    }

    pub async fn list_payments(
        &self,
        filter: PaymentTypeFilter,
        from_timestamp: Option<i64>,
        to_timestamp: Option<i64>,
    ) -> Result<Vec<Payment>> {
        self.persister
            .list_payments(filter, from_timestamp, to_timestamp)
            .map_err(|err| anyhow!(err))
    }

    pub async fn sweep(&self, to_address: String, feerate_preset: FeeratePreset) -> Result<()> {
        self.start_node().await?;
        self.node_api.sweep(to_address, feerate_preset).await?;
        self.sync().await?;
        Ok(())
    }

    pub async fn fetch_fiat_rates(&self) -> Result<Vec<Rate>> {
        self.fiat_api.fetch_fiat_rates().await
    }

    pub fn list_fiat_currencies(&self) -> Result<Vec<FiatCurrency>> {
        self.fiat_api.list_fiat_currencies()
    }

    pub async fn list_lsps(&self) -> Result<Vec<LspInformation>> {
        self.lsp_api
            .list_lsps(self.node_info()?.ok_or(anyhow!("err"))?.id)
            .await
    }

    pub async fn connect_lsp(&self, lsp_id: String) -> Result<()> {
        self.persister.set_lsp_id(lsp_id)?;
        self.sync().await?;
        Ok(())
    }

    /// Convenience method to look up LSP info based on current LSP ID
    pub async fn lsp_info(&self) -> Result<LspInformation> {
        get_lsp(self.persister.clone(), self.lsp_api.clone()).await
    }

    pub async fn close_lsp_channels(&self) -> Result<()> {
        self.start_node().await?;
        let lsp = self.lsp_info().await?;
        self.node_api
            .close_peer_channels(lsp.pubkey)
            .await
            .map(|_| ())
    }

    /// Onchain receive swap API
    pub async fn receive_onchain(&self) -> Result<SwapInfo> {
        self.btc_receive_swapper.create_swap_address().await
    }

    // list swaps history (all of them: expired, refunded and active)
    pub async fn list_refundables(&self) -> Result<Vec<SwapInfo>> {
        self.btc_receive_swapper.list_refundables().await
    }

    // construct and broadcast a refund transaction for a faile/expired swap
    pub async fn refund(
        &self,
        swap_address: String,
        to_address: String,
        sat_per_vbyte: u32,
    ) -> Result<String> {
        self.btc_receive_swapper
            .refund_swap(swap_address, to_address, sat_per_vbyte)
            .await
    }

    async fn sync(&self) -> Result<()> {
        self.start_node().await?;
        self.connect_lsp_peer().await?;
        let since_timestamp = self.persister.last_payment_timestamp().unwrap_or(0);

        let new_data = &self.node_api.pull_changed(since_timestamp).await?;

        self.persister.set_node_state(&new_data.node_state)?;
        self.persister.insert_payments(&new_data.payments)?;
        Ok(())
    }

    async fn connect_lsp_peer(&self) -> Result<()> {
        let lsp = self.lsp_info().await.ok();
        if !lsp.is_none() {
            let lsp_info = lsp.unwrap().clone();
            let node_id = lsp_info.pubkey;
            let address = lsp_info.host;
            match self.node_info() {
                Ok(Some(state)) => {
                    if !state.connected_peers.contains(&node_id) {
                        self.node_api
                            .connect_peer(node_id, address)
                            .await
                            .map_err(anyhow::Error::msg)
                    } else {
                        Ok(())
                    }
                }
                Ok(None) => Ok(()),
                Err(e) => Err(anyhow!(e)),
            }?
        }
        Ok(())
    }

    pub(crate) async fn start_node(&self) -> Result<()> {
        self.node_api.start().await
    }
}

#[tonic::async_trait]
impl Listener for BreezServices {
    async fn on_event(&self, e: ChainEvent) -> Result<()> {
        match e {
            ChainEvent::NewBlock(tip) => self.sync().await?,
            _ => {}
        }

        Ok(())
    }
}

pub struct ShutdownHandler {
    shutdown_signer: mpsc::Sender<()>,
    shutdown_chain: mpsc::Sender<()>,
}

impl ShutdownHandler {
    pub(crate) async fn stop(&self) -> Result<()> {
        self.shutdown_signer.send(()).await?;
        self.shutdown_chain
            .send(())
            .await
            .map_err(anyhow::Error::msg)
    }
}

/// A helper struct to configure and build BreezServices
pub struct BreezServicesBuilder {
    config: Config,
    node_api: Arc<dyn NodeAPI>,
    lsp_api: Option<Arc<dyn LspAPI>>,
    fiat_api: Option<Arc<dyn FiatAPI>>,
    swapper_api: Option<Arc<dyn SwapperAPI>>,
}

impl BreezServicesBuilder {
    pub fn new(config: Config, node_api: Arc<dyn NodeAPI>) -> BreezServicesBuilder {
        BreezServicesBuilder {
            config: config,
            node_api: node_api.clone(),
            lsp_api: None,
            fiat_api: None,
            swapper_api: None,
        }
    }

    pub fn lsp_api(&mut self, lsp_api: Arc<dyn LspAPI>) -> &mut Self {
        self.lsp_api = Some(lsp_api.clone());
        self
    }

    pub fn fiat_api(&mut self, fiat_api: Arc<dyn FiatAPI>) -> &mut Self {
        self.fiat_api = Some(fiat_api.clone());
        self
    }

    pub fn swapper_api(&mut self, swapper_api: Arc<dyn SwapperAPI>) -> &mut Self {
        self.swapper_api = Some(swapper_api.clone());
        self
    }

    pub fn build(&self) -> Result<Arc<BreezServices>> {
        // breez_server provides both FiatAPI & LspAPI implementations
        let breez_server = Arc::new(BreezServer::new(self.config.breezserver.clone()));

        // mempool space is used to monitor the chain
        let chain_service = Arc::new(MempoolSpace {
            base_url: self.config.mempoolspace_url.clone(),
        });

        // The storage is implemented via sqlite.
        let persister = Arc::new(crate::persist::db::SqliteStorage::from_file(format!(
            "{}/storage.sql",
            self.config.working_dir
        )));

        persister.init().unwrap();

        let payment_receiver = Arc::new(PaymentReceiver {
            node_api: self.node_api.clone(),
            lsp: breez_server.clone(),
            persister: persister.clone(),
        });

        let btc_receive_swapper = Arc::new(BTCReceiveSwap::new(
            self.config.network.clone().into(),
            self.swapper_api.clone().unwrap_or(breez_server.clone()),
            persister.clone(),
            chain_service.clone(),
            payment_receiver.clone(),
        ));

        // Create the node services and it them statically
        let breez_services = Arc::new(BreezServices {
            config: self.config.clone(),
            node_api: self.node_api.clone(),
            lsp_api: self.lsp_api.clone().unwrap_or(breez_server.clone()),
            fiat_api: self.fiat_api.clone().unwrap_or(breez_server.clone()),
            chain_service: chain_service.clone(),
            persister: persister.clone(),
            btc_receive_swapper: btc_receive_swapper.clone(),
            payment_receiver,
        });

        Ok(breez_services)
    }
}

/// BreezServices is a facade and the single entry point for the sdk use cases providing
/// by exposing a simplified API
pub struct BreezServices {
    config: Config,
    node_api: Arc<dyn NodeAPI>,
    lsp_api: Arc<dyn LspAPI>,
    fiat_api: Arc<dyn FiatAPI>,
    chain_service: Arc<MempoolSpace>,
    persister: Arc<persist::db::SqliteStorage>,
    payment_receiver: Arc<PaymentReceiver>,
    btc_receive_swapper: Arc<BTCReceiveSwap>,
}

#[derive(Clone)]
pub struct BreezServer {
    server_url: String,
}

impl BreezServer {
    pub fn new(server_url: String) -> Self {
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

    pub(crate) async fn get_fund_manager_client(&self) -> Result<FundManagerClient<Channel>> {
        FundManagerClient::connect(Uri::from_str(&self.server_url)?)
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

pub(crate) struct PaymentReceiver {
    node_api: Arc<dyn NodeAPI>,
    lsp: Arc<dyn LspAPI>,
    persister: Arc<persist::db::SqliteStorage>,
}

impl PaymentReceiver {
    pub async fn receive_payment(
        &self,
        amount_sats: u64,
        description: String,
        preimage: Option<Vec<u8>>,
    ) -> Result<LNInvoice> {
        self.node_api.start().await?;
        let lsp_info = get_lsp(self.persister.clone(), self.lsp.clone()).await?;
        let node_state = self
            .persister
            .get_node_state()?
            .ok_or("Failed to retrieve node state")
            .map_err(|err| anyhow!(err))?;

        let amount_msats = amount_sats * 1000;

        let mut short_channel_id = parse_short_channel_id("1x0x0")?;
        let mut destination_invoice_amount_sats = amount_msats;

        // check if we need to open channel
        if node_state.inbound_liquidity_msats < amount_msats {
            info!("We need to open a channel");

            // we need to open channel so we are calculating the fees for the LSP
            let channel_fees_msat_calculated =
                amount_msats * lsp_info.channel_fee_permyriad as u64 / 10_000 / 1_000_000;
            let channel_fees_msat = max(
                channel_fees_msat_calculated,
                lsp_info.channel_minimum_fee_msat as u64,
            );

            if amount_msats < channel_fees_msat + 1000 {
                return Err(anyhow!(
                    "requestPayment: Amount should be more than the minimum fees {} sats",
                    lsp_info.channel_minimum_fee_msat / 1000
                ));
            }

            // remove the fees from the amount to get the small amount on the current node invoice.
            destination_invoice_amount_sats = amount_sats - channel_fees_msat / 1000;
        } else {
            // not opening a channel so we need to get the real channel id into the routing hints
            info!("Finding channel ID for routing hint");
            for peer in self.node_api.list_peers().await? {
                if hex::encode(peer.id) == lsp_info.pubkey && !peer.channels.is_empty() {
                    let active_channel = peer
                        .channels
                        .iter()
                        .find(|&c| c.state == "CHANNELD_NORMAL")
                        .ok_or("No open channel found")
                        .map_err(|err| anyhow!(err))?;
                    short_channel_id = parse_short_channel_id(&active_channel.short_channel_id)?;
                    info!("Found channel ID: {}", short_channel_id);
                    break;
                }
            }
        }

        info!("Creating invoice on NodeAPI");
        let invoice = &self
            .node_api
            .create_invoice(amount_sats, description, preimage)
            .await?;
        info!("Invoice created {}", invoice.bolt11);

        info!("Adding routing hint");
        let lsp_hop = RouteHintHop {
            src_node_id: lsp_info.pubkey.clone(), // TODO correct?
            short_channel_id: short_channel_id as u64,
            fees_base_msat: lsp_info.base_fee_msat as u32,
            fees_proportional_millionths: 10, // TODO
            cltv_expiry_delta: lsp_info.time_lock_delta as u64,
            htlc_minimum_msat: Some(lsp_info.min_htlc_msat as u64), // TODO correct?
            htlc_maximum_msat: Some(1000000000),                    // TODO ?
        };

        info!("lsp hop = {:?}", lsp_hop);

        let raw_invoice_with_hint = add_routing_hints(
            &invoice.bolt11,
            vec![RouteHint(vec![lsp_hop])],
            amount_sats * 1000,
        )?;
        info!("Routing hint added");
        let signed_invoice_with_hint = self.node_api.sign_invoice(raw_invoice_with_hint)?;
        let parsed_invoice = parse_invoice(&signed_invoice_with_hint.to_string())?;

        // register the payment at the lsp if needed
        if destination_invoice_amount_sats < amount_sats {
            info!("Registering payment with LSP");
            self.lsp
                .register_payment(
                    lsp_info.id.clone(),
                    lsp_info.lsp_pubkey.clone(),
                    PaymentInformation {
                        payment_hash: hex::decode(parsed_invoice.payment_hash.clone())?,
                        payment_secret: parsed_invoice.payment_secret.clone(),
                        destination: hex::decode(parsed_invoice.payee_pubkey.clone())?,
                        incoming_amount_msat: amount_msats as i64,
                        outgoing_amount_msat: (destination_invoice_amount_sats * 1000) as i64,
                    },
                )
                .await?;
            info!("Payment registered");
        }

        // return the signed, converted invoice with hints
        Ok(parsed_invoice)
    }
}

/// Convenience method to look up LSP info based on current LSP ID
async fn get_lsp(persister: Arc<SqliteStorage>, lsp: Arc<dyn LspAPI>) -> Result<LspInformation> {
    let lsp_id = persister
        .get_lsp_id()?
        .ok_or("No LSP ID found")
        .map_err(|err| anyhow!(err))?;

    let node_pubkey = persister
        .get_node_state()?
        .ok_or("No NodeState found")
        .map_err(|err| anyhow!(err))?
        .id;

    lsp.list_lsps(node_pubkey)
        .await?
        .iter()
        .find(|&lsp| lsp.id == lsp_id)
        .ok_or("No LSP found for given LSP ID")
        .map_err(|err| anyhow!(err))
        .cloned()
}

mod test {
    use std::sync::Arc;
    use tokio::sync::mpsc;

    use anyhow::anyhow;

    use crate::breez_services::{BreezServices, BreezServicesBuilder, Config};
    use crate::chain::MempoolSpace;
    use crate::fiat::Rate;
    use crate::models::{NodeState, Payment, PaymentTypeFilter};
    use crate::persist;
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
        let storage_path = format!("{}/storage.sql", get_test_working_dir());
        std::fs::remove_file(storage_path).ok();

        let dummy_node_state = get_dummy_node_state();

        let dummy_transactions = vec![
            Payment {
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
            Payment {
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
        let node_api = Arc::new(MockNodeAPI {
            node_state: dummy_node_state.clone(),
            transactions: dummy_transactions.clone(),
        });

        let mut builder = BreezServicesBuilder::new(create_test_config(), node_api);
        let breez_services = builder
            .lsp_api(Arc::new(MockBreezServer {}))
            .fiat_api(Arc::new(MockBreezServer {}))
            .build()?;

        breez_services.sync().await?;
        let fetched_state = breez_services
            .node_info()?
            .ok_or("No NodeState found")
            .map_err(|err| anyhow!(err))?;
        assert_eq!(fetched_state, dummy_node_state);

        let all = breez_services
            .list_payments(PaymentTypeFilter::All, None, None)
            .await?;
        let mut cloned = all.clone();

        // test the right order
        cloned.reverse();
        assert_eq!(dummy_transactions, cloned);

        let received = breez_services
            .list_payments(PaymentTypeFilter::Received, None, None)
            .await?;
        assert_eq!(received, vec![cloned[0].clone()]);

        let sent = breez_services
            .list_payments(PaymentTypeFilter::Sent, None, None)
            .await?;
        assert_eq!(sent, vec![cloned[1].clone()]);

        Ok(())
    }

    #[tokio::test]
    async fn test_list_lsps() -> Result<(), Box<dyn std::error::Error>> {
        let storage_path = format!("{}/storage.sql", get_test_working_dir());
        std::fs::remove_file(storage_path).ok();

        let breez_services = breez_services().await;
        breez_services.sync().await?;

        let node_pubkey = breez_services
            .node_info()?
            .ok_or("No NodeState found")
            .map_err(|err| anyhow!(err))?
            .id;
        let lsps = breez_services.lsp_api.list_lsps(node_pubkey).await?;
        assert!(lsps.is_empty()); // The mock returns an empty list

        Ok(())
    }

    #[tokio::test]
    async fn test_fetch_rates() -> Result<(), Box<dyn std::error::Error>> {
        let breez_services = breez_services().await;
        breez_services.sync().await?;

        let rates = breez_services.fiat_api.fetch_fiat_rates().await?;
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
    async fn breez_services() -> Arc<BreezServices> {
        let node_api = Arc::new(MockNodeAPI {
            node_state: get_dummy_node_state(),
            transactions: vec![],
        });

        let mut builder = BreezServicesBuilder::new(create_test_config(), node_api);
        let breez_services = builder
            .lsp_api(Arc::new(MockBreezServer {}))
            .fiat_api(Arc::new(MockBreezServer {}))
            .build()
            .unwrap();

        breez_services
    }

    fn create_test_config() -> Config {
        let mut cfg = Config::default();
        cfg.working_dir = get_test_working_dir();
        cfg
    }

    fn get_test_working_dir() -> String {
        std::env::temp_dir().to_str().unwrap().to_string()
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
