use serde::{Deserialize, Serialize};
use std::fs::File;
use std::io::Read;
use std::sync::Mutex;

use crate::chain::MempoolSpace;
use crate::persist;
use anyhow::{anyhow, Result};
use bip39::*;
use gl_client::scheduler::Scheduler;
use gl_client::signer::Signer;
use gl_client::tls::TlsConfig;
use gl_client::{node, pb};
use once_cell::sync::Lazy;
use tokio::sync::mpsc;

pub enum Network {
    /// Mainnet
    Bitcoin,
    Testnet,
    Signet,
    Regtest,
}

#[derive(Serialize, Deserialize)]
pub struct NodeState {
    id: String,
    block_height: u32,
    channels_balance_msat: u64,
    onchain_balance_msat: u64,
    max_payable_msat: u64,
    max_receivable_msat: u64,
    max_single_payment_amount_msat: u64,
    max_chan_reserve_msats: u64,
    connected_peers: Vec<String>,
    inbound_liquidity_msats: u64,
}

pub struct NodeService {
    config: Config,
    client: node::Client,
    chain_service: MempoolSpace,
    persister: persist::db::SqliteStorage,
}

impl NodeService {
    pub fn new(config: Config, client: node::Client) -> NodeService {
        let chain_service = MempoolSpace {
            base_url: config.clone().mempoolspace_url,
        };

        NodeService {
            config,
            client,
            chain_service,
            persister: persist::db::SqliteStorage::open("".to_string()).unwrap(),
        }
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
            .update_cached_item("node_state".to_string(), serialized_state.to_string())
            .map_err(|err| anyhow!(err))
    }

    fn get_lsp_id(&self) -> Result<Option<String>> {
        self.persister
            .get_setting("lsp".to_string())
            .map_err(|err| anyhow!(err))
    }

    fn set_lsp_id(&self, lsp_id: String) -> Result<()> {
        self.persister
            .update_setting("lsp".to_string(), lsp_id)
            .map_err(|err| anyhow!(err))
    }
}

#[derive(Clone, Default)]
pub struct Config {
    pub breezserver: String,
    pub mempoolspace_url: String,
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

    Ok(NodeService::new(create_default_config(), client))
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
    }
}

#[test]
fn test_config() {
    // Before the state is initialized, the config defaults to using ::default() for its values
    let config = create_default_config();
    assert_eq!(config.breezserver, "https://bs1-st.breez.technology:443");
    assert_eq!(config.mempoolspace_url, "https://mempool.space");
}

fn test_node_state() {}
