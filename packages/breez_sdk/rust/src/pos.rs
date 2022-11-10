use crate::grpc::{RegisterRequest, UploadFileRequest};
use crate::models::PosAPI;
use crate::node_service::BreezServer;
use anyhow::Result;
use tonic::Request;

#[tonic::async_trait]
impl PosAPI for BreezServer {
    async fn register_device(&self, device_id: String, lightning_id: String) -> Result<String> {
        let mut client = self.get_pos_client().await?;

        let request = Request::new(RegisterRequest {
            device_id,
            lightning_id,
        });
        let response = client.register_device(request).await?;
        Ok(response.into_inner().breez_id)
    }

    async fn upload_logo(&self, content: Vec<u8>) -> Result<String> {
        let mut client = self.get_pos_client().await?;

        let request = Request::new(UploadFileRequest { content });
        let response = client.upload_logo(request).await?;
        Ok(response.into_inner().url)
    }
}
