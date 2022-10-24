use std::collections::HashMap;
use std::fs::File;
use std::io::Read;
use std::str::FromStr;
use std::sync::Mutex;

use anyhow::Result;
use bip39::*;
use gl_client::{node, pb};
use gl_client::scheduler::Scheduler;
use gl_client::signer::Signer;
use gl_client::tls::TlsConfig;
use once_cell::sync::Lazy;
use tokio::sync::mpsc;
use tonic::metadata::MetadataValue;
use tonic::Request;
use tonic::transport::{Channel, Uri};

use crate::grpc::breez::{LspInformation, LspListRequest};
use crate::grpc::breez::channel_opener_client::ChannelOpenerClient;

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
    config: Config,
    chosen_lsp_id: Option<String>
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
        config: get_default_config(),
        chosen_lsp_id: None
    });

    Ok(())
}

pub async fn list_lsps() -> Result<HashMap<String, LspInformation>> {
    let config: Config = get_state().config;
    let channel = Channel::builder(Uri::from_str(&config.breezserver)?).connect().await?;

    // TODO Remove token as grpc client arg, once breez server merges latest PR
    let token: MetadataValue<_> = "Bearer <lsp_token>".parse()?;

    let mut client = ChannelOpenerClient::with_interceptor(channel, move |mut req: Request<()>| {
        req.metadata_mut().insert("authorization", token.clone());
        Ok(req)
    });

    let request = tonic::Request::new(LspListRequest {
        pubkey: "".into()
    });

    let response = client.lsp_list(request).await?;
    Ok(response.into_inner().lsps)
}

pub fn set_lsp_id(lsp_id: String) {
    STATE.lock().unwrap().chosen_lsp_id = Some(lsp_id);
}

pub fn get_lsp_id() -> Option<String> {
    STATE.lock().unwrap().chosen_lsp_id.clone()
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

/// Initialize the SDK config to its defaults, for use in tests
fn test_setup_init_config() {
    set_state(NodeState {
        client: None,
        config: get_default_config(),
        chosen_lsp_id: None
    });
}

#[test]
fn test_state() {
    // By default, the state is initialized with None values
    assert!(get_state().client.is_none());

}

#[test]
fn test_config() {
    test_setup_init_config();
    assert_eq!(get_state().config.breezserver, "https://bs1-st.breez.technology:443");
}

#[tokio::test]
async fn test_list_lsps() -> Result<(), Box<dyn std::error::Error>>  {
    test_setup_init_config();

    let lsps = list_lsps().await?;

    assert!(! lsps.is_empty());

    Ok(())
}

#[tokio::test]
async fn test_get_set_lsp_id() -> Result<(), Box<dyn std::error::Error>>  {
    test_setup_init_config();

    let lsps = list_lsps().await?;

    assert!(get_lsp_id().is_none());

    let first_lsp = lsps.keys().next().expect("No LSPs found").to_string();

    set_lsp_id(first_lsp.clone());
    assert_eq!(first_lsp, get_lsp_id().unwrap());

    Ok(())
}