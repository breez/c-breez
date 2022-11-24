use std::str::FromStr;

use anyhow::{anyhow, Result};
use bip21::Uri;
use bitcoin::bech32;
use bitcoin::bech32::FromBase32;
use serde::Deserialize;
use serde_with::json::JsonString;
use serde_with::serde_as;

use crate::input_parser::InputType::*;
use crate::invoice::{parse_invoice, LNInvoice};

/// Parses generic user input, typically pasted from clipboard or scanned from a QR
pub fn parse(raw_input: &str) -> Result<InputType> {
    // If the `lightning:` prefix is there, strip it for the bolt11 parsing function
    let prepared_input = raw_input.trim_start_matches("lightning:");

    // Check if valid BTC onchain address
    if let Ok(addr) = bitcoin::Address::from_str(prepared_input) {
        return Ok(BitcoinAddress(BitcoinAddressData {
            address: prepared_input.into(),
            network: addr.network.into(),
            amount_sat: None,
            label: None,
            message: None,
        }));
    }

    // Check if valid BTC onchain address (BIP21)
    if let Ok(uri) = prepared_input.parse::<Uri<'_>>() {
        let bitcoin_addr_data = BitcoinAddressData {
            address: uri.address.to_string(),
            network: uri.address.network.into(),
            amount_sat: uri.amount.map(|a| a.to_sat()),
            label: uri.label.map(|label| label.try_into().unwrap()),
            message: uri.message.map(|msg| msg.try_into().unwrap()),
        };

        // Special case of LN BOLT11 with onchain fallback
        // Search for the `lightning=bolt11` param in the BIP21 URI and, if found, extract the bolt11
        let mut invoice_param: Option<LNInvoice> = None;
        if let Some(query) = prepared_input.split('?').collect::<Vec<_>>().get(1) {
            invoice_param = querystring::querify(query)
                .iter()
                .find(|(key, _)| key == &"lightning")
                .map(|(_, value)| parse_invoice(value))
                .transpose()?;
        }

        return match invoice_param {
            None => Ok(BitcoinAddress(bitcoin_addr_data)),
            Some(invoice) => Ok(Bolt11(invoice)),
        };
    }

    if let Ok(invoice) = parse_invoice(prepared_input) {
        return Ok(Bolt11(invoice));
    }

    if let Ok(_node_id) = bitcoin::secp256k1::PublicKey::from_str(prepared_input) {
        // Public key serialized in compressed form
        return Ok(NodeId(prepared_input.into()));
    }

    if let Ok(url) = reqwest::Url::parse(prepared_input) {
        if ["http", "https"].contains(&url.scheme()) {
            return Ok(Url(prepared_input.into()));
        }
    }

    if let Ok(mut lnurl_endpoint) = lnurl_decode(prepared_input) {
        // if let Ok(lnurl_pay_data) = serde_json::from_str::<LnUrlPayData>(resp) {
        //     return Ok(LnUrlPay(lnurl_pay_data));
        // }

        #[cfg(test)]
        {
            // Block executed only during tests
            lnurl_endpoint = tests::replace_host_with_mockito_test_host(lnurl_endpoint)?;
        }

        let data: LnUrlPayData = reqwest::blocking::get(lnurl_endpoint)?.json()?;
        return Ok(LnUrlPay(data));
    }

    // TODO Parse the other InputTypes

    Err(anyhow!("Unrecognized input type"))
}

/// Decodes the bech32-encoded LNURL and returns the payload
///
/// The only allowed schemes are http (for onion domains) and https (for clearnet domains)
///
/// LNURLs in all uppercase or all lowercase are valid, but mixed case ones are invalid.
fn lnurl_decode(encoded: &str) -> Result<String> {
    let (_hrp, payload, _variant) = bech32::decode(encoded)?;
    let decoded = String::from_utf8(Vec::from_base32(&payload)?).map_err(|e| anyhow!(e))?;

    let url = reqwest::Url::parse(&decoded)?;
    let domain = url
        .domain()
        .ok_or_else(|| anyhow!("Could not determine domain"))?;

    if url.scheme() == "http" && !domain.ends_with(".onion") {
        return Err(anyhow!("HTTP scheme only allowed for onion domains"));
    }
    if url.scheme() == "https" && domain.ends_with(".onion") {
        return Err(anyhow!("HTTPS scheme not allowed for onion domains"));
    }

    Ok(decoded)
}

