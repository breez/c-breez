#[macro_use]
extern crate log;

use std::fs;
use std::io;
use std::str::SplitWhitespace;

use anyhow::{anyhow, Result};
use bip39::{Language, Mnemonic, MnemonicType, Seed};
use env_logger::Env;
use lightning_toolkit::binding;
use lightning_toolkit::lsp::LspInformation;
use lightning_toolkit::models::{self, GreenlightCredentials};
use rustyline::error::ReadlineError;
use rustyline::Editor;

fn get_seed() -> Vec<u8> {
    let filename = "phrase";
    let mnemonic = match fs::read_to_string(filename) {
        Ok(phrase) => Mnemonic::from_phrase(phrase.as_str(), Language::English).unwrap(),
        Err(e) => {
            if e.kind() != io::ErrorKind::NotFound {
                panic!("Can't read from file: {}, err {}", filename, e);
            }
            let mnemonic = Mnemonic::new(MnemonicType::Words12, Language::English);
            fs::write(filename, mnemonic.phrase()).unwrap();
            mnemonic
        }
    };
    let seed = Seed::new(&mnemonic, "");
    seed.as_bytes().to_vec()
}

fn main() -> Result<()> {
    env_logger::Builder::from_env(Env::default().default_filter_or("debug,rustyline=warn")).init();
    let seed = get_seed();
    let mut greenlight_credentials: Option<GreenlightCredentials> = None;

    let mut rl = Editor::<()>::new()?;
    if rl.load_history("history.txt").is_err() {
        info!("No previous history.");
    }

    loop {
        let readline = rl.readline("sdk> ");
        match readline {
            Ok(line) => {
                rl.add_history_entry(line.as_str());
                let mut command: SplitWhitespace = line.as_str().split_whitespace();
                match command.next() {
                    Some("register_node") => {
                        let r = binding::register_node(models::Network::Bitcoin, seed.to_vec());
                        greenlight_credentials = Some(r.unwrap());
                        info!(
                            "device_cert: {}; device_key: {}",
                            hex::encode(greenlight_credentials.clone().unwrap().device_cert),
                            hex::encode_upper(greenlight_credentials.clone().unwrap().device_key)
                        );
                    }
                    Some("request_payment") => {
                        let amount_sats = 2001;
                        let description = "Test requested payment";

                        show_results(binding::request_payment(
                            amount_sats,
                            description.to_string(),
                        ));
                    }
                    Some("pay") => {
                        let bolt11 = command.next()
                            .ok_or("Expected bolt11 arg")
                            .map_err(|err| anyhow!(err))?;

                        show_results(binding::pay(bolt11.into()))
                    }
                    Some("keysend") => {
                        let node_id = command.next()
                            .ok_or("Expected node_id arg")
                            .map_err(|err| anyhow!(err))?;
                        let amount_sats = command.next()
                            .ok_or("Expected amount_sats arg")
                            .map_err(|err| anyhow!(err))?;

                        show_results(binding::keysend(node_id.into(), amount_sats.parse()?))
                    }
                    Some("sweep") => {
                        let to_address = command.next()
                            .ok_or("Expected to_address arg")
                            .map_err(|err| anyhow!(err))?;
                        let feerate_preset = command.next()
                            .ok_or("Expected feerate_preset arg")
                            .map_err(|err| anyhow!(err))?;

                        show_results(binding::sweep(to_address.into(), feerate_preset.parse()?))
                    }
                    Some("recover_node") => {
                        let r = binding::recover_node(models::Network::Bitcoin, seed.to_vec());
                        greenlight_credentials = Some(r.unwrap());
                        info!(
                            "device_cert: {}; device_key: {}",
                            hex::encode(greenlight_credentials.clone().unwrap().device_cert),
                            hex::encode_upper(greenlight_credentials.clone().unwrap().device_key)
                        );
                    }
                    Some("create_node_services") => {
                        if greenlight_credentials.clone().is_none() {
                            print!("Credentials are not set. Are you missing a call to recover_node or register_node?");
                            continue;
                        }
                        match binding::create_node_services(
                            crate::models::Config::default(),
                            seed.to_vec(),
                            greenlight_credentials.clone().unwrap(),
                        ) {
                            Ok(_) => info!("Node services has been created!"),
                            Err(err) => info!("Error creating node services {}", err),
                        }
                    }
                    Some("start_node") => show_results(binding::start_node()),
                    Some("sync") => show_results(binding::sync()),
                    Some("list_lsps") => {
                        let lsps: Vec<LspInformation> = binding::list_lsps()?;
                        info!("The available LSPs are:");
                        for lsp in lsps {
                            info!("[{}] {}", lsp.id, lsp.name);
                        }
                        info!("Please choose an LSP with `set_lsp id`");
                    }
                    Some("set_lsp") => {
                        let lsps: Vec<LspInformation> = binding::list_lsps()?;
                        let chosen_lsp_id = command
                            .next()
                            .ok_or("Expected LSP ID arg")
                            .map_err(|err| anyhow!(err))?;
                        let chosen_lsp: &LspInformation = lsps
                            .iter()
                            .find(|lsp| lsp.id == chosen_lsp_id)
                            .ok_or("No LSO found for given LSP ID")
                            .map_err(|err| anyhow!(err))?;
                        binding::set_lsp_id(chosen_lsp_id.to_string())?;

                        info!(
                            "Set LSP ID: {} / LSP Name: {}",
                            chosen_lsp_id, chosen_lsp.name
                        );
                    }
                    Some("get_node_state") => show_results(binding::get_node_state()),
                    Some("list_fiat") => show_results(binding::list_fiat_currencies()),
                    Some("fetch_rates") => show_results(binding::fetch_rates()),
                    Some("run_signer") => show_results(binding::run_signer()),
                    Some("stop_signer") => show_results(binding::stop_signer()),
                    Some(_) => {
                        info!("Unrecognized command: {}", line.as_str());
                    }
                    None => (),
                }
                //info!("Line: {}", line);
            }
            Err(ReadlineError::Interrupted) => {
                info!("CTRL-C");
                break;
            }
            Err(ReadlineError::Eof) => {
                info!("CTRL-D");
                break;
            }
            Err(err) => {
                error!("Error: {:?}", err);
                break;
            }
        }
    }
    rl.save_history("history.txt").map_err(|e| anyhow!(e))
}

fn show_results<T>(res: Result<T>)
where
    T: core::fmt::Debug,
{
    match res {
        Ok(inner) => {
            info!("response: {:?}", inner);
        }
        Err(err) => error!("Error: {}", err),
    }
}
