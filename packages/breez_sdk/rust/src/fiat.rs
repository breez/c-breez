use std::{collections::HashMap, fs};

use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
struct Symbol {
    grapheme: Option<String>,
    template: Option<String>,
    rtl: Option<bool>,
    position: Option<u32>,
}

#[derive(Serialize, Deserialize, Debug)]
struct LocaleOverrides {
    spacing: Option<u32>,
    symbol: Symbol,
}

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
pub struct FiatCurrency {
    name: String,
    fraction_size: u32,
    spacing: Option<u32>,
    symbol: Option<Symbol>,
    uniq_symbol: Option<Symbol>,
    localized_name: Option<HashMap<String, String>>,
    locale_overrides: Option<HashMap<String, LocaleOverrides>>,
}

// retrieve all available fiat currencies from a local configuration file
pub fn list_fiat_currencies() -> HashMap<std::string::String, FiatCurrency> {
    // Perhaps use https://doc.rust-lang.org/std/macro.include_bytes.html instead of loading the file this way
    let data = fs::read_to_string("./assets/json/currencies.json").expect("Can't read file");
    serde_json::from_str(&data).unwrap()
}

// get the live rates from the server
pub fn fetch_rates() {
    todo!();
}