pub enum InputType {
    BitcoinAddress(BitcoinAddressData),
    /// Also covers URIs like `bitcoin:...&lightning=bolt11`. In this case, it returns the BOLT11
    /// and discards all other data.
    Bolt11(LNInvoice),
    NodeId(String),
    Url(String),
    LnUrlPay(LnUrlPayData),
    LnUrlWithdraw(String),
}

#[serde_as]
#[derive(Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
pub struct LnUrlPayData {
    pub callback: String,
    pub min_sendable: u16,
    pub max_sendable: u16,
    /// As per LUD-06, `metadata` is a raw string (e.g. a json representation of the inner map)
    ///
    /// See https://docs.rs/serde_with/latest/serde_with/guide/serde_as_transformations/index.html#value-into-json-string
    #[serde_as(as = "JsonString")]
    pub metadata: Vec<MetadataItem>,
    pub comment_allowed: u16,
    pub tag: String,
}

#[derive(Deserialize, Debug)]
pub struct MetadataItem {
    pub key: String,
    pub value: String,
}

pub struct BitcoinAddressData {
    pub address: String,
    pub network: crate::models::Network,
    pub amount_sat: Option<u64>,
    pub label: Option<String>,
    pub message: Option<String>,
}

#[cfg(test)]
mod tests {
    use anyhow::anyhow;
    use anyhow::Result;
    use bitcoin::bech32;
    use bitcoin::bech32::{ToBase32, Variant};
    use bitcoin::secp256k1::{PublicKey, Secp256k1, SecretKey};
    use mockito;

    use crate::input_parser::*;
    use crate::models::Network;

    /// Replaces the scheme, host and port with a local mockito host. Preserves the rest of the path.
    pub(crate) fn replace_host_with_mockito_test_host(lnurl_endpoint: String) -> Result<String> {
        let mockito_endpoint_url = reqwest::Url::parse(&mockito::server_url())?;
        let mut parsed_lnurl_endpoint = reqwest::Url::parse(&lnurl_endpoint)?;

        parsed_lnurl_endpoint.set_host(mockito_endpoint_url.host_str())?;
        let _ = parsed_lnurl_endpoint.set_scheme(mockito_endpoint_url.scheme());
        let _ = parsed_lnurl_endpoint.set_port(mockito_endpoint_url.port());

        Ok(parsed_lnurl_endpoint.to_string())
    }

    #[test]
    fn test_generic_invalid_input() -> Result<(), Box<dyn std::error::Error>> {
        assert!(parse("invalid_input").is_err());

        Ok(())
    }

    #[test]
    fn test_bitcoin_address() -> Result<()> {
        assert!(matches!(
            parse("1andreas3batLhQa2FawWjeyjCqyBzypd")?,
            InputType::BitcoinAddress(_)
        ));

        Ok(())
    }

    #[test]
    fn test_bitcoin_address_bip21() -> Result<()> {
        // Addresses from https://github.com/Kixunil/bip21/blob/master/src/lib.rs

        // Valid address with the `bitcoin:` prefix
        assert!(parse("bitcoin:1andreas3batLhQa2FawWjeyjCqyBzypd").is_ok());
        assert!(parse("bitcoin:testinvalidaddress").is_err());

        let addr = "1andreas3batLhQa2FawWjeyjCqyBzypd";

        // Address with amount
        let addr_1 = format!("bitcoin:{}?amount=0.00002000", addr);
        match parse(&addr_1)? {
            InputType::BitcoinAddress(addr_with_amount_parsed) => {
                assert_eq!(addr_with_amount_parsed.address, addr);
                assert_eq!(addr_with_amount_parsed.network, Network::Bitcoin);
                assert_eq!(addr_with_amount_parsed.amount_sat, Some(2000));
                assert_eq!(addr_with_amount_parsed.label, None);
                assert_eq!(addr_with_amount_parsed.message, None);
            }
            _ => return Err(anyhow!("Invalid type parsed")),
        }

        // Address with amount and label
        let label = "test-label";
        let addr_2 = format!("bitcoin:{}?amount=0.00002000&label={}", addr, label);
        match parse(&addr_2)? {
            InputType::BitcoinAddress(addr_with_amount_parsed) => {
                assert_eq!(addr_with_amount_parsed.address, addr);
                assert_eq!(addr_with_amount_parsed.network, Network::Bitcoin);
                assert_eq!(addr_with_amount_parsed.amount_sat, Some(2000));
                assert_eq!(addr_with_amount_parsed.label, Some(label.into()));
                assert_eq!(addr_with_amount_parsed.message, None);
            }
            _ => return Err(anyhow!("Invalid type parsed")),
        }

        // Address with amount, label and message
        let message = "test-message";
        let addr_3 = format!(
            "bitcoin:{}?amount=0.00002000&label={}&message={}",
            addr, label, message
        );
        match parse(&addr_3)? {
            InputType::BitcoinAddress(addr_with_amount_parsed) => {
                assert_eq!(addr_with_amount_parsed.address, addr);
                assert_eq!(addr_with_amount_parsed.network, Network::Bitcoin);
                assert_eq!(addr_with_amount_parsed.amount_sat, Some(2000));
                assert_eq!(addr_with_amount_parsed.label, Some(label.into()));
                assert_eq!(addr_with_amount_parsed.message, Some(message.into()));
            }
            _ => return Err(anyhow!("Invalid type parsed")),
        }

        Ok(())
    }

