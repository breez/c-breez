use bip39::{Language, Mnemonic, MnemonicType, Seed};
use hex;
use lightning_toolkit::binding;
use lightning_toolkit::models::{self, GreenlightCredentials};
use rustyline::error::ReadlineError;
use rustyline::{Editor, Result};
use std::fs;
use std::io;
use std::str::SplitWhitespace;

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
    let seed = get_seed();
    let mut greenlight_credentials: Option<GreenlightCredentials> = None;

    // `()` can be used when no completer is required
    let mut rl = Editor::<()>::new()?;
    if rl.load_history("history.txt").is_err() {
        println!("No previous history.");
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
                        println!(
                            "device_cert: {}; device_key: {}",
                            hex::encode(greenlight_credentials.clone().unwrap().device_cert),
                            hex::encode_upper(greenlight_credentials.clone().unwrap().device_key)
                        );
                    }
                    Some("recover_node") => {
                        let r = binding::recover_node(models::Network::Bitcoin, seed.to_vec());
                        greenlight_credentials = Some(r.unwrap());
                        println!(
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
                            models::Network::Bitcoin,
                            seed.to_vec(),
                            greenlight_credentials.clone().unwrap(),
                        ) {
                            Ok(_) => println!("Node services has been created!"),
                            Err(err) => println!("Error creating node services {}", err),
                        }
                    }
                    Some("start_node") => match binding::start_node() {
                        Ok(()) => println!("Node started"),
                        Err(err) => println!("Error starting node {}", err),
                    },
                    Some("sync") => match binding::sync() {
                        Ok(()) => println!("Synchronizing with node state has finished"),
                        Err(err) => println!("Error synchronizing node state {}", err),
                    },
                    Some(_) => {
                        println!("Unrecognized command: {}", line.as_str());
                    }
                    None => (),
                }
                //println!("Line: {}", line);
            }
            Err(ReadlineError::Interrupted) => {
                println!("CTRL-C");
                break;
            }
            Err(ReadlineError::Eof) => {
                println!("CTRL-D");
                break;
            }
            Err(err) => {
                println!("Error: {:?}", err);
                break;
            }
        }
    }
    rl.save_history("history.txt")
}
