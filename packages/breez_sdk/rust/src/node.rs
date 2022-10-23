use std::fs::File;
use std::io::Read;
use std::sync::Mutex;

use anyhow::Result;
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

/// Internal SDK state. Stored in memory, not persistent across restarts.
/// Available only internally, not exposed to callers of SDK.
static STATE: Lazy<Mutex<NodeState>> = Lazy::new(|| Mutex::new(NodeState::default()));

#[derive(Clone, Default)]
struct NodeState {
    client: Option<node::Client>,
    config: Config
}

#[derive(Clone, Default)]
pub struct Config {
    pub breezserver: String
}

fn get_state() -> NodeState {
    STATE.lock().unwrap().clone()
}

fn set_state(state: NodeState) {
    *STATE.lock().unwrap() = state;
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
) -> Result<()> {
    let tls_config = TlsConfig::new()?.identity(creds.device_cert, creds.device_key);
    let signer = Signer::new(seed, parse_network(&network), tls_config.clone())?;

    let scheduler = Scheduler::new(signer.node_id(), parse_network(&network)).await?;
    let client: node::Client = scheduler.schedule(tls_config).await?;

    // Start loop to ensure the node is always running
    let (_, recv) = mpsc::channel(1);
    signer.run_forever(recv).await?;

    set_state(NodeState {
        client: Some(client),
        config: get_default_config()
    });

    Ok(())
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

fn get_default_config() -> Config {
    Config {
        breezserver: "https://bs1-st.breez.technology:443".to_string()
    }
}

#[test]
fn test_state() {
    // By default, the state is initialized with None values
    assert!(get_state().client.is_none());

}

#[test]
fn test_config() {
    // Before the state is initialized, the config defaults to using ::default() for its values
    assert_eq!(get_state().config.breezserver, "");

    set_state(NodeState {
        client: None,
        config: get_default_config()
    });
    assert_eq!(get_state().config.breezserver, "https://bs1-st.breez.technology:443");
}