    #[test]
    fn test_bolt11() -> Result<()> {
        let bolt11 = "lnbc110n1p38q3gtpp5ypz09jrd8p993snjwnm68cph4ftwp22le34xd4r8ftspwshxhmnsdqqxqyjw5qcqpxsp5htlg8ydpywvsa7h3u4hdn77ehs4z4e844em0apjyvmqfkzqhhd2q9qgsqqqyssqszpxzxt9uuqzymr7zxcdccj5g69s8q7zzjs7sgxn9ejhnvdh6gqjcy22mss2yexunagm5r2gqczh8k24cwrqml3njskm548aruhpwssq9nvrvz";

        // Invoice without prefix
        assert!(matches!(parse(bolt11)?, InputType::Bolt11(_invoice)));

        // Invoice with prefix
        let invoice_with_prefix = format!("lightning:{}", bolt11);
        assert!(matches!(
            parse(&invoice_with_prefix)?,
            InputType::Bolt11(_invoice)
        ));

        Ok(())
    }

    #[test]
    fn test_bolt11_with_fallback_bitcoin_address() -> Result<()> {
        let addr = "1andreas3batLhQa2FawWjeyjCqyBzypd";
        let bolt11 = "lnbc110n1p38q3gtpp5ypz09jrd8p993snjwnm68cph4ftwp22le34xd4r8ftspwshxhmnsdqqxqyjw5qcqpxsp5htlg8ydpywvsa7h3u4hdn77ehs4z4e844em0apjyvmqfkzqhhd2q9qgsqqqyssqszpxzxt9uuqzymr7zxcdccj5g69s8q7zzjs7sgxn9ejhnvdh6gqjcy22mss2yexunagm5r2gqczh8k24cwrqml3njskm548aruhpwssq9nvrvz";

        // Address and invoice
        // BOLT11 is the first URI arg (preceded by '?')
        let addr_1 = format!("bitcoin:{}?lightning={}", addr, bolt11);
        assert!(matches!(parse(&addr_1)?, InputType::Bolt11(_invoice)));

        // Address, amount and invoice
        // BOLT11 is not the first URI arg (preceded by '&')
        let addr_2 = format!("bitcoin:{}?amount=0.00002000&lightning={}", addr, bolt11);
        assert!(matches!(parse(&addr_2)?, InputType::Bolt11(_invoice)));

        Ok(())
    }

    #[test]
    fn test_url() -> Result<()> {
        assert!(matches!(
            parse("https://breez.technology")?,
            InputType::Url(_url)
        ));
        assert!(matches!(
            parse("https://breez.technology/")?,
            InputType::Url(_url)
        ));
        assert!(matches!(
            parse("https://breez.technology/test-path")?,
            InputType::Url(_url)
        ));
        assert!(matches!(
            parse("https://breez.technology/test-path?arg1=val1&arg2=val2")?,
            InputType::Url(_url)
        ));

        Ok(())
    }

