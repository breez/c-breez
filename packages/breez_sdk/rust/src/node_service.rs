use std::fs::File;
use std::io::Read;

use crate::chain::MempoolSpace;
use crate::models::{LightningTransaction, NodeAPI, NodeState, PaymentTypeFilter};
use crate::{greenlight, persist};
use anyhow::{anyhow, Result};
use bip39::*;
use gl_client::scheduler::Scheduler;
use gl_client::signer::Signer;
use gl_client::tls::TlsConfig;
use gl_client::{node, pb};
use tokio::sync::mpsc;

pub enum Network {
    /// Mainnet
    Bitcoin,
    Testnet,
    Signet,
    Regtest,
}

pub struct NodeService {
    config: Config,
    client: Box<dyn NodeAPI>,
    chain_service: MempoolSpace,
    persister: persist::db::SqliteStorage,
}

impl NodeService {
    pub fn new(config: Config, client: Box<dyn NodeAPI>) -> NodeService {
        let chain_service = MempoolSpace {
            base_url: config.clone().mempoolspace_url,
        };

        let persist_file = format!("{}/storage.sql", config.working_dir);
        NodeService {
            config,
            client,
            chain_service,
            persister: persist::db::SqliteStorage::open(persist_file).unwrap(),
        }
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

    pub fn list_transactions(
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
}

#[derive(Clone, Default)]
pub struct Config {
    pub breezserver: String,
    pub mempoolspace_url: String,
    pub working_dir: String,
}

pub struct GreenlightCredentials {
    device_key: Vec<u8>,
    device_cert: Vec<u8>,
}

/// Attempts to convert the phrase to a mnemonic, then to a seed.
///
/// If the phrase is not a valid mnemonic, an error is returned.
pub fn mnemonic_to_seed(phrase: String) -> Result<Vec<u8>> {
    let mnemonic = Mnemonic::from_phrase(&phrase, Language::English)?;
    let seed = Seed::new(&mnemonic, "");
    Ok(seed.as_bytes().to_vec())
}

pub async fn new_node_from_seed(seed: Vec<u8>, network: Network) -> Result<GreenlightCredentials> {
    let signer = Signer::new(seed, parse_network(&network), TlsConfig::new()?)?;
    let scheduler = Scheduler::new(signer.node_id(), parse_network(&network)).await?;
    let register_res: pb::RegistrationResponse = scheduler.register(&signer).await?;

    let key_data = read_a_file(register_res.device_key)?;
    let cert_data = read_a_file(register_res.device_cert)?;

    Ok(GreenlightCredentials {
        device_key: key_data,
        device_cert: cert_data,
    })
}

pub async fn recover_from_seed(seed: Vec<u8>, network: Network) -> Result<GreenlightCredentials> {
    let signer = Signer::new(seed, parse_network(&network), TlsConfig::new()?)?;
    let scheduler = Scheduler::new(signer.node_id(), parse_network(&network)).await?;
    let recover_res: pb::RecoveryResponse = scheduler.recover(&signer).await?;

    let key_data = read_a_file(recover_res.device_key)?;
    let cert_data = read_a_file(recover_res.device_cert)?;

    Ok(GreenlightCredentials {
        device_key: key_data,
        device_cert: cert_data,
    })
}

pub async fn start_node(
    seed: Vec<u8>,
    creds: GreenlightCredentials,
    network: Network,
) -> Result<(NodeService)> {
    let tls_config = TlsConfig::new()?.identity(creds.device_cert, creds.device_key);
    let signer = Signer::new(seed, parse_network(&network), tls_config.clone())?;

    let scheduler = Scheduler::new(signer.node_id(), parse_network(&network)).await?;
    let client: node::Client = scheduler.schedule(tls_config).await?;

    // Start loop to ensure the node is always running
    let (_, recv) = mpsc::channel(1);
    signer.run_forever(recv).await?;

    Ok(NodeService::new(
        create_default_config(),
        Box::new(greenlight::Greenlight::from_client(client)),
    ))
}

fn read_a_file(name: String) -> std::io::Result<Vec<u8>> {
    let mut file = File::open(name).unwrap();

    let mut data = Vec::new();
    file.read_to_end(&mut data).unwrap();

    return Ok(data);
}

fn parse_network(gn: &Network) -> lightning_signer::bitcoin::Network {
    match gn {
        Network::Bitcoin => lightning_signer::bitcoin::Network::Bitcoin,
        Network::Testnet => lightning_signer::bitcoin::Network::Testnet,
        Network::Signet => lightning_signer::bitcoin::Network::Signet,
        Network::Regtest => lightning_signer::bitcoin::Network::Regtest,
    }
}

fn create_default_config() -> Config {
    Config {
        breezserver: "https://bs1-st.breez.technology:443".to_string(),
        mempoolspace_url: "https://mempool.space".to_string(),
        working_dir: ".".to_string(),
    }
}

mod test {
    use crate::models::{LightningTransaction, NodeAPI, NodeState, PaymentTypeFilter};
    use crate::node_service::{create_default_config, NodeService};
    use crate::test_utils::MockNodeAPI;

    #[test]
    fn test_config() {
        // Before the state is initialized, the config defaults to using ::default() for its values
        let config = create_default_config();
        assert_eq!(config.breezserver, "https://bs1-st.breez.technology:443");
        assert_eq!(config.mempoolspace_url, "https://mempool.space");
    }

    #[tokio::test]
    async fn test_node_state() {
        std::fs::remove_file("./storage.sql").ok();
        let dummy_node_state = NodeState {
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
        };

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

        let node_service = NodeService::new(
            create_default_config(),
            Box::new(MockNodeAPI {
                node_state: dummy_node_state.clone(),
                transactions: dummy_transactions.clone(),
            }),
        );

        node_service.sync().await.unwrap();
        let fetched_state = node_service.get_node_state().unwrap().unwrap();
        assert_eq!(fetched_state, dummy_node_state);

        let all = node_service
            .list_transactions(PaymentTypeFilter::All, None, None)
            .unwrap();
        assert_eq!(dummy_transactions, all);

        let received = node_service
            .list_transactions(PaymentTypeFilter::Received, None, None)
            .unwrap();
        assert_eq!(received, vec![all[0].clone()]);

        let sent = node_service
            .list_transactions(PaymentTypeFilter::Sent, None, None)
            .unwrap();
        assert_eq!(sent, vec![all[1].clone()]);
    }
}
