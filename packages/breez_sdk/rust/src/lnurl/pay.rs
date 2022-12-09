use crate::invoice::parse_invoice;
use crate::lnurl::input_parser::LnUrlPayRequestData;
use crate::lnurl::maybe_replace_host_with_mockito_test_host;
use crate::lnurl::pay::model::{CallbackResponse, ValidatedCallbackResponse};
use crate::lnurl::LnUrlErrorData;
use anyhow::{anyhow, Result};
use bitcoin_hashes::{Hash, sha256};
use lightning_invoice::{Sha256};
use serde_json::json;
use std::str::FromStr;

pub(crate) async fn validate_lnurl_pay(
    user_amount_sat: u64,
    comment: Option<String>,
    req_data: LnUrlPayRequestData,
) -> Result<ValidatedCallbackResponse> {
    validate_user_input(user_amount_sat, comment, req_data.clone())?;

    let callback_url = build_callback_url(&req_data, user_amount_sat)?;
    let callback_resp_text = reqwest::get(&callback_url).await?.text().await?;

    if let Ok(err) = serde_json::from_str::<LnUrlErrorData>(&callback_resp_text) {
        Ok(ValidatedCallbackResponse::EndpointError(err))
    } else {
        let callback_resp: CallbackResponse = reqwest::get(&callback_url).await?.json().await?;
        if let Some(ref sa) = callback_resp.success_action {
            sa.validate(&req_data)?;
        }

        validate_invoice(user_amount_sat, &callback_resp.pr, &req_data)?;
        Ok(ValidatedCallbackResponse::EndpointSuccess(callback_resp))
    }
}

fn build_callback_url(req_data: &LnUrlPayRequestData, user_amount_sat: u64) -> Result<String> {
    // TODO add comments arg

    let amount_msat = (user_amount_sat * 1000).to_string();
    let mut callback_url = reqwest::Url::from_str(&req_data.callback)?
        .query_pairs_mut()
        .append_pair("amount", &amount_msat)
        .finish()
        .to_string();

    callback_url = maybe_replace_host_with_mockito_test_host(callback_url)?;
    Ok(callback_url)
}

fn validate_user_input(
    user_amount_sat: u64,
    comment: Option<String>,
    req_data: LnUrlPayRequestData,
) -> Result<()> {
    if user_amount_sat < req_data.min_sendable {
        return Err(anyhow!("Amount is smaller than the minimum allowed"));
    }

    if user_amount_sat > req_data.max_sendable {
        return Err(anyhow!("Amount is bigger than the maximum allowed"));
    }

    match comment {
        None => Ok(()),
        Some(msg) => match msg.len() <= req_data.comment_allowed {
            true => Ok(()),
            false => Err(anyhow!(
                "Comment is longer than the maximum allowed comment length"
            )),
        },
    }
}

fn validate_invoice(
    user_amount_sat: u64,
    bolt11: &str,
    req_data: &LnUrlPayRequestData,
) -> Result<()> {
    let invoice = parse_invoice(bolt11)?;

    match invoice.description_hash {
        None => return Err(anyhow!("Invoice is missing description hash")),
        Some(received_hash) => {
            let metadata_str: String = json!(req_data.metadata).to_string();
            let calculated_hash: Sha256 =
                lightning_invoice::Sha256(sha256::Hash::hash(metadata_str.as_bytes()));

            if received_hash != calculated_hash.0.to_string() {
                return Err(anyhow!("Invoice has an invalid description hash"));
            }
        }
    }

    match invoice.amount_msat {
        None => Err(anyhow!("Amount is bigger than the maximum allowed")),
        Some(invoice_amount_msat) => match invoice_amount_msat == (user_amount_sat * 1000) {
            true => Ok(()),
            false => Err(anyhow!(
                "Invoice amount is different than the user chosen amount"
            )),
        },
    }
}

pub(crate) mod model {
    use crate::lnurl::input_parser::LnUrlPayRequestData;
    use crate::lnurl::LnUrlErrorData;

    use anyhow::{anyhow, Result};
    use serde::Deserialize;
    use serde_with::serde_as;

