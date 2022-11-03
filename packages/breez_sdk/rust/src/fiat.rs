use crate::grpc::RatesRequest;
use crate::models::FiatAPI;
use crate::node_service::BreezLSP;
use anyhow::Result;
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use tonic::Request;

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
#[tonic::async_trait]
impl FiatAPI for BreezLSP {
    // retrieve all available fiat currencies from a local configuration file
    fn list_fiat_currencies() -> Result<HashMap<std::string::String, FiatCurrency>> {
        let data = include_str!("../assets/json/currencies.json");
        Ok(serde_json::from_str(&data).unwrap())
    }

    // get the live rates from the server
    async fn fetch_rates(&self) -> Result<HashMap<String, f64>> {
        let mut client = self.get_information_client().await?;

        let request = Request::new(RatesRequest {});
        let response = client.rates(request).await?;
        Ok(response
            .into_inner()
            .rates
            .into_iter()
            .map(|r| (r.coin, r.value))
            .collect())
    }
}
