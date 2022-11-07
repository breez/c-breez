use crate::crypto::encrypt;
use crate::grpc::{
    self, LspListRequest, PaymentInformation, RegisterPaymentReply, RegisterPaymentRequest,
};
use crate::models::LspAPI;
use crate::node_service::BreezServer;
use anyhow::Result;
use prost::Message;
use tonic::Request;

pub struct LspInformation {
    id: Option<String>,
    name: String,
    widget_url: String,
    pubkey: String,
    host: String,
    channel_capacity: i64,
    target_conf: i32,
    base_fee_msat: i64,
    fee_rate: f64,
    time_lock_delate: u32,
    min_htlc_msat: i64,
    channel_fee_permyriad: i64,
    lsp_pubkey: Vec<u8>,
    max_inactive_duration: i64,
    channel_minimum_fee_msat: i64,
}

impl From<grpc::LspInformation> for LspInformation {
    fn from(lsp_info: grpc::LspInformation) -> Self {
        LspInformation {
            id: None,
            name: lsp_info.name,
            widget_url: lsp_info.widget_url,
            pubkey: lsp_info.pubkey,
            host: lsp_info.host,
            channel_capacity: lsp_info.channel_capacity,
            target_conf: lsp_info.target_conf,
            base_fee_msat: lsp_info.base_fee_msat,
            fee_rate: lsp_info.fee_rate,
            time_lock_delate: lsp_info.time_lock_delta,
            min_htlc_msat: lsp_info.min_htlc_msat,
            channel_fee_permyriad: lsp_info.channel_fee_permyriad,
            lsp_pubkey: lsp_info.lsp_pubkey,
            max_inactive_duration: lsp_info.max_inactive_duration,
            channel_minimum_fee_msat: lsp_info.channel_minimum_fee_msat,
        }
    }
}
trait AddID {
    fn add_id(lsp_id: String, lsp_info: LspInformation) -> LspInformation;
}

impl AddID for LspInformation {
    fn add_id(lsp_id: String, mut lsp_info: LspInformation) -> LspInformation {
        lsp_info.id = Some(lsp_id);
        lsp_info
    }
}

#[tonic::async_trait]
impl LspAPI for BreezServer {
    async fn list_lsps(&self, pubkey: String) -> Result<Vec<LspInformation>> {
        let mut client = self.get_channel_opener_client().await?;

        let request = Request::new(LspListRequest { pubkey });
        let response = client.lsp_list(request).await?;
        let mut lsp_list: Vec<LspInformation> = Vec::new();
        for (key, value) in response.into_inner().lsps.into_iter() {
            lsp_list.push(LspInformation::add_id(key, LspInformation::from(value)));
        }
        Ok(lsp_list)
    }

    async fn register_payment(
        &mut self,
        lsp: &grpc::LspInformation,
        payment_info: PaymentInformation,
    ) -> Result<RegisterPaymentReply> {
        let mut client = self.get_channel_opener_client().await?;

        let mut buf = Vec::new();
        buf.reserve(payment_info.encoded_len());
        payment_info.encode(&mut buf)?;

        let request = Request::new(RegisterPaymentRequest {
            lsp_id: lsp.name.clone(),
            blob: encrypt(lsp.lsp_pubkey.clone(), buf)?,
        });
        let response = client.register_payment(request).await?;

        Ok(response.into_inner())
    }
}
