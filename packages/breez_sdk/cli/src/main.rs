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

use crate::models::FeeratePreset;

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

fn save_creds(creds: GreenlightCredentials) -> Result<()> {
    let filename = "creds";
    fs::write(filename, serde_json::to_vec(&creds)?)?;
    Ok(())
}

fn get_creds() -> Option<GreenlightCredentials> {
    let filename = "creds";
    let creds: Option<GreenlightCredentials> = match fs::read(filename) {
        Ok(raw) => Some(serde_json::from_slice(raw.as_slice()).unwrap()),
        Err(e) => {
            if e.kind() != io::ErrorKind::NotFound {
                panic!("Can't read from file: {}, err {}", filename, e);
            }
            None
        }
    };
    creds
}

fn main() -> Result<()> {
    env_logger::Builder::from_env(
        Env::default()
            .default_filter_or("debug,rustyline=warn,hyper=warn,reqwest=warn,rustls=warn,h2=warn"),
    )
    .init();
    let seed = get_seed();

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
                        let r = binding::register_node(
                            models::Network::Bitcoin,
                            seed.to_vec(),
                            Option::None,
                        );
                        let greenlight_credentials = Some(r.unwrap());
                        info!(
                            "device_cert: {}; device_key: {}",
                            hex::encode(greenlight_credentials.clone().unwrap().device_cert),
                            hex::encode_upper(greenlight_credentials.clone().unwrap().device_key)
                        );
                        save_creds(greenlight_credentials.unwrap())?;
                    }
                    Some("recover_node") => {
                        let r = binding::recover_node(
                            models::Network::Bitcoin,
                            seed.to_vec(),
                            Option::None,
                        );
                        let greenlight_credentials = Some(r.unwrap());
                        info!(
                            "device_cert: {}; device_key: {}",
                            hex::encode(greenlight_credentials.clone().unwrap().device_cert),
                            hex::encode_upper(greenlight_credentials.clone().unwrap().device_key)
                        );
                        save_creds(greenlight_credentials.unwrap())?;
                    }

                    Some("init") => {
                        let creds = get_creds();
                        if creds.is_none() {
                            info!("credentials not found");
                            continue;
                        }
                        show_results(binding::init_node(None, seed.to_vec(), creds.unwrap()));
                    }
                    Some("request_payment") => {
                        let amount_sats: u64 = command.next().unwrap().parse()?;
                        let description = command.next().unwrap();

                        show_results(binding::receive_payment(
                            amount_sats,
                            description.to_string(),
                        ));
                    }
                    Some("send_payment") => {
                        let bolt11 = command
                            .next()
                            .ok_or("Expected bolt11 arg")
                            .map_err(|err| anyhow!(err))?;

                        show_results(binding::send_payment(bolt11.into()))
                    }
                    Some("send_spontaneous_payment") => {
                        let node_id = command
                            .next()
                            .ok_or("Expected node_id arg")
                            .map_err(|err| anyhow!(err))?;
                        let amount_sats = command
                            .next()
                            .ok_or("Expected amount_sats arg")
                            .map_err(|err| anyhow!(err))?;

                        show_results(binding::send_spontaneous_payment(
                            node_id.into(),
                            amount_sats.parse()?,
                        ))
                    }
                    Some("list_txs") => show_results(binding::list_transactions(
                        models::PaymentTypeFilter::All,
                        None,
                        None,
                    )),
                    Some("sweep") => {
                        let to_address = command
                            .next()
                            .ok_or("Expected to_address arg")
                            .map_err(|err| anyhow!(err))?;
                        let feerate_preset: i32 = command
                            .next()
                            .ok_or("Expected feerate_preset arg")
                            .map_err(|err| anyhow!(err))?
                            .parse()?;

                        show_results(binding::withdraw(
                            to_address.into(),
                            FeeratePreset::try_from(feerate_preset)?,
                        ))
                    }
                    Some("list_lsps") => show_results(binding::list_lsps()),
                    Some("set_lsp") => {
                        let lsps: Vec<LspInformation> = binding::list_lsps()?;
                        let chosen_lsp_id = command
                            .next()
                            .ok_or("Expected LSP ID arg")
                            .map_err(|err| anyhow!(err))?;
                        let chosen_lsp: &LspInformation = lsps
                            .iter()
                            .find(|lsp| lsp.id == chosen_lsp_id)
                            .ok_or("No LSP found for given LSP ID")
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
                    Some("close_lsp_channels") => show_results(binding::close_lsp_channels()),
                    Some("stop_node") => show_results(binding::stop_node()),

                    Some("create_swap") => show_results(binding::create_swap()),
                    Some("list_swaps") => show_results(binding::list_swaps()),
                    Some("refund_swap") => show_results({
                        let swap_address = command
                            .next()
                            .ok_or("Expected swap_address arg")
                            .map_err(|err| anyhow!(err))?;
                        let to_address = command
                            .next()
                            .ok_or("Expected to_address arg")
                            .map_err(|err| anyhow!(err))?;
                        let sat_per_weight_fee: u32 = command
                            .next()
                            .ok_or("Expected to_address arg")
                            .map_err(|err| anyhow!(err))?
                            .parse()?;
                        binding::refund_swap(
                            swap_address.to_string(),
                            to_address.to_string(),
                            sat_per_weight_fee,
                        )
                    }),

                    Some("redeem_swap") => show_results({
                        let swap_address = command
                            .next()
                            .ok_or("Expected swap_address arg")
                            .map_err(|err| anyhow!(err))?;
                        binding::redeem_swap(swap_address.to_string())
                    }),

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
            info!("response: {:#?}", inner);
        }
        Err(err) => error!("Error: {}", err),
    }
}