    #[test]
    fn test_node_id() -> Result<()> {
        let secp = Secp256k1::new();
        let secret_key = SecretKey::from_slice(&[0xab; 32])?;
        let public_key = PublicKey::from_secret_key(&secp, &secret_key);

        match parse(&public_key.to_string())? {
            InputType::NodeId(node_id) => {
                assert_eq!(node_id, public_key.to_string());
            }
            _ => return Err(anyhow!("Unexpected type")),
        }

        // Other formats and sizes
        assert!(parse("012345678901234567890123456789012345678901234567890123456789mnop").is_err());
        assert!(parse("0123456789").is_err());
        assert!(parse("abcdefghij").is_err());

        Ok(())
    }

    #[test]
    fn test_lnurl_pay_lud_01() -> Result<()> {
        // Covers cases in LUD-01: Base LNURL encoding and decoding
        // https://github.com/lnurl/luds/blob/luds/01.md

        // HTTPS allowed with clearnet domains
        assert!(lnurl_decode(&bech32::encode(
            "LNURL",
            "https://domain.com".to_base32(),
            Variant::Bech32
        )?)
        .is_ok());

        // HTTP not allowed with clearnet domains
        assert!(lnurl_decode(&bech32::encode(
            "LNURL",
            "http://domain.com".to_base32(),
            Variant::Bech32
        )?)
        .is_err());

        // HTTP allowed with onion domains
        assert!(lnurl_decode(&bech32::encode(
            "LNURL",
            "http://3fdsf.onion".to_base32(),
            Variant::Bech32
        )?)
        .is_ok());

        // HTTPS not allowed with onion domains
        assert!(lnurl_decode(&bech32::encode(
            "LNURL",
            "https://3fdsf.onion".to_base32(),
            Variant::Bech32
        )?)
        .is_err());

        let decoded_url = "https://service.com/api?q=3fc3645b439ce8e7f2553a69e5267081d96dcd340693afabe04be7b0ccd178df";
        let lnurl_raw = "LNURL1DP68GURN8GHJ7UM9WFMXJCM99E3K7MF0V9CXJ0M385EKVCENXC6R2C35XVUKXEFCV5MKVV34X5EKZD3EV56NYD3HXQURZEPEXEJXXEPNXSCRVWFNV9NXZCN9XQ6XYEFHVGCXXCMYXYMNSERXFQ5FNS";

        assert_eq!(lnurl_decode(lnurl_raw)?, decoded_url);

        // Uppercase and lowercase allowed, but mixed case is invalid
        assert!(lnurl_decode(&lnurl_raw.to_uppercase()).is_ok());
        assert!(lnurl_decode(&lnurl_raw.to_lowercase()).is_ok());
        assert!(lnurl_decode(&format!(
            "{}{}",
            lnurl_raw[..5].to_uppercase(),
            lnurl_raw[5..].to_lowercase()
        ))
        .is_err());

        Ok(())
    }

