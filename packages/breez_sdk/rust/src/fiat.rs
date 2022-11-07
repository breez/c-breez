use std::collections::HashMap;

use crate::grpc::RatesRequest;
use crate::models::FiatAPI;
use crate::node_service::BreezServer;
use anyhow::Result;
use serde::{Deserialize, Serialize};
use tonic::Request;

#[derive(Serialize, Deserialize, Debug)]
pub struct Symbol {
    pub grapheme: Option<String>,
    pub template: Option<String>,
    pub rtl: Option<bool>,
    pub position: Option<u32>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct LocaleOverrides {
    pub locale: String,
    pub spacing: Option<u32>,
    pub symbol: Symbol,
}

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
pub struct FiatCurrency {
    pub id: String,
    pub name: String,
    pub fraction_size: u32,
    pub spacing: Option<u32>,
    pub symbol: Option<Symbol>,
    pub uniq_symbol: Option<Symbol>,
    pub localized_name: Option<Vec<(String, String)>>,
    pub locale_overrides: Option<Vec<LocaleOverrides>>,
}

fn convert_to_fiat_currency_with_id(
    fiat_id: String,
    mut fiat_currency: FiatCurrency,
) -> FiatCurrency {
    fiat_currency.id = fiat_id;
    fiat_currency
}

#[tonic::async_trait]
impl FiatAPI for BreezServer {
    // retrieve all available fiat currencies from a local configuration file
    fn list_fiat_currencies() -> Result<Vec<FiatCurrency>> {
        let data = include_str!("../assets/json/currencies.json");
        let fiat_currency_map: HashMap<String, FiatCurrency> = serde_json::from_str(&data)?;
        let mut fiat_currency_list: Vec<FiatCurrency> = Vec::new();
        for (key, value) in fiat_currency_map {
            fiat_currency_list.push(convert_to_fiat_currency_with_id(key, value));
        }
        Ok(fiat_currency_list)
    }

    // get the live rates from the server
    async fn fetch_rates(&self) -> Result<Vec<(String, f64)>> {
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
