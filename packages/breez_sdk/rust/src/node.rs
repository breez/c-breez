use std::fs::File;
use std::io::Read;
use std::sync::Mutex;

use anyhow::Result;
use bip39::*;
use config::{Config, FileFormat, Map, Value, ValueKind};
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

/// Parses the breez.conf config file and extracts a key-value map of the available configs
fn parse_config_ini() -> Map<String, Value> {
    let breez_conf_file = config::File::with_name("../../../conf/breez.conf")
        .format(FileFormat::Ini);

    Config::builder()
        .add_source(breez_conf_file)
        .build()
        .expect("Failed to parse breez.conf")
        .get_table("Application Options")
        .expect("Failed to load Application Options section of the INI config")
}

/// Looks up config value in the breez.conf file
fn get_config(key: &str) -> Option<ValueKind> {
    parse_config_ini()
        .get(key)
        .map(|v| v.kind.clone())
}

#[test]
fn test_state() {
    // By default, the state is initialized with None values
    assert!(get_state().client.is_none());
}

#[test]
fn test_config() {
    assert_eq!(get_config("breezserver"), Some(ValueKind::String("<address to breez server>".to_string())));
    assert!(get_config("non-existing-key").is_none());
}