    pub(crate) enum ValidatedCallbackResponse {
        EndpointSuccess(CallbackResponse),
        EndpointError(LnUrlErrorData),
    }

    pub enum Resp {
        EndpointSuccess(Option<SuccessAction>),
        EndpointError(LnUrlErrorData),
    }

    #[serde_as]
    #[derive(Deserialize, Debug)]
    #[serde(rename_all = "camelCase")]
    pub struct CallbackResponse {
        pub pr: String,
        pub success_action: Option<SuccessAction>,
    }

    #[derive(Deserialize, Debug)]
    pub struct MessageSuccessActionData {
        pub message: String,
    }

    #[derive(Deserialize, Debug)]
    pub struct UrlSuccessActionData {
        pub description: String,
        pub url: String,
    }

    #[serde_as]
    #[derive(Deserialize, Debug)]
    #[serde(rename_all = "camelCase")]
    #[serde(tag = "tag")]
    pub enum SuccessAction {
        // Any other successAction type is considered not supported, so the parsing would fail
        // and abort payment, as per LUD-09
        Message(MessageSuccessActionData),
        Url(UrlSuccessActionData),
    }

    impl SuccessAction {
        pub fn validate(&self, req_data: &LnUrlPayRequestData) -> Result<()> {
            match self {
                SuccessAction::Message(msg_action_data) => {
                    match msg_action_data.message.len() <= 144 {
                        true => Ok(()),
                        false => Err(anyhow!(
                            "Success action message is longer than the maximum allowed length"
                        )),
                    }
                }

                SuccessAction::Url(url_action_data) => {
                    match url_action_data.description.len() <= 144 {
                        true => Ok(()),
                        false => Err(anyhow!(
                            "Success action description is longer than the maximum allowed length"
                        )),
                    }
                    .and_then(|_| {
                        let req_url = reqwest::Url::parse(&req_data.callback)?;
                        let req_domain = req_url
                            .domain()
                            .ok_or_else(|| anyhow!("Could not determine callback domain"))?;

                        let action_res_url = reqwest::Url::parse(&url_action_data.url)?;
                        let action_res_domain = action_res_url.domain().ok_or_else(|| {
                            anyhow!("Could not determine Success Action URL domain")
                        })?;

                        match req_domain == action_res_domain {
                            true => Ok(()),
                            false => Err(anyhow!(
                        "Success action description is longer than the maximum allowed length"
                    )),
                        }
                    })
                }
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use crate::lnurl::input_parser::*;
    use crate::lnurl::pay::model::{
        MessageSuccessActionData, Resp, SuccessAction, UrlSuccessActionData,
    };
    use crate::lnurl::pay::*;
    use anyhow::{anyhow, Result};
    use mockito;
    use mockito::Mock;

    use crate::test_utils::{rand_invoice_with_description_hash, rand_string};

    /// Mock an LNURL-pay endpoint that responds with no Success Action
    fn mock_lnurl_pay_callback_endpoint_no_success_action(
        pay_req: &LnUrlPayRequestData,
        user_amount_sat: u64,
        error: Option<String>,
        pr: String,
    ) -> Result<Mock> {
        let callback_url = build_callback_url(pay_req, user_amount_sat)?;
        let url = reqwest::Url::parse(&callback_url)?;
        let mockito_path: &str = &format!("{}?{}", url.path(), url.query().unwrap());

        let expected_payload = r#"
{
    "pr":"token-invoice",
    "routes":[]
}
        "#
        .replace('\n', "")
        .replace("token-invoice", &pr);

        let response_body = match error {
            None => expected_payload,
            Some(err_reason) => {
                ["{\"status\": \"ERROR\", \"reason\": \"", &err_reason, "\"}"].join("")
            }
        };
        Ok(mockito::mock("GET", mockito_path)
            .with_body(response_body)
            .create())
    }

    /// Mock an LNURL-pay endpoint that responds with an unsupported Success Action
    fn mock_lnurl_pay_callback_endpoint_unsupported_success_action(
        pay_req: &LnUrlPayRequestData,
        user_amount_sat: u64,
        error: Option<String>,
    ) -> Result<Mock> {
        let callback_url = build_callback_url(pay_req, user_amount_sat)?;
        let url = reqwest::Url::parse(&callback_url)?;
        let mockito_path: &str = &format!("{}?{}", url.path(), url.query().unwrap());

        let expected_payload = r#"
{
    "pr":"lnbc110n1p38q3gtpp5ypz09jrd8p993snjwnm68cph4ftwp22le34xd4r8ftspwshxhmnsdqqxqyjw5qcqpxsp5htlg8ydpywvsa7h3u4hdn77ehs4z4e844em0apjyvmqfkzqhhd2q9qgsqqqyssqszpxzxt9uuqzymr7zxcdccj5g69s8q7zzjs7sgxn9ejhnvdh6gqjcy22mss2yexunagm5r2gqczh8k24cwrqml3njskm548aruhpwssq9nvrvz",
    "routes":[],
    "successAction": {
        "tag":"random-type-that-is-not-supported",
        "message":"test msg"
    }
}
        "#.replace('\n', "");

        let response_body = match error {
            None => expected_payload,
            Some(err_reason) => {
                ["{\"status\": \"ERROR\", \"reason\": \"", &err_reason, "\"}"].join("")
            }
        };
        Ok(mockito::mock("GET", mockito_path)
            .with_body(response_body)
            .create())
    }

    /// Mock an LNURL-pay endpoint that responds with a Success Action of type message
    fn mock_lnurl_pay_callback_endpoint_msg_success_action(
        pay_req: &LnUrlPayRequestData,
        user_amount_sat: u64,
        error: Option<String>,
        pr: String,
    ) -> Result<Mock> {
        let callback_url = build_callback_url(pay_req, user_amount_sat)?;
        let url = reqwest::Url::parse(&callback_url)?;
        let mockito_path: &str = &format!("{}?{}", url.path(), url.query().unwrap());

        let expected_payload = r#"
{
    "pr":"token-invoice",
    "routes":[],
    "successAction": {
        "tag":"message",
        "message":"test msg"
    }
}
        "#
        .replace('\n', "")
        .replace("token-invoice", &pr);

        let response_body = match error {
            None => expected_payload,
            Some(err_reason) => {
                ["{\"status\": \"ERROR\", \"reason\": \"", &err_reason, "\"}"].join("")
            }
        };
        Ok(mockito::mock("GET", mockito_path)
            .with_body(response_body)
            .create())
    }

    /// Mock an LNURL-pay endpoint that responds with a Success Action of type URL
    fn mock_lnurl_pay_callback_endpoint_url_success_action(
        pay_req: &LnUrlPayRequestData,
        user_amount_sat: u64,
        error: Option<String>,
        pr: String,
    ) -> Result<Mock> {
        let callback_url = build_callback_url(pay_req, user_amount_sat)?;
        let url = reqwest::Url::parse(&callback_url)?;
        let mockito_path: &str = &format!("{}?{}", url.path(), url.query().unwrap());

        let expected_payload = r#"
{
    "pr":"token-invoice",
    "routes":[],
    "successAction": {
        "tag":"url",
        "description":"test description",
        "url":"https://localhost/test-url"
    }
}
        "#
        .replace('\n', "")
        .replace("token-invoice", &pr);

        let response_body = match error {
            None => expected_payload,
            Some(err_reason) => {
                ["{\"status\": \"ERROR\", \"reason\": \"", &err_reason, "\"}"].join("")
            }
        };
        Ok(mockito::mock("GET", mockito_path)
            .with_body(response_body)
            .create())
    }

    fn get_test_pay_req_data(min: u64, max: u64, comment_len: usize) -> LnUrlPayRequestData {
        LnUrlPayRequestData {
            min_sendable: min,
            max_sendable: max,
            comment_allowed: comment_len,
            metadata: vec![],
            callback: "https://localhost/callback".into(),
        }
    }

    #[test]
    fn test_lnurl_pay_validate_input() -> Result<()> {
        assert!(validate_user_input(100, None, get_test_pay_req_data(0, 100, 0)).is_ok());
        assert!(
            validate_user_input(100, Some("test".into()), get_test_pay_req_data(0, 100, 5)).is_ok()
        );

        assert!(validate_user_input(5, None, get_test_pay_req_data(10, 100, 5)).is_err());
        assert!(validate_user_input(200, None, get_test_pay_req_data(10, 100, 5)).is_err());
        assert!(
            validate_user_input(100, Some("test".into()), get_test_pay_req_data(10, 100, 0))
                .is_err()
        );

        Ok(())
    }

    #[test]
    fn test_lnurl_pay_validate_invoice() -> Result<()> {
        let req = get_test_pay_req_data(0, 100, 0);
        let temp_desc = json!(req.metadata).to_string();
        let inv = rand_invoice_with_description_hash(temp_desc.clone());
        let payreq: String = rand_invoice_with_description_hash(temp_desc).to_string();

        assert!(
            validate_invoice(inv.amount_milli_satoshis().unwrap() / 1000, &payreq, &req).is_ok()
        );
        assert!(validate_invoice(
            (inv.amount_milli_satoshis().unwrap() / 1000) + 1,
            &payreq,
            &req
        )
        .is_err());

        Ok(())
    }

    #[test]
    fn test_lnurl_pay_validate_success_action_msg() -> Result<()> {
        let pay_req_data = get_test_pay_req_data(0, 100, 100);

        assert!(SuccessAction::Message(MessageSuccessActionData {
            message: "short msg".into()
        })
        .validate(&pay_req_data)
        .is_ok());

        // Too long message
        assert!(SuccessAction::Message(MessageSuccessActionData {
            message: rand_string(150)
        })
        .validate(&pay_req_data)
        .is_err());

        Ok(())
    }

    #[test]
    fn test_lnurl_pay_validate_success_url() -> Result<()> {
        let pay_req_data = get_test_pay_req_data(0, 100, 100);

        assert!(SuccessAction::Url(UrlSuccessActionData {
            description: "short msg".into(),
            url: pay_req_data.clone().callback
        })
        .validate(&pay_req_data)
        .is_ok());

        // Too long description
        assert!(SuccessAction::Url(UrlSuccessActionData {
            description: rand_string(150),
            url: pay_req_data.clone().callback
        })
        .validate(&pay_req_data)
        .is_err());

        // Different Success Action domain than in the callback URL
        assert!(SuccessAction::Url(UrlSuccessActionData {
            description: "short msg".into(),
            url: "https://new-domain.com/test-url".into()
        })
        .validate(&pay_req_data)
        .is_err());

        Ok(())
    }

    #[tokio::test]
    async fn test_lnurl_pay_no_success_action() -> Result<()> {
        let pay_req = get_test_pay_req_data(0, 100, 0);
        let temp_desc = json!(pay_req.metadata).to_string();
        let inv = rand_invoice_with_description_hash(temp_desc);
        let user_amount_sat = inv.amount_milli_satoshis().unwrap() / 1000;
        let _m = mock_lnurl_pay_callback_endpoint_no_success_action(
            &pay_req,
            user_amount_sat,
            None,
            inv.to_string(),
        )?;

        let mock_breez_services = crate::breez_services::test::breez_services().await;
        match mock_breez_services
            .pay_lnurl(user_amount_sat, None, pay_req)
            .await?
        {
            Resp::EndpointSuccess(None) => Ok(()),
            Resp::EndpointSuccess(Some(_)) => Err(anyhow!("Unexpected success action")),
            _ => Err(anyhow!("Unexpected success action type")),
        }
    }

    #[tokio::test]
    async fn test_lnurl_pay_unsupported_success_action() -> Result<()> {
        let user_amount_sat = 11;
        let pay_req = get_test_pay_req_data(0, 100, 0);
        let _m = mock_lnurl_pay_callback_endpoint_unsupported_success_action(
            &pay_req,
            user_amount_sat,
            None,
        )?;

        let mock_breez_services = crate::breez_services::test::breez_services().await;
        let r = mock_breez_services
            .pay_lnurl(user_amount_sat, None, pay_req)
            .await;
        // An unsupported Success Action results in an error
        assert!(r.is_err());

        Ok(())
    }

    #[tokio::test]
    async fn test_lnurl_pay_msg_success_action() -> Result<()> {
        let pay_req = get_test_pay_req_data(0, 100, 0);
        let temp_desc = json!(pay_req.metadata).to_string();
        let inv = rand_invoice_with_description_hash(temp_desc);
        let user_amount_sat = inv.amount_milli_satoshis().unwrap() / 1000;
        let _m = mock_lnurl_pay_callback_endpoint_msg_success_action(
            &pay_req,
            user_amount_sat,
            None,
            inv.to_string(),
        )?;

        let mock_breez_services = crate::breez_services::test::breez_services().await;
        match mock_breez_services
            .pay_lnurl(user_amount_sat, None, pay_req)
            .await?
        {
            Resp::EndpointSuccess(None) => Err(anyhow!(
                "Expected success action in callback, but none provided"
            )),
            Resp::EndpointSuccess(Some(SuccessAction::Message(msg))) => match msg.message {
                s if s == "test msg" => Ok(()),
                _ => Err(anyhow!("Unexpected success action message content")),
            },
            _ => Err(anyhow!("Unexpected success action type")),
        }
    }

    #[tokio::test]
    async fn test_lnurl_pay_msg_success_action_incorrect_amount() -> Result<()> {
        let pay_req = get_test_pay_req_data(0, 100, 0);
        let temp_desc = json!(pay_req.metadata).to_string();
        let inv = rand_invoice_with_description_hash(temp_desc);
        let user_amount_sat = (inv.amount_milli_satoshis().unwrap() / 1000) + 1;
        let _m = mock_lnurl_pay_callback_endpoint_msg_success_action(
            &pay_req,
            user_amount_sat,
            None,
            inv.to_string(),
        )?;

        let mock_breez_services = crate::breez_services::test::breez_services().await;
        assert!(mock_breez_services
            .pay_lnurl(user_amount_sat, None, pay_req)
            .await
            .is_err());

        Ok(())
    }

    #[tokio::test]
    async fn test_lnurl_pay_msg_success_action_error_from_endpoint() -> Result<()> {
        let pay_req = get_test_pay_req_data(0, 100, 0);
        let temp_desc = json!(pay_req.metadata).to_string();
        let inv = rand_invoice_with_description_hash(temp_desc);
        let user_amount_sat = inv.amount_milli_satoshis().unwrap() / 1000;
        let expected_error_msg = "Error message from LNURL endpoint";
        let _m = mock_lnurl_pay_callback_endpoint_msg_success_action(
            &pay_req,
            user_amount_sat,
            Some(expected_error_msg.to_string()),
            inv.to_string(),
        )?;

        let mock_breez_services = crate::breez_services::test::breez_services().await;
        let res = mock_breez_services
            .pay_lnurl(user_amount_sat, None, pay_req)
            .await;
        assert!(matches!(res, Ok(Resp::EndpointError(_))));

        if let Ok(Resp::EndpointError(err_msg)) = res {
            assert_eq!(expected_error_msg, err_msg.reason);
        } else {
            return Err(anyhow!(
                "Expected error type but received another Success Action type"
            ));
        }

        Ok(())
    }

    #[tokio::test]
    async fn test_lnurl_pay_url_success_action() -> Result<()> {
        let pay_req = get_test_pay_req_data(0, 100, 0);
        let temp_desc = json!(pay_req.metadata).to_string();
        let inv = rand_invoice_with_description_hash(temp_desc);
        let user_amount_sat = inv.amount_milli_satoshis().unwrap() / 1000;
        let _m = mock_lnurl_pay_callback_endpoint_url_success_action(
            &pay_req,
            user_amount_sat,
            None,
            inv.to_string(),
        )?;

        let mock_breez_services = crate::breez_services::test::breez_services().await;
        match mock_breez_services
            .pay_lnurl(user_amount_sat, None, pay_req)
            .await?
        {
            Resp::EndpointSuccess(Some(SuccessAction::Url(url))) => {
                if url.url == "https://localhost/test-url" && url.description == "test description"
                {
                    Ok(())
                } else {
                    Err(anyhow!("Unexpected success action content"))
                }
            }
            Resp::EndpointSuccess(None) => Err(anyhow!(
                "Expected success action in callback, but none provided"
            )),
            _ => Err(anyhow!("Unexpected success action type")),
        }
    }
}