    #[test]
    fn test_lnurl_pay_lud_06() -> Result<(), Box<dyn std::error::Error>> {
        // Covers cases in LUD-06: payRequest base spec
        // https://github.com/lnurl/luds/blob/luds/06.md

        let expected_lnurl_pay_data = r#"
{
    "callback":"https://lnurl.fiatjaf.com/lnurl-pay/callback/db945b624265fc7f5a8d77f269f7589d789a771bdfd20e91a3cf6f50382a98d7",
    "tag":"payRequest",
    "maxSendable":16000,
    "minSendable":4000,
    "metadata":"[
        [\"text/plain\",\"WRhtV\"],
        [\"text/long-desc\",\"MBTrTiLCFS\"],
        [\"image/png;base64\",\"iVBORw0KGgoAAAANSUhEUgAAASwAAAEsCAYAAAB5fY51AAATOElEQVR4nO3dz4slVxXA8fIHiEhCjBrcCHEEXbiLkiwd/LFxChmQWUVlpqfrdmcxweAk9r09cUrQlWQpbgXBv8CdwrhRJqn7umfEaEgQGVGzUEwkIu6ei6TGmvH16/ej6p5z7v1+4Ozfq3vqO5dMZ7qqAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgHe4WbjuutBKfw4AWMrNwnUXw9zFMCdaANS6J1ZEC4BWC2NFtABoszRWRAuAFivFimgBkLZWrIgWACkbxYpoAUhtq1gRLQCpjBIrogVU1ZM32webma9dDM+7LrR3J4bnm5mvn7zZPij9GS0bNVZEaxTsvDEu+iea6F9w0d9a5QVpunDcRP/C7uzgM9Kf3ZJJYkW0NsLOG7PzynMPNDFcaTr/2+1eFH/kon/q67evfkD6O2k2aayI1krYeYPO3mjf67rwjIv+zZFfmL+5zu+18/bd0t9RmySxIlonYueNuvTS4cfe/tNhuhem6cKvXGw/LP1dtUgaK6L1f9h5o/aODj/rov9Hihemif4vzS3/SenvLE0kVkTrLnbeKBfDYxNch0+bv7p47RPS312KaKyIFjtv1U53cMZ1/u8yL42/s3/76iPSzyA1FbEqOFrsvFGXX24fdtH/UfKFaaKP0s8hJVWxKjBa7LxhTfQ3xF+WGOYu+h9LP4sUVMaqsGix80a56J+WP7T/ze7s4PPSz2RKqmNVSLTYeaMuHfmPuBjekj6w4TTRvyb9XKZiIlaZR4udN6yJ/gfSh7Vo9mb+kvSzGZupWGUcLXbeqJ1XnnvAdf7f0gd1wrwq/XzGZDJWGUaLnTesmYWLCg5p2Twm/YzGYDpWmUWLnTfMxfAzBQd04ux24XvSz2hbWcQqo2ix80ZdmF94j4v+P9IHtHz8TenntI2sYtWP4Wix84Zd7g4flz+c00f6OW0qy1j1YzRa7LxhTRd2pA9mlWluffvT0s9qXVnHqh+D0WLnDbPyUjWd/4r0s1qHlec6yhiLlpWzsbbzSTTRf1f6YFaZvdmhk35Wq7LyQow6hqLFzhvWRP8d6YNZZZoYvPSzWkWRserHSLTYecPcLDwrfTArzrekn9Vpio5VPwaixc4b1sTDfQUHs8rsSj+rZYjVYJRHi503bLfzX1ZwMKdO0x18UfpZnYRYLRjF0WLnDds/PnhU+mBWmYsvPftR6We1CLFaMkqjxc4b5zr/uvThLF98/wfpZ7QIsVrl7HRGi503zHXhJ+IHtGSaGH4k/YzuR6zWefn0RYudN8xFf176gJbN3lH4gvQzGiJWG4yyaLHzxrku/FP6kE5Y9D9JP5shYrXVWbbS5zfEzhvmutCKH9TC8U9LP5sesRrlZWylz7HHzht28bh9SOCXSJ623Gr+pCFWo55rK32eVcXOm7c3O3TiB3bP+PPSz6SqiNVEL2Yrfa5Vxc6b57rwC/lDC/Mm+p9KP4uqIlaTjpJosfOGvfNbcO+IHlwXji/8+pn3Sz8LYpVgFESLnTdupzs408Twhszh+Tv7t68+Iv0MiFXCURAtdt64y93h4030/0p8eH/e6Q7OSH93YiUwCqJV8s5nwUX/RLq/RfF3dm9f+7j4dyZWcqMgWiXufFb2jw8ebWL43ZQH13T+50/95uCD0t+VWCkYBdEqaeezdOW1K+9rYvAuhrfGXU7/ejMLF6t59S7p70isFI2CaJWw89m7/HL7sJv5b7oYXt3u4PzNvVn4mvT36RErhaMgWlWV784Xpznyn2ti+KGL/verHFjThRdd57+/0137lPRnHyJWikdJtHq57HzxvvGi/1DTHX7VzcJ114X27sx82O3Cl7T+fAmxMjDKotWzuvMwilgZGqXRApIgVgaHaKFExMrwEC2UhFhlMEQLJSBWGQ3RQs6IVYZDtJAjYpXxEC3khFgVMEQLOSBWBQ3RgmXEqsAhWrDIdaGt63rOlDdEC6b0v2dO+sVhhILFTQtWDH8ppvSLwwgGi2hBu/t/g6/0i8MIB4toQatFv25c+sVhFASLaEGbRbEiWOUOf3sItU6KFcEqd/iRB6i0LFYEq9zh57SgzmmxIljlDj9cClVWiRXBKnf4iXiosWqsCFa5w//GAxXWiRXBKnfW2RGihUmsGyuCVe6suydEC6PaJFYEq9zZZFeIFkaxaawIVrmz6b4QLWxlm1gRrHJnm50hWtjItrEiWOXOtntDtLCWMWJFsMqdMXaHaGElY8WKYJU7Y+0P0cJSY8aKYJU7Y+4Q0cJCY8eKYJU7Y+8R0cI9pogVwSp3ptglooWqqqaLFcEqd6baJ6JVuCljRbDKnSl3imgVaupYEaxyZ+q9IlqFSRGrhME6K/Uc67q29Mtif1nX9dksgkW0ypEqVgmDdUPiOZ4/f/6huq7fUBCilULVf+5sgkW08pcyVgmDNa8Fblm1/tvVPaEafO58gkW08pU6VomDlfSWpfx2tTBUveyCRbTyIxGrxMGaL3tJx1brvF0tDdXgs+cXLKKVD6lYCQQryS1L4e1qpVD1sg0W0bJPMlYCwZqv8+JuqtZzu1orVIPPn2+wiJZd0rESCtaktywlt6uNQtXLPlhEyx4NsRIK1nybl/k0teztaqtQDb5D/sEiWnZoiZVgsCa5ZQnerkYJVa+YYBEt/TTFSjBY8zFf8F6d/nY1aqgG36OcYBEtvbTFSjhYo96yEt+uJglVr7hgES19NMZKOFjzMV/6Os3tatJQDb5LecEiWnpojZWCYI1yy0pwu0oSql6xwSJa8jTHSkGw5mOEoJ7udpU0VIPvU26wiJYc7bFSEqytblkT3a5EQtUrPlhEKz0LsVISrPk2cainuV29Udf19fPnzz804kqs850IFtFKx0qsFAVro1tWgv92JRIugkW0krEUK0XBmteb/T93qX7uKmm4CBbRSsJarJQFa61bltBPtScJF8EiWpOzGCtlwZrX6/0TLJL/z+Ck4SJYRGtSVmOlMFgr3bKU/IsMk4WLYBGtyViOlcJgzevV/kVOLf/e1SThIlhEaxLWY6U0WEtvWYpuV5OFi2ARrdHlECulwZrXy39Bg7bb1ejhIlhEa1S5xEpxsBbespTfrkYLF8EiWqPJKVaKgzWvF/++Pgu3q63DRbCI1ihyi5XyYN1zyzJ4u9o4XASLaG0tx1gpD9a8vvfXt1u9Xa0dLoJFtLaSa6wMBOtGVWVzu1o5XASLaG0s51gZCNa8ruuzdV63q1PDRbCI1kZyj5WRYN2o87xdnRgugkW01lZCrIwEiyFYRGuZUmJFsMod6b0jWiMpKVYEq9yR3juiNYLSYkWwyh3pvSNaWyoxVgSr3JHeO6K1hVJjRbDKHem9I1pbIFhMaSO9dwRrS6VGS/rFYQgWsdpQidGSfnEYgkWstlBatKRfHIZgEastlRQt6ReHIVjEagSlREv6xWEIFrEaSQnRSvSCtOfOnXtT+iVNMe98z19Kf47ig1VarHq5RyvFy1FVd/9NqxLC1dZv/5M40p+j3GCVGqteztFKFaxezuE6d+7cm4N/00r1LUt674jVxHKNVupg9TINV9t/v1r5LUt674hVAjlGSypYvVzCNbxd9WrFtyzpvSNWieQWLelg9TIIV3v/d6oV37Kk945YJZRTtLQEq2cxXItuV71a6S1Leu+IVWK5REtbsHrGwtWe9D1qpbcs6b0jVgJyiJbWYPW0h2vZ7apXK7xlSe8dsRJiPVrag9VTHK72tM9eK7xlSe8dsRJkOVpWgtXTFK5Vble9WtktS3rviJUwq9GyFqyeknC1q37eWtktS3rviJUCFqNlNVg9qXCtc7vq1YpuWdJ7R6yUsBYt68HqCYSrXfcz1opuWdJ7R6wUsRStXILVSxGuTW5XvVrJLUt674iVMlailVuwehOHq930c9VKblnSe0esFLIQrVyDVVV343BjzO+yze1q8LnEb1nSe0eslNIerRyDNUWoBtOO9PkIFrHSSXO0cgrWxKEa5XY1+KyityzpvSNWymmNVg7BmjpUg2lH/swEi1jppTFaloOVMFSj3q4Gn1/sliW9d8TKCG3RshislKEaTDvR9yBYxEo3TdGyFCyhUE1yuxp8J5FblvTeEStjtETLQrCkQjWYdoQjX/bdygwWsbJFQ7Q0B0tBqCa9XQ2+Z/JblvTeESujpKOlMVgaQjWYdoJjX/R9ywkWsbJNMlqagqUsVEluV4PvnvSWRaywFaloaQiWtlANpk1w9MNnkHewiFVeJKIlGSzFoUp6uxo8j2S3LGKFUaSOlkSwNIdqMG3qs68T3rKIFUaTMlopg2UkVCK3q8EzSnLLIlYYVapoJYqAiVANppU69zrRLYtYYXQpoqUgDozAECtMYupoSb84TIbBIlZlmzJa0i8Ok1mwiBWqarpoSb84TEbBIlYYmiJa0i8Ok0mwiBUWGTta0i8Ok0GwiBWWGTNa0i8OYzxYxAqrGCta0i8OYzhYxArrGCNa0i8OYzRYxAqb2DZa0i8OYzBYxArb2CZa0i8OYyxYxApj2DRa0i8OYyhYxApj2iRa0i8OYyRYxApTWDda0i8OYyBYxApTWida0i8OozxYxAoprBot6ReHURwsYoWUVomW9IvDKA0WsYKE06Il/eIwCoNFrCBpWbSkXxxGWbCIFTQ4KVrSLw6jKFjECposipb0i8MoCRaxgkb3R0v6xWEUBItYQbNhtKRfHEY4WMQKFvTRkn5xGMFgEStY4rrQSr84jFCwiBUsSvUbphlFQ6xgGdEqaIgVckC0ChhihZwQrYyHWCFHRCvDIVbIGdHKaIgVSkC0MhhihZIQLcNDrFAiomVwiBVKRrQMDbHCmJ682T7YzHztYnjedaG9OzE838x8/eTN9kHpz7gI0TIwSmNldeeL5aJ/oon+BRf9rVUWr+nCcRP9C7uzg89If/YhoqV4lMUql50vxs4rzz3QxHCl6fxvt1tEf+Sif+rrt69+QPo7VRXRUjlKYpXrzmft7I32va4Lz7jo3xx5Mf/mOr/Xztt3S39HoqVoFMSqhJ3P0qWXDj/29p8O0y1o04Vfudh+WPq7Ei0FoyBWJe18VvaODj/rov9HikVtov9Lc8t/Uvo7Ey3BURCrEnc+Cy6Gxya4Dp82f3Xx2ifEvzvRSj8KYlXyzpu20x2ccZ3/u8zy+jv7t68+Iv0MiFbCURArdt6oyy+3D7vo/yi5wE30Ufo5VBXRSjIKYsXOG9ZEf0N8iWOYu+h/LP0sqopoTToKYlVV7LxZLvqn5Q/tf7M7O/i89DOpKqI1ySiJFTtv1KUj/xEXw1vSBzacJvrXpJ9Lj2iNOEpixc4b1kT/A+nDWjR7M39J+tn0iNYIoyRWVcXOm7XzynMPuM7/W/qgTphXpZ/PENHaYhTFip03rJmFiwoOadk8Jv2MhojWBqMoVlXFzpvmYviZggM6cXa78D3pZ3Q/orXGKItVVbHzZl2YX3iPi/4/0ge0fPxN6ee0CNFaYRTGip037HJ3+Lj84Zw+0s/pJERrySiMVVWx86Y1XdiRPphVprn17U9LP6uTEK0FozRWVcXOm+Zm4br0wax0eJ3/ivSzWoZoDUZxrKqKnTetif670gezyuzNDp30szoN0QrqY1VV7LxpTfTfkT6YVaaJwUs/q1UUHS0Dsaoqdt40NwvPSh/MivMt6We1qiKjZSRWVcXOm9bEw30FB7PK7Eo/q3UUFS1Dsaoqdt603c5/WcHBnDpNd/BF6We1riKiZSxWVcXOm7Z/fPCo9MGsMhdfevaj0s9qE1lHy2CsqoqdN891/nXpw1n+Yvg/SD+jbWQZLaOx6rHzhrku/ET8gJZME8OPpJ/RtrKKlvFYVRU7b5qL/rz0AS2bvaPwBelnNIYsopVBrKqKnTfPdeGf0od0wgvyJ+lnMybT0cokVj123jC9L5J/WvrZjE3vsy4nVlWl+Rzy2/nRXTxuHxL4JZKnvSTZ/kmj92UpI1ZVxc6btzc7dOIHds/489LPZEomopVprHrsvHGuC7+QP7Qwb6L/qfSzSEF1tDKPVY+dN+yd34J7R/TgunB84dfPvF/6WaSiMlqFxKqq2HnzdrqDM00Mb8gcnr+zf/vqI9LPIDVV0SooVj123rjL3eHjTfT/Snx4f97pDs5If3cpKqJVYKx67LxxLvon0v0tir+ze/vax6W/szTRaBUcqx47b9z+8cGjTQy/m/Lgms7//KnfHHxQ+rtqIRItYnUXO2/cldeuvK+JwbsY3hr3JfGvN7NwsZpX75L+jtokjRax+j/sfAYuv9w+7Gb+my6GV7c7OH9zbxa+Jv19tEsSLWK1FDufiebIf66J4Ycu+t+vcmBNF150nf/+TnftU9Kf3ZJJo0Ws1sLOZ+IbL/oPNd3hV90sXHddaO/OzIfdLnyJny/ZziTRIlZbYeeBJUaNFrECMLVRokWsAKSyVbSIFYDUNooWsQIgZa1oESsA0laKFrECoMXSaBErANosjBaxAqDVPdEiVgC063/aWvpzAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQI//AplAdntdLBX1AAAAAElFTkSuQmCC\"]
    ]",
    "commentAllowed":0,
    "payerData":{
        "name":{"mandatory":false},
        "pubkey":{"mandatory":false},
        "identifier":{"mandatory":false},
        "email":{"mandatory":false},
        "auth":{"mandatory":false,"k1":"18ec6d5b96db6f219baed2f188aee7359fcf5bea11bb7d5b47157519474c2222"}
    }
}
        "#.replace('\n', "");

        let _m = mockito::mock(
            "GET",
            "/lnurl-pay?session=db945b624265fc7f5a8d77f269f7589d789a771bdfd20e91a3cf6f50382a98d7",
        )
        .with_body(expected_lnurl_pay_data)
        .create();

        // Test URL from https://lnurl.fiatjaf.com/
        // LNURL resolves to https://lnurl.fiatjaf.com/lnurl-pay?session=db945b624265fc7f5a8d77f269f7589d789a771bdfd20e91a3cf6f50382a98d7
        let lnurl_pay_encoded = "lightning:LNURL1DP68GURN8GHJ7MRWW4EXCTNXD9SHG6NPVCHXXMMD9AKXUATJDSKHQCTE8AEK2UMND9HKU0TYVGUNGDTZXCERGV3KX4NXXDMXX4SNSEPHXANRYD3EVCMN2WPEVSMNSWTPXUMNZCNYVEJRYVR98YCKZVMRVCMXVDFSXVURYCFE8PJRW2CN9F5";
        match parse(lnurl_pay_encoded)? {
            LnUrlPay(lnurl_pay_data) => {
                assert_eq!(lnurl_pay_data.callback, "https://lnurl.fiatjaf.com/lnurl-pay/callback/db945b624265fc7f5a8d77f269f7589d789a771bdfd20e91a3cf6f50382a98d7");
                assert_eq!(lnurl_pay_data.max_sendable, 16000);
                assert_eq!(lnurl_pay_data.min_sendable, 4000);
                assert_eq!(lnurl_pay_data.comment_allowed, 0);
                assert_eq!(lnurl_pay_data.tag, "payRequest");

                let meta = lnurl_pay_data.metadata;
                assert_eq!(meta.len(), 3);
                assert_eq!(meta.get(0).ok_or("Key not found")?.key, "text/plain");
                assert_eq!(meta.get(0).ok_or("Key not found")?.value, "WRhtV");
                assert_eq!(meta.get(1).ok_or("Key not found")?.key, "text/long-desc");
                assert_eq!(meta.get(1).ok_or("Key not found")?.value, "MBTrTiLCFS");
                assert_eq!(meta.get(2).ok_or("Key not found")?.key, "image/png;base64");
            }
            _ => return Err(anyhow!("Unexpected type"))?,
        }

        Ok(())
    }
}
