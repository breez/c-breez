#[derive(Clone, PartialEq, ::prost::Message)]
pub struct SignUrlRequest {
    #[prost(string, tag="1")]
    pub base_url: ::prost::alloc::string::String,
    #[prost(string, tag="2")]
    pub query_string: ::prost::alloc::string::String,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct SignUrlResponse {
    #[prost(string, tag="1")]
    pub full_url: ::prost::alloc::string::String,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct InactiveNotifyRequest {
    #[prost(bytes="vec", tag="1")]
    pub pubkey: ::prost::alloc::vec::Vec<u8>,
    #[prost(int32, tag="2")]
    pub days: i32,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct InactiveNotifyResponse {
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct ReceiverInfoRequest {
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct ReceiverInfoReply {
    #[prost(string, tag="1")]
    pub pubkey: ::prost::alloc::string::String,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct RatesRequest {
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct Rate {
    #[prost(string, tag="1")]
    pub coin: ::prost::alloc::string::String,
    #[prost(double, tag="2")]
    pub value: f64,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct RatesReply {
    #[prost(message, repeated, tag="1")]
    pub rates: ::prost::alloc::vec::Vec<Rate>,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct LspListRequest {
    /// / The identity pubkey of the client
    #[prost(string, tag="2")]
    pub pubkey: ::prost::alloc::string::String,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct LspInformation {
    /// / The name of of lsp
    #[prost(string, tag="1")]
    pub name: ::prost::alloc::string::String,
    /// / The name of of lsp
    #[prost(string, tag="2")]
    pub widget_url: ::prost::alloc::string::String,
    /// / The identity pubkey of the Lightning node
    #[prost(string, tag="3")]
    pub pubkey: ::prost::alloc::string::String,
    /// / The network location of the lightning node, e.g. `12.34.56.78:9012` or `localhost:10011`
    #[prost(string, tag="4")]
    pub host: ::prost::alloc::string::String,
    /// / The channel capacity in satoshis
    #[prost(int64, tag="5")]
    pub channel_capacity: i64,
    /// / The target number of blocks that the funding transaction should be confirmed by.
    #[prost(int32, tag="6")]
    pub target_conf: i32,
    /// / The base fee charged regardless of the number of milli-satoshis sent.
    #[prost(int64, tag="7")]
    pub base_fee_msat: i64,
    /// / The effective fee rate in milli-satoshis. The precision of this value goes up to 6 decimal places, so 1e-6.
    #[prost(double, tag="8")]
    pub fee_rate: f64,
    /// / The required timelock delta for HTLCs forwarded over the channel.
    #[prost(uint32, tag="9")]
    pub time_lock_delta: u32,
    /// / The minimum value in millisatoshi we will require for incoming HTLCs on the channel.
    #[prost(int64, tag="10")]
    pub min_htlc_msat: i64,
    #[prost(int64, tag="11")]
    pub channel_fee_permyriad: i64,
    #[prost(bytes="vec", tag="12")]
    pub lsp_pubkey: ::prost::alloc::vec::Vec<u8>,
    /// The channel can be closed if not used this duration in seconds.
    #[prost(int64, tag="13")]
    pub max_inactive_duration: i64,
    #[prost(int64, tag="14")]
    pub channel_minimum_fee_msat: i64,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct LspListReply {
    /// The key is the lsp id
    #[prost(map="string, message", tag="1")]
    pub lsps: ::std::collections::HashMap<::prost::alloc::string::String, LspInformation>,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct RegisterPaymentRequest {
    #[prost(string, tag="1")]
    pub lsp_id: ::prost::alloc::string::String,
    #[prost(bytes="vec", tag="3")]
    pub blob: ::prost::alloc::vec::Vec<u8>,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct RegisterPaymentReply {
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct CheckChannelsRequest {
    #[prost(string, tag="1")]
    pub lsp_id: ::prost::alloc::string::String,
    #[prost(bytes="vec", tag="2")]
    pub blob: ::prost::alloc::vec::Vec<u8>,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct CheckChannelsReply {
    #[prost(bytes="vec", tag="2")]
    pub blob: ::prost::alloc::vec::Vec<u8>,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct OpenLspChannelRequest {
    #[prost(string, tag="1")]
    pub lsp_id: ::prost::alloc::string::String,
    #[prost(string, tag="2")]
    pub pubkey: ::prost::alloc::string::String,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct OpenLspChannelReply {
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct OpenChannelRequest {
    #[prost(string, tag="1")]
    pub pub_key: ::prost::alloc::string::String,
    #[prost(string, tag="2")]
    pub notification_token: ::prost::alloc::string::String,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct OpenChannelReply {
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct OpenPublicChannelRequest {
    #[prost(string, tag="1")]
    pub pubkey: ::prost::alloc::string::String,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct OpenPublicChannelReply {
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct Captcha {
    #[prost(string, tag="1")]
    pub id: ::prost::alloc::string::String,
    #[prost(bytes="vec", tag="2")]
    pub image: ::prost::alloc::vec::Vec<u8>,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct UpdateChannelPolicyRequest {
    #[prost(string, tag="1")]
    pub pub_key: ::prost::alloc::string::String,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct UpdateChannelPolicyReply {
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct AddFundInitRequest {
    #[prost(string, tag="1")]
    pub node_id: ::prost::alloc::string::String,
    #[prost(string, tag="2")]
    pub notification_token: ::prost::alloc::string::String,
    #[prost(bytes="vec", tag="3")]
    pub pubkey: ::prost::alloc::vec::Vec<u8>,
    #[prost(bytes="vec", tag="4")]
    pub hash: ::prost::alloc::vec::Vec<u8>,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct AddFundInitReply {
    #[prost(string, tag="1")]
    pub address: ::prost::alloc::string::String,
    #[prost(bytes="vec", tag="2")]
    pub pubkey: ::prost::alloc::vec::Vec<u8>,
    #[prost(int64, tag="3")]
    pub lock_height: i64,
    #[prost(int64, tag="4")]
    pub max_allowed_deposit: i64,
    #[prost(string, tag="5")]
    pub error_message: ::prost::alloc::string::String,
    #[prost(int64, tag="6")]
    pub required_reserve: i64,
    #[prost(int64, tag="7")]
    pub min_allowed_deposit: i64,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct AddFundStatusRequest {
    #[prost(string, repeated, tag="1")]
    pub addresses: ::prost::alloc::vec::Vec<::prost::alloc::string::String>,
    #[prost(string, tag="2")]
    pub notification_token: ::prost::alloc::string::String,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct AddFundStatusReply {
    #[prost(map="string, message", tag="1")]
    pub statuses: ::std::collections::HashMap<::prost::alloc::string::String, add_fund_status_reply::AddressStatus>,
}
/// Nested message and enum types in `AddFundStatusReply`.
pub mod add_fund_status_reply {
    #[derive(Clone, PartialEq, ::prost::Message)]
    pub struct AddressStatus {
        #[prost(string, tag="1")]
        pub tx: ::prost::alloc::string::String,
        #[prost(int64, tag="2")]
        pub amount: i64,
        #[prost(bool, tag="3")]
        pub confirmed: bool,
        #[prost(string, tag="4")]
        pub block_hash: ::prost::alloc::string::String,
    }
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct RemoveFundRequest {
    #[prost(string, tag="1")]
    pub address: ::prost::alloc::string::String,
    #[prost(int64, tag="2")]
    pub amount: i64,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct RemoveFundReply {
    #[prost(string, tag="1")]
    pub payment_request: ::prost::alloc::string::String,
    #[prost(string, tag="2")]
    pub error_message: ::prost::alloc::string::String,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct RedeemRemovedFundsRequest {
    #[prost(string, tag="1")]
    pub paymenthash: ::prost::alloc::string::String,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct RedeemRemovedFundsReply {
    #[prost(string, tag="1")]
    pub txid: ::prost::alloc::string::String,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct GetSwapPaymentRequest {
    #[prost(string, tag="1")]
    pub payment_request: ::prost::alloc::string::String,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct GetSwapPaymentReply {
    #[prost(string, tag="1")]
    pub payment_error: ::prost::alloc::string::String,
    /// deprecated
    #[prost(bool, tag="2")]
    pub funds_exceeded_limit: bool,
    #[prost(enumeration="get_swap_payment_reply::SwapError", tag="3")]
    pub swap_error: i32,
}
/// Nested message and enum types in `GetSwapPaymentReply`.
pub mod get_swap_payment_reply {
    #[derive(Clone, Copy, Debug, PartialEq, Eq, Hash, PartialOrd, Ord, ::prost::Enumeration)]
    #[repr(i32)]
    pub enum SwapError {
        NoError = 0,
        FundsExceedLimit = 1,
        TxTooSmall = 2,
        InvoiceAmountMismatch = 3,
        SwapExpired = 4,
    }
    impl SwapError {
        /// String value of the enum field names used in the ProtoBuf definition.
        ///
        /// The values are not transformed in any way and thus are considered stable
        /// (if the ProtoBuf definition does not change) and safe for programmatic use.
        pub fn as_str_name(&self) -> &'static str {
            match self {
                SwapError::NoError => "NO_ERROR",
                SwapError::FundsExceedLimit => "FUNDS_EXCEED_LIMIT",
                SwapError::TxTooSmall => "TX_TOO_SMALL",
                SwapError::InvoiceAmountMismatch => "INVOICE_AMOUNT_MISMATCH",
                SwapError::SwapExpired => "SWAP_EXPIRED",
            }
        }
    }
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct RedeemSwapPaymentRequest {
    #[prost(bytes="vec", tag="1")]
    pub preimage: ::prost::alloc::vec::Vec<u8>,
    /// / The target number of blocks that the funding transaction should be confirmed by.
    #[prost(int32, tag="2")]
    pub target_conf: i32,
    /// / A manual fee rate set in sat/byte that should be used when crafting the funding transaction.
    #[prost(int64, tag="3")]
    pub sat_per_byte: i64,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct RedeemSwapPaymentReply {
    #[prost(string, tag="1")]
    pub txid: ::prost::alloc::string::String,
}
/// The request message containing the device id and lightning id
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct RegisterRequest {
    #[prost(string, tag="1")]
    pub device_id: ::prost::alloc::string::String,
    #[prost(string, tag="2")]
    pub lightning_id: ::prost::alloc::string::String,
}
/// The response message containing the breez id
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct RegisterReply {
    #[prost(string, tag="1")]
    pub breez_id: ::prost::alloc::string::String,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct PaymentRequest {
    #[prost(string, tag="1")]
    pub breez_id: ::prost::alloc::string::String,
    #[prost(string, tag="2")]
    pub invoice: ::prost::alloc::string::String,
    #[prost(string, tag="3")]
    pub payee: ::prost::alloc::string::String,
    #[prost(int64, tag="4")]
    pub amount: i64,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct InvoiceReply {
    #[prost(string, tag="1")]
    pub error: ::prost::alloc::string::String,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct UploadFileRequest {
    #[prost(bytes="vec", tag="1")]
    pub content: ::prost::alloc::vec::Vec<u8>,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct UploadFileReply {
    #[prost(string, tag="1")]
    pub url: ::prost::alloc::string::String,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct PingRequest {
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct PingReply {
    #[prost(string, tag="1")]
    pub version: ::prost::alloc::string::String,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct OrderRequest {
    #[prost(string, tag="1")]
    pub full_name: ::prost::alloc::string::String,
    #[prost(string, tag="2")]
    pub address: ::prost::alloc::string::String,
    #[prost(string, tag="3")]
    pub city: ::prost::alloc::string::String,
    #[prost(string, tag="4")]
    pub state: ::prost::alloc::string::String,
    #[prost(string, tag="5")]
    pub zip: ::prost::alloc::string::String,
    #[prost(string, tag="6")]
    pub country: ::prost::alloc::string::String,
    #[prost(string, tag="7")]
    pub email: ::prost::alloc::string::String,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct OrderReply {
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct SetNodeInfoRequest {
    #[prost(bytes="vec", tag="1")]
    pub pubkey: ::prost::alloc::vec::Vec<u8>,
    #[prost(string, tag="2")]
    pub key: ::prost::alloc::string::String,
    #[prost(bytes="vec", tag="3")]
    pub value: ::prost::alloc::vec::Vec<u8>,
    #[prost(int64, tag="4")]
    pub timestamp: i64,
    #[prost(bytes="vec", tag="5")]
    pub signature: ::prost::alloc::vec::Vec<u8>,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct SetNodeInfoResponse {
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct GetNodeInfoRequest {
    #[prost(bytes="vec", tag="1")]
    pub pubkey: ::prost::alloc::vec::Vec<u8>,
    #[prost(string, tag="2")]
    pub key: ::prost::alloc::string::String,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct GetNodeInfoResponse {
    #[prost(bytes="vec", tag="1")]
    pub value: ::prost::alloc::vec::Vec<u8>,
    #[prost(int64, tag="2")]
    pub timestamp: i64,
    #[prost(bytes="vec", tag="3")]
    pub signature: ::prost::alloc::vec::Vec<u8>,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct JoinCtpSessionRequest {
    #[prost(enumeration="join_ctp_session_request::PartyType", tag="1")]
    pub party_type: i32,
    #[prost(string, tag="2")]
    pub party_name: ::prost::alloc::string::String,
    #[prost(string, tag="3")]
    pub notification_token: ::prost::alloc::string::String,
    #[prost(string, tag="4")]
    pub session_id: ::prost::alloc::string::String,
}
/// Nested message and enum types in `JoinCTPSessionRequest`.
pub mod join_ctp_session_request {
    #[derive(Clone, Copy, Debug, PartialEq, Eq, Hash, PartialOrd, Ord, ::prost::Enumeration)]
    #[repr(i32)]
    pub enum PartyType {
        Payer = 0,
        Payee = 1,
    }
    impl PartyType {
        /// String value of the enum field names used in the ProtoBuf definition.
        ///
        /// The values are not transformed in any way and thus are considered stable
        /// (if the ProtoBuf definition does not change) and safe for programmatic use.
        pub fn as_str_name(&self) -> &'static str {
            match self {
                PartyType::Payer => "PAYER",
                PartyType::Payee => "PAYEE",
            }
        }
    }
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct JoinCtpSessionResponse {
    #[prost(string, tag="1")]
    pub session_id: ::prost::alloc::string::String,
    #[prost(int64, tag="2")]
    pub expiry: i64,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct TerminateCtpSessionRequest {
    #[prost(string, tag="1")]
    pub session_id: ::prost::alloc::string::String,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct TerminateCtpSessionResponse {
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct RegisterTransactionConfirmationRequest {
    #[prost(string, tag="1")]
    pub tx_id: ::prost::alloc::string::String,
    #[prost(string, tag="2")]
    pub notification_token: ::prost::alloc::string::String,
    #[prost(enumeration="register_transaction_confirmation_request::NotificationType", tag="3")]
    pub notification_type: i32,
}
/// Nested message and enum types in `RegisterTransactionConfirmationRequest`.
pub mod register_transaction_confirmation_request {
    #[derive(Clone, Copy, Debug, PartialEq, Eq, Hash, PartialOrd, Ord, ::prost::Enumeration)]
    #[repr(i32)]
    pub enum NotificationType {
        ReadyReceivePayment = 0,
        ChannelOpened = 1,
    }
    impl NotificationType {
        /// String value of the enum field names used in the ProtoBuf definition.
        ///
        /// The values are not transformed in any way and thus are considered stable
        /// (if the ProtoBuf definition does not change) and safe for programmatic use.
        pub fn as_str_name(&self) -> &'static str {
            match self {
                NotificationType::ReadyReceivePayment => "READY_RECEIVE_PAYMENT",
                NotificationType::ChannelOpened => "CHANNEL_OPENED",
            }
        }
    }
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct RegisterTransactionConfirmationResponse {
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct RegisterPeriodicSyncRequest {
    #[prost(string, tag="1")]
    pub notification_token: ::prost::alloc::string::String,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct RegisterPeriodicSyncResponse {
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct BoltzReverseSwapLockupTx {
    #[prost(string, tag="1")]
    pub boltz_id: ::prost::alloc::string::String,
    #[prost(uint32, tag="2")]
    pub timeout_block_height: u32,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct PushTxNotificationRequest {
    #[prost(string, tag="1")]
    pub device_id: ::prost::alloc::string::String,
    #[prost(string, tag="2")]
    pub title: ::prost::alloc::string::String,
    #[prost(string, tag="3")]
    pub body: ::prost::alloc::string::String,
    #[prost(bytes="vec", tag="4")]
    pub tx_hash: ::prost::alloc::vec::Vec<u8>,
    #[prost(bytes="vec", tag="5")]
    pub script: ::prost::alloc::vec::Vec<u8>,
    #[prost(uint32, tag="6")]
    pub block_height_hint: u32,
    #[prost(oneof="push_tx_notification_request::Info", tags="7")]
    pub info: ::core::option::Option<push_tx_notification_request::Info>,
}
/// Nested message and enum types in `PushTxNotificationRequest`.
pub mod push_tx_notification_request {
    #[derive(Clone, PartialEq, ::prost::Oneof)]
    pub enum Info {
        #[prost(message, tag="7")]
        BoltzReverseSwapLockupTxInfo(super::BoltzReverseSwapLockupTx),
    }
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct PushTxNotificationResponse {
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct BreezAppVersionsRequest {
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct BreezAppVersionsReply {
    #[prost(string, repeated, tag="1")]
    pub version: ::prost::alloc::vec::Vec<::prost::alloc::string::String>,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct GetReverseRoutingNodeRequest {
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct GetReverseRoutingNodeReply {
    #[prost(bytes="vec", tag="1")]
    pub node_id: ::prost::alloc::vec::Vec<u8>,
}
/// Generated client implementations.
pub mod invoicer_client {
    #![allow(unused_variables, dead_code, missing_docs, clippy::let_unit_value)]
    use tonic::codegen::*;
    use tonic::codegen::http::Uri;
    #[derive(Debug, Clone)]
    pub struct InvoicerClient<T> {
        inner: tonic::client::Grpc<T>,
    }
    impl InvoicerClient<tonic::transport::Channel> {
        /// Attempt to create a new client by connecting to a given endpoint.
        pub async fn connect<D>(dst: D) -> Result<Self, tonic::transport::Error>
        where
            D: std::convert::TryInto<tonic::transport::Endpoint>,
            D::Error: Into<StdError>,
        {
            let conn = tonic::transport::Endpoint::new(dst)?.connect().await?;
            Ok(Self::new(conn))
        }
    }
    impl<T> InvoicerClient<T>
    where
        T: tonic::client::GrpcService<tonic::body::BoxBody>,
        T::Error: Into<StdError>,
        T::ResponseBody: Body<Data = Bytes> + Send + 'static,
        <T::ResponseBody as Body>::Error: Into<StdError> + Send,
    {
        pub fn new(inner: T) -> Self {
            let inner = tonic::client::Grpc::new(inner);
            Self { inner }
        }
        pub fn with_origin(inner: T, origin: Uri) -> Self {
            let inner = tonic::client::Grpc::with_origin(inner, origin);
            Self { inner }
        }
        pub fn with_interceptor<F>(
            inner: T,
            interceptor: F,
        ) -> InvoicerClient<InterceptedService<T, F>>
        where
            F: tonic::service::Interceptor,
            T::ResponseBody: Default,
            T: tonic::codegen::Service<
                http::Request<tonic::body::BoxBody>,
                Response = http::Response<
                    <T as tonic::client::GrpcService<tonic::body::BoxBody>>::ResponseBody,
                >,
            >,
            <T as tonic::codegen::Service<
                http::Request<tonic::body::BoxBody>,
            >>::Error: Into<StdError> + Send + Sync,
        {
            InvoicerClient::new(InterceptedService::new(inner, interceptor))
        }
        /// Compress requests with the given encoding.
        ///
        /// This requires the server to support it otherwise it might respond with an
        /// error.
        #[must_use]
        pub fn send_compressed(mut self, encoding: CompressionEncoding) -> Self {
            self.inner = self.inner.send_compressed(encoding);
            self
        }
        /// Enable decompressing responses.
        #[must_use]
        pub fn accept_compressed(mut self, encoding: CompressionEncoding) -> Self {
            self.inner = self.inner.accept_compressed(encoding);
            self
        }
        pub async fn register_device(
            &mut self,
            request: impl tonic::IntoRequest<super::RegisterRequest>,
        ) -> Result<tonic::Response<super::RegisterReply>, tonic::Status> {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static(
                "/breez.Invoicer/RegisterDevice",
            );
            self.inner.unary(request.into_request(), path, codec).await
        }
        pub async fn send_invoice(
            &mut self,
            request: impl tonic::IntoRequest<super::PaymentRequest>,
        ) -> Result<tonic::Response<super::InvoiceReply>, tonic::Status> {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static(
                "/breez.Invoicer/SendInvoice",
            );
            self.inner.unary(request.into_request(), path, codec).await
        }
    }
}
/// Generated client implementations.
pub mod card_orderer_client {
    #![allow(unused_variables, dead_code, missing_docs, clippy::let_unit_value)]
    use tonic::codegen::*;
    use tonic::codegen::http::Uri;
    #[derive(Debug, Clone)]
    pub struct CardOrdererClient<T> {
        inner: tonic::client::Grpc<T>,
    }
    impl CardOrdererClient<tonic::transport::Channel> {
        /// Attempt to create a new client by connecting to a given endpoint.
        pub async fn connect<D>(dst: D) -> Result<Self, tonic::transport::Error>
        where
            D: std::convert::TryInto<tonic::transport::Endpoint>,
            D::Error: Into<StdError>,
        {
            let conn = tonic::transport::Endpoint::new(dst)?.connect().await?;
            Ok(Self::new(conn))
        }
    }
    impl<T> CardOrdererClient<T>
    where
        T: tonic::client::GrpcService<tonic::body::BoxBody>,
        T::Error: Into<StdError>,
        T::ResponseBody: Body<Data = Bytes> + Send + 'static,
        <T::ResponseBody as Body>::Error: Into<StdError> + Send,
    {
        pub fn new(inner: T) -> Self {
            let inner = tonic::client::Grpc::new(inner);
            Self { inner }
        }
        pub fn with_origin(inner: T, origin: Uri) -> Self {
            let inner = tonic::client::Grpc::with_origin(inner, origin);
            Self { inner }
        }
        pub fn with_interceptor<F>(
            inner: T,
            interceptor: F,
        ) -> CardOrdererClient<InterceptedService<T, F>>
        where
            F: tonic::service::Interceptor,
            T::ResponseBody: Default,
            T: tonic::codegen::Service<
                http::Request<tonic::body::BoxBody>,
                Response = http::Response<
                    <T as tonic::client::GrpcService<tonic::body::BoxBody>>::ResponseBody,
                >,
            >,
            <T as tonic::codegen::Service<
                http::Request<tonic::body::BoxBody>,
            >>::Error: Into<StdError> + Send + Sync,
        {
            CardOrdererClient::new(InterceptedService::new(inner, interceptor))
        }
        /// Compress requests with the given encoding.
        ///
        /// This requires the server to support it otherwise it might respond with an
        /// error.
        #[must_use]
        pub fn send_compressed(mut self, encoding: CompressionEncoding) -> Self {
            self.inner = self.inner.send_compressed(encoding);
            self
        }
        /// Enable decompressing responses.
        #[must_use]
        pub fn accept_compressed(mut self, encoding: CompressionEncoding) -> Self {
            self.inner = self.inner.accept_compressed(encoding);
            self
        }
        pub async fn order(
            &mut self,
            request: impl tonic::IntoRequest<super::OrderRequest>,
        ) -> Result<tonic::Response<super::OrderReply>, tonic::Status> {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static("/breez.CardOrderer/Order");
            self.inner.unary(request.into_request(), path, codec).await
        }
    }
}
/// Generated client implementations.
pub mod pos_client {
    #![allow(unused_variables, dead_code, missing_docs, clippy::let_unit_value)]
    use tonic::codegen::*;
    use tonic::codegen::http::Uri;
    #[derive(Debug, Clone)]
    pub struct PosClient<T> {
        inner: tonic::client::Grpc<T>,
    }
    impl PosClient<tonic::transport::Channel> {
        /// Attempt to create a new client by connecting to a given endpoint.
        pub async fn connect<D>(dst: D) -> Result<Self, tonic::transport::Error>
        where
            D: std::convert::TryInto<tonic::transport::Endpoint>,
            D::Error: Into<StdError>,
        {
            let conn = tonic::transport::Endpoint::new(dst)?.connect().await?;
            Ok(Self::new(conn))
        }
    }
    impl<T> PosClient<T>
    where
        T: tonic::client::GrpcService<tonic::body::BoxBody>,
        T::Error: Into<StdError>,
        T::ResponseBody: Body<Data = Bytes> + Send + 'static,
        <T::ResponseBody as Body>::Error: Into<StdError> + Send,
    {
        pub fn new(inner: T) -> Self {
            let inner = tonic::client::Grpc::new(inner);
            Self { inner }
        }
        pub fn with_origin(inner: T, origin: Uri) -> Self {
            let inner = tonic::client::Grpc::with_origin(inner, origin);
            Self { inner }
        }
        pub fn with_interceptor<F>(
            inner: T,
            interceptor: F,
        ) -> PosClient<InterceptedService<T, F>>
        where
            F: tonic::service::Interceptor,
            T::ResponseBody: Default,
            T: tonic::codegen::Service<
                http::Request<tonic::body::BoxBody>,
                Response = http::Response<
                    <T as tonic::client::GrpcService<tonic::body::BoxBody>>::ResponseBody,
                >,
            >,
            <T as tonic::codegen::Service<
                http::Request<tonic::body::BoxBody>,
            >>::Error: Into<StdError> + Send + Sync,
        {
            PosClient::new(InterceptedService::new(inner, interceptor))
        }
        /// Compress requests with the given encoding.
        ///
        /// This requires the server to support it otherwise it might respond with an
        /// error.
        #[must_use]
        pub fn send_compressed(mut self, encoding: CompressionEncoding) -> Self {
            self.inner = self.inner.send_compressed(encoding);
            self
        }
        /// Enable decompressing responses.
        #[must_use]
        pub fn accept_compressed(mut self, encoding: CompressionEncoding) -> Self {
            self.inner = self.inner.accept_compressed(encoding);
            self
        }
        pub async fn register_device(
            &mut self,
            request: impl tonic::IntoRequest<super::RegisterRequest>,
        ) -> Result<tonic::Response<super::RegisterReply>, tonic::Status> {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static("/breez.Pos/RegisterDevice");
            self.inner.unary(request.into_request(), path, codec).await
        }
        pub async fn upload_logo(
            &mut self,
            request: impl tonic::IntoRequest<super::UploadFileRequest>,
        ) -> Result<tonic::Response<super::UploadFileReply>, tonic::Status> {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static("/breez.Pos/UploadLogo");
            self.inner.unary(request.into_request(), path, codec).await
        }
    }
}
/// Generated client implementations.
pub mod information_client {
    #![allow(unused_variables, dead_code, missing_docs, clippy::let_unit_value)]
    use tonic::codegen::*;
    use tonic::codegen::http::Uri;
    #[derive(Debug, Clone)]
    pub struct InformationClient<T> {
        inner: tonic::client::Grpc<T>,
    }
    impl InformationClient<tonic::transport::Channel> {
        /// Attempt to create a new client by connecting to a given endpoint.
        pub async fn connect<D>(dst: D) -> Result<Self, tonic::transport::Error>
        where
            D: std::convert::TryInto<tonic::transport::Endpoint>,
            D::Error: Into<StdError>,
        {
            let conn = tonic::transport::Endpoint::new(dst)?.connect().await?;
            Ok(Self::new(conn))
        }
    }
    impl<T> InformationClient<T>
    where
        T: tonic::client::GrpcService<tonic::body::BoxBody>,
        T::Error: Into<StdError>,
        T::ResponseBody: Body<Data = Bytes> + Send + 'static,
        <T::ResponseBody as Body>::Error: Into<StdError> + Send,
    {
        pub fn new(inner: T) -> Self {
            let inner = tonic::client::Grpc::new(inner);
            Self { inner }
        }
        pub fn with_origin(inner: T, origin: Uri) -> Self {
            let inner = tonic::client::Grpc::with_origin(inner, origin);
            Self { inner }
        }
        pub fn with_interceptor<F>(
            inner: T,
            interceptor: F,
        ) -> InformationClient<InterceptedService<T, F>>
        where
            F: tonic::service::Interceptor,
            T::ResponseBody: Default,
            T: tonic::codegen::Service<
                http::Request<tonic::body::BoxBody>,
                Response = http::Response<
                    <T as tonic::client::GrpcService<tonic::body::BoxBody>>::ResponseBody,
                >,
            >,
            <T as tonic::codegen::Service<
                http::Request<tonic::body::BoxBody>,
            >>::Error: Into<StdError> + Send + Sync,
        {
            InformationClient::new(InterceptedService::new(inner, interceptor))
        }
        /// Compress requests with the given encoding.
        ///
        /// This requires the server to support it otherwise it might respond with an
        /// error.
        #[must_use]
        pub fn send_compressed(mut self, encoding: CompressionEncoding) -> Self {
            self.inner = self.inner.send_compressed(encoding);
            self
        }
        /// Enable decompressing responses.
        #[must_use]
        pub fn accept_compressed(mut self, encoding: CompressionEncoding) -> Self {
            self.inner = self.inner.accept_compressed(encoding);
            self
        }
        pub async fn ping(
            &mut self,
            request: impl tonic::IntoRequest<super::PingRequest>,
        ) -> Result<tonic::Response<super::PingReply>, tonic::Status> {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static("/breez.Information/Ping");
            self.inner.unary(request.into_request(), path, codec).await
        }
        pub async fn rates(
            &mut self,
            request: impl tonic::IntoRequest<super::RatesRequest>,
        ) -> Result<tonic::Response<super::RatesReply>, tonic::Status> {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static("/breez.Information/Rates");
            self.inner.unary(request.into_request(), path, codec).await
        }
        pub async fn breez_app_versions(
            &mut self,
            request: impl tonic::IntoRequest<super::BreezAppVersionsRequest>,
        ) -> Result<tonic::Response<super::BreezAppVersionsReply>, tonic::Status> {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static(
                "/breez.Information/BreezAppVersions",
            );
            self.inner.unary(request.into_request(), path, codec).await
        }
        pub async fn receiver_info(
            &mut self,
            request: impl tonic::IntoRequest<super::ReceiverInfoRequest>,
        ) -> Result<tonic::Response<super::ReceiverInfoReply>, tonic::Status> {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static(
                "/breez.Information/ReceiverInfo",
            );
            self.inner.unary(request.into_request(), path, codec).await
        }
    }
}
/// Generated client implementations.
pub mod channel_opener_client {
    #![allow(unused_variables, dead_code, missing_docs, clippy::let_unit_value)]
    use tonic::codegen::*;
    use tonic::codegen::http::Uri;
    #[derive(Debug, Clone)]
    pub struct ChannelOpenerClient<T> {
        inner: tonic::client::Grpc<T>,
    }
    impl ChannelOpenerClient<tonic::transport::Channel> {
        /// Attempt to create a new client by connecting to a given endpoint.
        pub async fn connect<D>(dst: D) -> Result<Self, tonic::transport::Error>
        where
            D: std::convert::TryInto<tonic::transport::Endpoint>,
            D::Error: Into<StdError>,
        {
            let conn = tonic::transport::Endpoint::new(dst)?.connect().await?;
            Ok(Self::new(conn))
        }
    }
    impl<T> ChannelOpenerClient<T>
    where
        T: tonic::client::GrpcService<tonic::body::BoxBody>,
        T::Error: Into<StdError>,
        T::ResponseBody: Body<Data = Bytes> + Send + 'static,
        <T::ResponseBody as Body>::Error: Into<StdError> + Send,
    {
        pub fn new(inner: T) -> Self {
            let inner = tonic::client::Grpc::new(inner);
            Self { inner }
        }
        pub fn with_origin(inner: T, origin: Uri) -> Self {
            let inner = tonic::client::Grpc::with_origin(inner, origin);
            Self { inner }
        }
        pub fn with_interceptor<F>(
            inner: T,
            interceptor: F,
        ) -> ChannelOpenerClient<InterceptedService<T, F>>
        where
            F: tonic::service::Interceptor,
            T::ResponseBody: Default,
            T: tonic::codegen::Service<
                http::Request<tonic::body::BoxBody>,
                Response = http::Response<
                    <T as tonic::client::GrpcService<tonic::body::BoxBody>>::ResponseBody,
                >,
            >,
            <T as tonic::codegen::Service<
                http::Request<tonic::body::BoxBody>,
            >>::Error: Into<StdError> + Send + Sync,
        {
            ChannelOpenerClient::new(InterceptedService::new(inner, interceptor))
        }
        /// Compress requests with the given encoding.
        ///
        /// This requires the server to support it otherwise it might respond with an
        /// error.
        #[must_use]
        pub fn send_compressed(mut self, encoding: CompressionEncoding) -> Self {
            self.inner = self.inner.send_compressed(encoding);
            self
        }
        /// Enable decompressing responses.
        #[must_use]
        pub fn accept_compressed(mut self, encoding: CompressionEncoding) -> Self {
            self.inner = self.inner.accept_compressed(encoding);
            self
        }
        pub async fn lsp_list(
            &mut self,
            request: impl tonic::IntoRequest<super::LspListRequest>,
        ) -> Result<tonic::Response<super::LspListReply>, tonic::Status> {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static(
                "/breez.ChannelOpener/LSPList",
            );
            self.inner.unary(request.into_request(), path, codec).await
        }
        pub async fn open_lsp_channel(
            &mut self,
            request: impl tonic::IntoRequest<super::OpenLspChannelRequest>,
        ) -> Result<tonic::Response<super::OpenLspChannelReply>, tonic::Status> {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static(
                "/breez.ChannelOpener/OpenLSPChannel",
            );
            self.inner.unary(request.into_request(), path, codec).await
        }
        pub async fn register_payment(
            &mut self,
            request: impl tonic::IntoRequest<super::RegisterPaymentRequest>,
        ) -> Result<tonic::Response<super::RegisterPaymentReply>, tonic::Status> {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static(
                "/breez.ChannelOpener/RegisterPayment",
            );
            self.inner.unary(request.into_request(), path, codec).await
        }
        pub async fn check_channels(
            &mut self,
            request: impl tonic::IntoRequest<super::CheckChannelsRequest>,
        ) -> Result<tonic::Response<super::CheckChannelsReply>, tonic::Status> {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static(
                "/breez.ChannelOpener/CheckChannels",
            );
            self.inner.unary(request.into_request(), path, codec).await
        }
    }
}
/// Generated client implementations.
pub mod public_channel_opener_client {
    #![allow(unused_variables, dead_code, missing_docs, clippy::let_unit_value)]
    use tonic::codegen::*;
    use tonic::codegen::http::Uri;
    #[derive(Debug, Clone)]
    pub struct PublicChannelOpenerClient<T> {
        inner: tonic::client::Grpc<T>,
    }
    impl PublicChannelOpenerClient<tonic::transport::Channel> {
        /// Attempt to create a new client by connecting to a given endpoint.
        pub async fn connect<D>(dst: D) -> Result<Self, tonic::transport::Error>
        where
            D: std::convert::TryInto<tonic::transport::Endpoint>,
            D::Error: Into<StdError>,
        {
            let conn = tonic::transport::Endpoint::new(dst)?.connect().await?;
            Ok(Self::new(conn))
        }
    }
    impl<T> PublicChannelOpenerClient<T>
    where
        T: tonic::client::GrpcService<tonic::body::BoxBody>,
        T::Error: Into<StdError>,
        T::ResponseBody: Body<Data = Bytes> + Send + 'static,
        <T::ResponseBody as Body>::Error: Into<StdError> + Send,
    {
        pub fn new(inner: T) -> Self {
            let inner = tonic::client::Grpc::new(inner);
            Self { inner }
        }
        pub fn with_origin(inner: T, origin: Uri) -> Self {
            let inner = tonic::client::Grpc::with_origin(inner, origin);
            Self { inner }
        }
        pub fn with_interceptor<F>(
            inner: T,
            interceptor: F,
        ) -> PublicChannelOpenerClient<InterceptedService<T, F>>
        where
            F: tonic::service::Interceptor,
            T::ResponseBody: Default,
            T: tonic::codegen::Service<
                http::Request<tonic::body::BoxBody>,
                Response = http::Response<
                    <T as tonic::client::GrpcService<tonic::body::BoxBody>>::ResponseBody,
                >,
            >,
            <T as tonic::codegen::Service<
                http::Request<tonic::body::BoxBody>,
            >>::Error: Into<StdError> + Send + Sync,
        {
            PublicChannelOpenerClient::new(InterceptedService::new(inner, interceptor))
        }
        /// Compress requests with the given encoding.
        ///
        /// This requires the server to support it otherwise it might respond with an
        /// error.
        #[must_use]
        pub fn send_compressed(mut self, encoding: CompressionEncoding) -> Self {
            self.inner = self.inner.send_compressed(encoding);
            self
        }
        /// Enable decompressing responses.
        #[must_use]
        pub fn accept_compressed(mut self, encoding: CompressionEncoding) -> Self {
            self.inner = self.inner.accept_compressed(encoding);
            self
        }
        pub async fn open_public_channel(
            &mut self,
            request: impl tonic::IntoRequest<super::OpenPublicChannelRequest>,
        ) -> Result<tonic::Response<super::OpenPublicChannelReply>, tonic::Status> {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static(
                "/breez.PublicChannelOpener/OpenPublicChannel",
            );
            self.inner.unary(request.into_request(), path, codec).await
        }
    }
}
/// Generated client implementations.
pub mod fund_manager_client {
    #![allow(unused_variables, dead_code, missing_docs, clippy::let_unit_value)]
    use tonic::codegen::*;
    use tonic::codegen::http::Uri;
    #[derive(Debug, Clone)]
    pub struct FundManagerClient<T> {
        inner: tonic::client::Grpc<T>,
    }
    impl FundManagerClient<tonic::transport::Channel> {
        /// Attempt to create a new client by connecting to a given endpoint.
        pub async fn connect<D>(dst: D) -> Result<Self, tonic::transport::Error>
        where
            D: std::convert::TryInto<tonic::transport::Endpoint>,
            D::Error: Into<StdError>,
        {
            let conn = tonic::transport::Endpoint::new(dst)?.connect().await?;
            Ok(Self::new(conn))
        }
    }
    impl<T> FundManagerClient<T>
    where
        T: tonic::client::GrpcService<tonic::body::BoxBody>,
        T::Error: Into<StdError>,
        T::ResponseBody: Body<Data = Bytes> + Send + 'static,
        <T::ResponseBody as Body>::Error: Into<StdError> + Send,
    {
        pub fn new(inner: T) -> Self {
            let inner = tonic::client::Grpc::new(inner);
            Self { inner }
        }
        pub fn with_origin(inner: T, origin: Uri) -> Self {
            let inner = tonic::client::Grpc::with_origin(inner, origin);
            Self { inner }
        }
        pub fn with_interceptor<F>(
            inner: T,
            interceptor: F,
        ) -> FundManagerClient<InterceptedService<T, F>>
        where
            F: tonic::service::Interceptor,
            T::ResponseBody: Default,
            T: tonic::codegen::Service<
                http::Request<tonic::body::BoxBody>,
                Response = http::Response<
                    <T as tonic::client::GrpcService<tonic::body::BoxBody>>::ResponseBody,
                >,
            >,
            <T as tonic::codegen::Service<
                http::Request<tonic::body::BoxBody>,
            >>::Error: Into<StdError> + Send + Sync,
        {
            FundManagerClient::new(InterceptedService::new(inner, interceptor))
        }
        /// Compress requests with the given encoding.
        ///
        /// This requires the server to support it otherwise it might respond with an
        /// error.
        #[must_use]
        pub fn send_compressed(mut self, encoding: CompressionEncoding) -> Self {
            self.inner = self.inner.send_compressed(encoding);
            self
        }
        /// Enable decompressing responses.
        #[must_use]
        pub fn accept_compressed(mut self, encoding: CompressionEncoding) -> Self {
            self.inner = self.inner.accept_compressed(encoding);
            self
        }
        pub async fn open_channel(
            &mut self,
            request: impl tonic::IntoRequest<super::OpenChannelRequest>,
        ) -> Result<tonic::Response<super::OpenChannelReply>, tonic::Status> {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static(
                "/breez.FundManager/OpenChannel",
            );
            self.inner.unary(request.into_request(), path, codec).await
        }
        pub async fn update_channel_policy(
            &mut self,
            request: impl tonic::IntoRequest<super::UpdateChannelPolicyRequest>,
        ) -> Result<tonic::Response<super::UpdateChannelPolicyReply>, tonic::Status> {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static(
                "/breez.FundManager/UpdateChannelPolicy",
            );
            self.inner.unary(request.into_request(), path, codec).await
        }
        pub async fn add_fund_init(
            &mut self,
            request: impl tonic::IntoRequest<super::AddFundInitRequest>,
        ) -> Result<tonic::Response<super::AddFundInitReply>, tonic::Status> {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static(
                "/breez.FundManager/AddFundInit",
            );
            self.inner.unary(request.into_request(), path, codec).await
        }
        pub async fn add_fund_status(
            &mut self,
            request: impl tonic::IntoRequest<super::AddFundStatusRequest>,
        ) -> Result<tonic::Response<super::AddFundStatusReply>, tonic::Status> {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static(
                "/breez.FundManager/AddFundStatus",
            );
            self.inner.unary(request.into_request(), path, codec).await
        }
        pub async fn remove_fund(
            &mut self,
            request: impl tonic::IntoRequest<super::RemoveFundRequest>,
        ) -> Result<tonic::Response<super::RemoveFundReply>, tonic::Status> {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static(
                "/breez.FundManager/RemoveFund",
            );
            self.inner.unary(request.into_request(), path, codec).await
        }
        pub async fn redeem_removed_funds(
            &mut self,
            request: impl tonic::IntoRequest<super::RedeemRemovedFundsRequest>,
        ) -> Result<tonic::Response<super::RedeemRemovedFundsReply>, tonic::Status> {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static(
                "/breez.FundManager/RedeemRemovedFunds",
            );
            self.inner.unary(request.into_request(), path, codec).await
        }
        pub async fn get_swap_payment(
            &mut self,
            request: impl tonic::IntoRequest<super::GetSwapPaymentRequest>,
        ) -> Result<tonic::Response<super::GetSwapPaymentReply>, tonic::Status> {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static(
                "/breez.FundManager/GetSwapPayment",
            );
            self.inner.unary(request.into_request(), path, codec).await
        }
        pub async fn register_transaction_confirmation(
            &mut self,
            request: impl tonic::IntoRequest<
                super::RegisterTransactionConfirmationRequest,
            >,
        ) -> Result<
            tonic::Response<super::RegisterTransactionConfirmationResponse>,
            tonic::Status,
        > {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static(
                "/breez.FundManager/RegisterTransactionConfirmation",
            );
            self.inner.unary(request.into_request(), path, codec).await
        }
    }
}
/// Generated client implementations.
pub mod swapper_client {
    #![allow(unused_variables, dead_code, missing_docs, clippy::let_unit_value)]
    use tonic::codegen::*;
    use tonic::codegen::http::Uri;
    #[derive(Debug, Clone)]
    pub struct SwapperClient<T> {
        inner: tonic::client::Grpc<T>,
    }
    impl SwapperClient<tonic::transport::Channel> {
        /// Attempt to create a new client by connecting to a given endpoint.
        pub async fn connect<D>(dst: D) -> Result<Self, tonic::transport::Error>
        where
            D: std::convert::TryInto<tonic::transport::Endpoint>,
            D::Error: Into<StdError>,
        {
            let conn = tonic::transport::Endpoint::new(dst)?.connect().await?;
            Ok(Self::new(conn))
        }
    }
    impl<T> SwapperClient<T>
    where
        T: tonic::client::GrpcService<tonic::body::BoxBody>,
        T::Error: Into<StdError>,
        T::ResponseBody: Body<Data = Bytes> + Send + 'static,
        <T::ResponseBody as Body>::Error: Into<StdError> + Send,
    {
        pub fn new(inner: T) -> Self {
            let inner = tonic::client::Grpc::new(inner);
            Self { inner }
        }
        pub fn with_origin(inner: T, origin: Uri) -> Self {
            let inner = tonic::client::Grpc::with_origin(inner, origin);
            Self { inner }
        }
        pub fn with_interceptor<F>(
            inner: T,
            interceptor: F,
        ) -> SwapperClient<InterceptedService<T, F>>
        where
            F: tonic::service::Interceptor,
            T::ResponseBody: Default,
            T: tonic::codegen::Service<
                http::Request<tonic::body::BoxBody>,
                Response = http::Response<
                    <T as tonic::client::GrpcService<tonic::body::BoxBody>>::ResponseBody,
                >,
            >,
            <T as tonic::codegen::Service<
                http::Request<tonic::body::BoxBody>,
            >>::Error: Into<StdError> + Send + Sync,
        {
            SwapperClient::new(InterceptedService::new(inner, interceptor))
        }
        /// Compress requests with the given encoding.
        ///
        /// This requires the server to support it otherwise it might respond with an
        /// error.
        #[must_use]
        pub fn send_compressed(mut self, encoding: CompressionEncoding) -> Self {
            self.inner = self.inner.send_compressed(encoding);
            self
        }
        /// Enable decompressing responses.
        #[must_use]
        pub fn accept_compressed(mut self, encoding: CompressionEncoding) -> Self {
            self.inner = self.inner.accept_compressed(encoding);
            self
        }
        pub async fn add_fund_init(
            &mut self,
            request: impl tonic::IntoRequest<super::AddFundInitRequest>,
        ) -> Result<tonic::Response<super::AddFundInitReply>, tonic::Status> {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static(
                "/breez.Swapper/AddFundInit",
            );
            self.inner.unary(request.into_request(), path, codec).await
        }
        pub async fn add_fund_status(
            &mut self,
            request: impl tonic::IntoRequest<super::AddFundStatusRequest>,
        ) -> Result<tonic::Response<super::AddFundStatusReply>, tonic::Status> {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static(
                "/breez.Swapper/AddFundStatus",
            );
            self.inner.unary(request.into_request(), path, codec).await
        }
        pub async fn get_swap_payment(
            &mut self,
            request: impl tonic::IntoRequest<super::GetSwapPaymentRequest>,
        ) -> Result<tonic::Response<super::GetSwapPaymentReply>, tonic::Status> {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static(
                "/breez.Swapper/GetSwapPayment",
            );
            self.inner.unary(request.into_request(), path, codec).await
        }
        pub async fn redeem_swap_payment(
            &mut self,
            request: impl tonic::IntoRequest<super::RedeemSwapPaymentRequest>,
        ) -> Result<tonic::Response<super::RedeemSwapPaymentReply>, tonic::Status> {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static(
                "/breez.Swapper/RedeemSwapPayment",
            );
            self.inner.unary(request.into_request(), path, codec).await
        }
        pub async fn get_reverse_routing_node(
            &mut self,
            request: impl tonic::IntoRequest<super::GetReverseRoutingNodeRequest>,
        ) -> Result<tonic::Response<super::GetReverseRoutingNodeReply>, tonic::Status> {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static(
                "/breez.Swapper/GetReverseRoutingNode",
            );
            self.inner.unary(request.into_request(), path, codec).await
        }
    }
}
/// Generated client implementations.
pub mod ctp_client {
    #![allow(unused_variables, dead_code, missing_docs, clippy::let_unit_value)]
    use tonic::codegen::*;
    use tonic::codegen::http::Uri;
    #[derive(Debug, Clone)]
    pub struct CtpClient<T> {
        inner: tonic::client::Grpc<T>,
    }
    impl CtpClient<tonic::transport::Channel> {
        /// Attempt to create a new client by connecting to a given endpoint.
        pub async fn connect<D>(dst: D) -> Result<Self, tonic::transport::Error>
        where
            D: std::convert::TryInto<tonic::transport::Endpoint>,
            D::Error: Into<StdError>,
        {
            let conn = tonic::transport::Endpoint::new(dst)?.connect().await?;
            Ok(Self::new(conn))
        }
    }
    impl<T> CtpClient<T>
    where
        T: tonic::client::GrpcService<tonic::body::BoxBody>,
        T::Error: Into<StdError>,
        T::ResponseBody: Body<Data = Bytes> + Send + 'static,
        <T::ResponseBody as Body>::Error: Into<StdError> + Send,
    {
        pub fn new(inner: T) -> Self {
            let inner = tonic::client::Grpc::new(inner);
            Self { inner }
        }
        pub fn with_origin(inner: T, origin: Uri) -> Self {
            let inner = tonic::client::Grpc::with_origin(inner, origin);
            Self { inner }
        }
        pub fn with_interceptor<F>(
            inner: T,
            interceptor: F,
        ) -> CtpClient<InterceptedService<T, F>>
        where
            F: tonic::service::Interceptor,
            T::ResponseBody: Default,
            T: tonic::codegen::Service<
                http::Request<tonic::body::BoxBody>,
                Response = http::Response<
                    <T as tonic::client::GrpcService<tonic::body::BoxBody>>::ResponseBody,
                >,
            >,
            <T as tonic::codegen::Service<
                http::Request<tonic::body::BoxBody>,
            >>::Error: Into<StdError> + Send + Sync,
        {
            CtpClient::new(InterceptedService::new(inner, interceptor))
        }
        /// Compress requests with the given encoding.
        ///
        /// This requires the server to support it otherwise it might respond with an
        /// error.
        #[must_use]
        pub fn send_compressed(mut self, encoding: CompressionEncoding) -> Self {
            self.inner = self.inner.send_compressed(encoding);
            self
        }
        /// Enable decompressing responses.
        #[must_use]
        pub fn accept_compressed(mut self, encoding: CompressionEncoding) -> Self {
            self.inner = self.inner.accept_compressed(encoding);
            self
        }
        pub async fn join_ctp_session(
            &mut self,
            request: impl tonic::IntoRequest<super::JoinCtpSessionRequest>,
        ) -> Result<tonic::Response<super::JoinCtpSessionResponse>, tonic::Status> {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static("/breez.CTP/JoinCTPSession");
            self.inner.unary(request.into_request(), path, codec).await
        }
        pub async fn terminate_ctp_session(
            &mut self,
            request: impl tonic::IntoRequest<super::TerminateCtpSessionRequest>,
        ) -> Result<tonic::Response<super::TerminateCtpSessionResponse>, tonic::Status> {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static(
                "/breez.CTP/TerminateCTPSession",
            );
            self.inner.unary(request.into_request(), path, codec).await
        }
    }
}
/// Generated client implementations.
pub mod node_info_client {
    #![allow(unused_variables, dead_code, missing_docs, clippy::let_unit_value)]
    use tonic::codegen::*;
    use tonic::codegen::http::Uri;
    #[derive(Debug, Clone)]
    pub struct NodeInfoClient<T> {
        inner: tonic::client::Grpc<T>,
    }
    impl NodeInfoClient<tonic::transport::Channel> {
        /// Attempt to create a new client by connecting to a given endpoint.
        pub async fn connect<D>(dst: D) -> Result<Self, tonic::transport::Error>
        where
            D: std::convert::TryInto<tonic::transport::Endpoint>,
            D::Error: Into<StdError>,
        {
            let conn = tonic::transport::Endpoint::new(dst)?.connect().await?;
            Ok(Self::new(conn))
        }
    }
    impl<T> NodeInfoClient<T>
    where
        T: tonic::client::GrpcService<tonic::body::BoxBody>,
        T::Error: Into<StdError>,
        T::ResponseBody: Body<Data = Bytes> + Send + 'static,
        <T::ResponseBody as Body>::Error: Into<StdError> + Send,
    {
        pub fn new(inner: T) -> Self {
            let inner = tonic::client::Grpc::new(inner);
            Self { inner }
        }
        pub fn with_origin(inner: T, origin: Uri) -> Self {
            let inner = tonic::client::Grpc::with_origin(inner, origin);
            Self { inner }
        }
        pub fn with_interceptor<F>(
            inner: T,
            interceptor: F,
        ) -> NodeInfoClient<InterceptedService<T, F>>
        where
            F: tonic::service::Interceptor,
            T::ResponseBody: Default,
            T: tonic::codegen::Service<
                http::Request<tonic::body::BoxBody>,
                Response = http::Response<
                    <T as tonic::client::GrpcService<tonic::body::BoxBody>>::ResponseBody,
                >,
            >,
            <T as tonic::codegen::Service<
                http::Request<tonic::body::BoxBody>,
            >>::Error: Into<StdError> + Send + Sync,
        {
            NodeInfoClient::new(InterceptedService::new(inner, interceptor))
        }
        /// Compress requests with the given encoding.
        ///
        /// This requires the server to support it otherwise it might respond with an
        /// error.
        #[must_use]
        pub fn send_compressed(mut self, encoding: CompressionEncoding) -> Self {
            self.inner = self.inner.send_compressed(encoding);
            self
        }
        /// Enable decompressing responses.
        #[must_use]
        pub fn accept_compressed(mut self, encoding: CompressionEncoding) -> Self {
            self.inner = self.inner.accept_compressed(encoding);
            self
        }
        pub async fn set_node_info(
            &mut self,
            request: impl tonic::IntoRequest<super::SetNodeInfoRequest>,
        ) -> Result<tonic::Response<super::SetNodeInfoResponse>, tonic::Status> {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static(
                "/breez.NodeInfo/SetNodeInfo",
            );
            self.inner.unary(request.into_request(), path, codec).await
        }
        pub async fn get_node_info(
            &mut self,
            request: impl tonic::IntoRequest<super::GetNodeInfoRequest>,
        ) -> Result<tonic::Response<super::GetNodeInfoResponse>, tonic::Status> {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static(
                "/breez.NodeInfo/GetNodeInfo",
            );
            self.inner.unary(request.into_request(), path, codec).await
        }
    }
}
/// Generated client implementations.
pub mod sync_notifier_client {
    #![allow(unused_variables, dead_code, missing_docs, clippy::let_unit_value)]
    use tonic::codegen::*;
    use tonic::codegen::http::Uri;
    #[derive(Debug, Clone)]
    pub struct SyncNotifierClient<T> {
        inner: tonic::client::Grpc<T>,
    }
    impl SyncNotifierClient<tonic::transport::Channel> {
        /// Attempt to create a new client by connecting to a given endpoint.
        pub async fn connect<D>(dst: D) -> Result<Self, tonic::transport::Error>
        where
            D: std::convert::TryInto<tonic::transport::Endpoint>,
            D::Error: Into<StdError>,
        {
            let conn = tonic::transport::Endpoint::new(dst)?.connect().await?;
            Ok(Self::new(conn))
        }
    }
    impl<T> SyncNotifierClient<T>
    where
        T: tonic::client::GrpcService<tonic::body::BoxBody>,
        T::Error: Into<StdError>,
        T::ResponseBody: Body<Data = Bytes> + Send + 'static,
        <T::ResponseBody as Body>::Error: Into<StdError> + Send,
    {
        pub fn new(inner: T) -> Self {
            let inner = tonic::client::Grpc::new(inner);
            Self { inner }
        }
        pub fn with_origin(inner: T, origin: Uri) -> Self {
            let inner = tonic::client::Grpc::with_origin(inner, origin);
            Self { inner }
        }
        pub fn with_interceptor<F>(
            inner: T,
            interceptor: F,
        ) -> SyncNotifierClient<InterceptedService<T, F>>
        where
            F: tonic::service::Interceptor,
            T::ResponseBody: Default,
            T: tonic::codegen::Service<
                http::Request<tonic::body::BoxBody>,
                Response = http::Response<
                    <T as tonic::client::GrpcService<tonic::body::BoxBody>>::ResponseBody,
                >,
            >,
            <T as tonic::codegen::Service<
                http::Request<tonic::body::BoxBody>,
            >>::Error: Into<StdError> + Send + Sync,
        {
            SyncNotifierClient::new(InterceptedService::new(inner, interceptor))
        }
        /// Compress requests with the given encoding.
        ///
        /// This requires the server to support it otherwise it might respond with an
        /// error.
        #[must_use]
        pub fn send_compressed(mut self, encoding: CompressionEncoding) -> Self {
            self.inner = self.inner.send_compressed(encoding);
            self
        }
        /// Enable decompressing responses.
        #[must_use]
        pub fn accept_compressed(mut self, encoding: CompressionEncoding) -> Self {
            self.inner = self.inner.accept_compressed(encoding);
            self
        }
        pub async fn register_periodic_sync(
            &mut self,
            request: impl tonic::IntoRequest<super::RegisterPeriodicSyncRequest>,
        ) -> Result<
            tonic::Response<super::RegisterPeriodicSyncResponse>,
            tonic::Status,
        > {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static(
                "/breez.SyncNotifier/RegisterPeriodicSync",
            );
            self.inner.unary(request.into_request(), path, codec).await
        }
    }
}
/// Generated client implementations.
pub mod push_tx_notifier_client {
    #![allow(unused_variables, dead_code, missing_docs, clippy::let_unit_value)]
    use tonic::codegen::*;
    use tonic::codegen::http::Uri;
    #[derive(Debug, Clone)]
    pub struct PushTxNotifierClient<T> {
        inner: tonic::client::Grpc<T>,
    }
    impl PushTxNotifierClient<tonic::transport::Channel> {
        /// Attempt to create a new client by connecting to a given endpoint.
        pub async fn connect<D>(dst: D) -> Result<Self, tonic::transport::Error>
        where
            D: std::convert::TryInto<tonic::transport::Endpoint>,
            D::Error: Into<StdError>,
        {
            let conn = tonic::transport::Endpoint::new(dst)?.connect().await?;
            Ok(Self::new(conn))
        }
    }
    impl<T> PushTxNotifierClient<T>
    where
        T: tonic::client::GrpcService<tonic::body::BoxBody>,
        T::Error: Into<StdError>,
        T::ResponseBody: Body<Data = Bytes> + Send + 'static,
        <T::ResponseBody as Body>::Error: Into<StdError> + Send,
    {
        pub fn new(inner: T) -> Self {
            let inner = tonic::client::Grpc::new(inner);
            Self { inner }
        }
        pub fn with_origin(inner: T, origin: Uri) -> Self {
            let inner = tonic::client::Grpc::with_origin(inner, origin);
            Self { inner }
        }
        pub fn with_interceptor<F>(
            inner: T,
            interceptor: F,
        ) -> PushTxNotifierClient<InterceptedService<T, F>>
        where
            F: tonic::service::Interceptor,
            T::ResponseBody: Default,
            T: tonic::codegen::Service<
                http::Request<tonic::body::BoxBody>,
                Response = http::Response<
                    <T as tonic::client::GrpcService<tonic::body::BoxBody>>::ResponseBody,
                >,
            >,
            <T as tonic::codegen::Service<
                http::Request<tonic::body::BoxBody>,
            >>::Error: Into<StdError> + Send + Sync,
        {
            PushTxNotifierClient::new(InterceptedService::new(inner, interceptor))
        }
        /// Compress requests with the given encoding.
        ///
        /// This requires the server to support it otherwise it might respond with an
        /// error.
        #[must_use]
        pub fn send_compressed(mut self, encoding: CompressionEncoding) -> Self {
            self.inner = self.inner.send_compressed(encoding);
            self
        }
        /// Enable decompressing responses.
        #[must_use]
        pub fn accept_compressed(mut self, encoding: CompressionEncoding) -> Self {
            self.inner = self.inner.accept_compressed(encoding);
            self
        }
        pub async fn register_tx_notification(
            &mut self,
            request: impl tonic::IntoRequest<super::PushTxNotificationRequest>,
        ) -> Result<tonic::Response<super::PushTxNotificationResponse>, tonic::Status> {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static(
                "/breez.PushTxNotifier/RegisterTxNotification",
            );
            self.inner.unary(request.into_request(), path, codec).await
        }
    }
}
/// Generated client implementations.
pub mod inactive_notifier_client {
    #![allow(unused_variables, dead_code, missing_docs, clippy::let_unit_value)]
    use tonic::codegen::*;
    use tonic::codegen::http::Uri;
    #[derive(Debug, Clone)]
    pub struct InactiveNotifierClient<T> {
        inner: tonic::client::Grpc<T>,
    }
    impl InactiveNotifierClient<tonic::transport::Channel> {
        /// Attempt to create a new client by connecting to a given endpoint.
        pub async fn connect<D>(dst: D) -> Result<Self, tonic::transport::Error>
        where
            D: std::convert::TryInto<tonic::transport::Endpoint>,
            D::Error: Into<StdError>,
        {
            let conn = tonic::transport::Endpoint::new(dst)?.connect().await?;
            Ok(Self::new(conn))
        }
    }
    impl<T> InactiveNotifierClient<T>
    where
        T: tonic::client::GrpcService<tonic::body::BoxBody>,
        T::Error: Into<StdError>,
        T::ResponseBody: Body<Data = Bytes> + Send + 'static,
        <T::ResponseBody as Body>::Error: Into<StdError> + Send,
    {
        pub fn new(inner: T) -> Self {
            let inner = tonic::client::Grpc::new(inner);
            Self { inner }
        }
        pub fn with_origin(inner: T, origin: Uri) -> Self {
            let inner = tonic::client::Grpc::with_origin(inner, origin);
            Self { inner }
        }
        pub fn with_interceptor<F>(
            inner: T,
            interceptor: F,
        ) -> InactiveNotifierClient<InterceptedService<T, F>>
        where
            F: tonic::service::Interceptor,
            T::ResponseBody: Default,
            T: tonic::codegen::Service<
                http::Request<tonic::body::BoxBody>,
                Response = http::Response<
                    <T as tonic::client::GrpcService<tonic::body::BoxBody>>::ResponseBody,
                >,
            >,
            <T as tonic::codegen::Service<
                http::Request<tonic::body::BoxBody>,
            >>::Error: Into<StdError> + Send + Sync,
        {
            InactiveNotifierClient::new(InterceptedService::new(inner, interceptor))
        }
        /// Compress requests with the given encoding.
        ///
        /// This requires the server to support it otherwise it might respond with an
        /// error.
        #[must_use]
        pub fn send_compressed(mut self, encoding: CompressionEncoding) -> Self {
            self.inner = self.inner.send_compressed(encoding);
            self
        }
        /// Enable decompressing responses.
        #[must_use]
        pub fn accept_compressed(mut self, encoding: CompressionEncoding) -> Self {
            self.inner = self.inner.accept_compressed(encoding);
            self
        }
        pub async fn inactive_notify(
            &mut self,
            request: impl tonic::IntoRequest<super::InactiveNotifyRequest>,
        ) -> Result<tonic::Response<super::InactiveNotifyResponse>, tonic::Status> {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static(
                "/breez.InactiveNotifier/InactiveNotify",
            );
            self.inner.unary(request.into_request(), path, codec).await
        }
    }
}
/// Generated client implementations.
pub mod signer_client {
    #![allow(unused_variables, dead_code, missing_docs, clippy::let_unit_value)]
    use tonic::codegen::*;
    use tonic::codegen::http::Uri;
    #[derive(Debug, Clone)]
    pub struct SignerClient<T> {
        inner: tonic::client::Grpc<T>,
    }
    impl SignerClient<tonic::transport::Channel> {
        /// Attempt to create a new client by connecting to a given endpoint.
        pub async fn connect<D>(dst: D) -> Result<Self, tonic::transport::Error>
        where
            D: std::convert::TryInto<tonic::transport::Endpoint>,
            D::Error: Into<StdError>,
        {
            let conn = tonic::transport::Endpoint::new(dst)?.connect().await?;
            Ok(Self::new(conn))
        }
    }
    impl<T> SignerClient<T>
    where
        T: tonic::client::GrpcService<tonic::body::BoxBody>,
        T::Error: Into<StdError>,
        T::ResponseBody: Body<Data = Bytes> + Send + 'static,
        <T::ResponseBody as Body>::Error: Into<StdError> + Send,
    {
        pub fn new(inner: T) -> Self {
            let inner = tonic::client::Grpc::new(inner);
            Self { inner }
        }
        pub fn with_origin(inner: T, origin: Uri) -> Self {
            let inner = tonic::client::Grpc::with_origin(inner, origin);
            Self { inner }
        }
        pub fn with_interceptor<F>(
            inner: T,
            interceptor: F,
        ) -> SignerClient<InterceptedService<T, F>>
        where
            F: tonic::service::Interceptor,
            T::ResponseBody: Default,
            T: tonic::codegen::Service<
                http::Request<tonic::body::BoxBody>,
                Response = http::Response<
                    <T as tonic::client::GrpcService<tonic::body::BoxBody>>::ResponseBody,
                >,
            >,
            <T as tonic::codegen::Service<
                http::Request<tonic::body::BoxBody>,
            >>::Error: Into<StdError> + Send + Sync,
        {
            SignerClient::new(InterceptedService::new(inner, interceptor))
        }
        /// Compress requests with the given encoding.
        ///
        /// This requires the server to support it otherwise it might respond with an
        /// error.
        #[must_use]
        pub fn send_compressed(mut self, encoding: CompressionEncoding) -> Self {
            self.inner = self.inner.send_compressed(encoding);
            self
        }
        /// Enable decompressing responses.
        #[must_use]
        pub fn accept_compressed(mut self, encoding: CompressionEncoding) -> Self {
            self.inner = self.inner.accept_compressed(encoding);
            self
        }
        pub async fn sign_url(
            &mut self,
            request: impl tonic::IntoRequest<super::SignUrlRequest>,
        ) -> Result<tonic::Response<super::SignUrlResponse>, tonic::Status> {
            self.inner
                .ready()
                .await
                .map_err(|e| {
                    tonic::Status::new(
                        tonic::Code::Unknown,
                        format!("Service was not ready: {}", e.into()),
                    )
                })?;
            let codec = tonic::codec::ProstCodec::default();
            let path = http::uri::PathAndQuery::from_static("/breez.Signer/SignUrl");
            self.inner.unary(request.into_request(), path, codec).await
        }
    }
}
