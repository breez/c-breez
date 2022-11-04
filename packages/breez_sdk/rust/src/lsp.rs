use std::collections::HashMap;

use crate::crypto::encrypt;
use crate::grpc::{
    LspInformation, LspListRequest, PaymentInformation, RegisterPaymentReply,
    RegisterPaymentRequest,
};
use crate::models::LspAPI;
use crate::node_service::BreezLSP;
use anyhow::Result;
use prost::Message;
use tonic::Request;

#[tonic::async_trait]
impl LspAPI for BreezLSP {
    async fn list_lsps(&self, pubkey: String) -> Result<HashMap<String, LspInformation>> {
        let mut client = self.get_channel_opener_client().await?;

        let request = Request::new(LspListRequest { pubkey });
        let response = client.lsp_list(request).await?;
        Ok(response.into_inner().lsps)
    }

    async fn register_payment(
        &mut self,
        lsp: &LspInformation,
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
