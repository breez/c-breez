#[derive(Clone, PartialEq, ::prost::Message)]
pub struct ChannelInformationRequest {
    /// / The identity pubkey of the Lightning node
    #[prost(string, tag="1")]
    pub pubkey: ::prost::alloc::string::String,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct ChannelInformationReply {
    /// / The name of of lsp
    #[prost(string, tag="1")]
    pub name: ::prost::alloc::string::String,
    /// / The identity pubkey of the Lightning node
    #[prost(string, tag="2")]
    pub pubkey: ::prost::alloc::string::String,
    /// / The network location of the lightning node, e.g. `12.34.56.78:9012` or
    /// / `localhost:10011`
    #[prost(string, tag="3")]
    pub host: ::prost::alloc::string::String,
    /// / The channel capacity in satoshis
    #[prost(int64, tag="4")]
    pub channel_capacity: i64,
    /// / The target number of blocks that the funding transaction should be
    /// / confirmed by.
    #[prost(int32, tag="5")]
    pub target_conf: i32,
    /// / The base fee charged regardless of the number of milli-satoshis sent.
    #[prost(int64, tag="6")]
    pub base_fee_msat: i64,
    /// / The effective fee rate in milli-satoshis. The precision of this value goes
    /// / up to 6 decimal places, so 1e-6.
    #[prost(double, tag="7")]
    pub fee_rate: f64,
    /// / The required timelock delta for HTLCs forwarded over the channel.
    #[prost(uint32, tag="8")]
    pub time_lock_delta: u32,
    /// / The minimum value in millisatoshi we will require for incoming HTLCs on
    /// / the channel.
    #[prost(int64, tag="9")]
    pub min_htlc_msat: i64,
    #[prost(int64, tag="10")]
    pub channel_fee_permyriad: i64,
    #[prost(bytes="vec", tag="11")]
    pub lsp_pubkey: ::prost::alloc::vec::Vec<u8>,
    /// The channel can be closed if not used this duration in seconds.
    #[prost(int64, tag="12")]
    pub max_inactive_duration: i64,
    #[prost(int64, tag="13")]
    pub channel_minimum_fee_msat: i64,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct OpenChannelRequest {
    /// / The identity pubkey of the Lightning node
    #[prost(string, tag="1")]
    pub pubkey: ::prost::alloc::string::String,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct OpenChannelReply {
    /// / The transaction hash
    #[prost(string, tag="1")]
    pub tx_hash: ::prost::alloc::string::String,
    /// / The output index
    #[prost(uint32, tag="2")]
    pub output_index: u32,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct RegisterPaymentRequest {
    #[prost(bytes="vec", tag="3")]
    pub blob: ::prost::alloc::vec::Vec<u8>,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct RegisterPaymentReply {
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct PaymentInformation {
    #[prost(bytes="vec", tag="1")]
    pub payment_hash: ::prost::alloc::vec::Vec<u8>,
    #[prost(bytes="vec", tag="2")]
    pub payment_secret: ::prost::alloc::vec::Vec<u8>,
    #[prost(bytes="vec", tag="3")]
    pub destination: ::prost::alloc::vec::Vec<u8>,
    #[prost(int64, tag="4")]
    pub incoming_amount_msat: i64,
    #[prost(int64, tag="5")]
    pub outgoing_amount_msat: i64,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct Encrypted {
    #[prost(bytes="vec", tag="1")]
    pub data: ::prost::alloc::vec::Vec<u8>,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct Signed {
    #[prost(bytes="vec", tag="1")]
    pub data: ::prost::alloc::vec::Vec<u8>,
    #[prost(bytes="vec", tag="2")]
    pub pubkey: ::prost::alloc::vec::Vec<u8>,
    #[prost(bytes="vec", tag="3")]
    pub signature: ::prost::alloc::vec::Vec<u8>,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct CheckChannelsRequest {
    #[prost(bytes="vec", tag="1")]
    pub encrypt_pubkey: ::prost::alloc::vec::Vec<u8>,
    #[prost(map="string, uint64", tag="2")]
    pub fake_channels: ::std::collections::HashMap<::prost::alloc::string::String, u64>,
    #[prost(map="string, uint64", tag="3")]
    pub waiting_close_channels: ::std::collections::HashMap<::prost::alloc::string::String, u64>,
}
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct CheckChannelsReply {
    #[prost(map="string, uint64", tag="1")]
    pub not_fake_channels: ::std::collections::HashMap<::prost::alloc::string::String, u64>,
    #[prost(map="string, uint64", tag="2")]
    pub closed_channels: ::std::collections::HashMap<::prost::alloc::string::String, u64>,
}
