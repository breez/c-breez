use crate::invoice::parse_invoice;
use crate::models::{
    Config, FeeratePreset, GreenlightCredentials, Network, NodeAPI, NodeState, SyncResponse,
};

use anyhow::{anyhow, Result};
use bitcoin::bech32::{u5, ToBase32};
use bitcoin::secp256k1::ecdsa::{RecoverableSignature, RecoveryId};
use gl_client::pb::amount::Unit;
use gl_client::pb::{
    Amount, CloseChannelRequest, CloseChannelResponse, Invoice, InvoiceRequest, InvoiceStatus,
    PayStatus, Payment, WithdrawResponse,
};
use gl_client::scheduler::Scheduler;
use gl_client::signer::Signer;
use gl_client::tls::TlsConfig;
use gl_client::{node, pb};

use gl_client::pb::Peer;
use lightning_invoice::{RawInvoice, SignedRawInvoice};
use std::cmp::{max, min};
use std::time::{SystemTime, UNIX_EPOCH};
use std::usize::MIN;
use tokio::sync::mpsc;
use tonic::Streaming;

const MAX_PAYMENT_AMOUNT_MSAT: u64 = 4294967000;
const MAX_INBOUND_LIQUIDITY_MSAT: u64 = 4000000000;

#[derive(Clone)]
pub(crate) struct Greenlight {
    sdk_config: Config,
    tls_config: TlsConfig,
    signer: Signer,
}

impl Greenlight {
    pub(crate) fn new(
        sdk_config: Config,
        seed: Vec<u8>,
        creds: GreenlightCredentials,
    ) -> Result<Greenlight> {
        let greenlight_network = sdk_config.network.clone().into();
        let tls_config = TlsConfig::new()?.identity(creds.device_cert, creds.device_key);
        let signer = Signer::new(seed, greenlight_network, tls_config.clone())?;
        Ok(Greenlight {
            sdk_config,
            tls_config: tls_config.clone(),
            signer: signer.clone(),
        })
    }

    pub(crate) async fn register(network: Network, seed: Vec<u8>) -> Result<GreenlightCredentials> {
        let greenlight_network = network.into();
        let tls_config = TlsConfig::new()?;
        let signer = Signer::new(seed, greenlight_network, tls_config.clone())?;
        let scheduler = Scheduler::new(signer.node_id(), greenlight_network).await?;
        let recover_res: pb::RegistrationResponse = scheduler.register(&signer).await?;

        Ok(GreenlightCredentials {
            device_key: recover_res.device_key.into(),
            device_cert: recover_res.device_cert.into(),
        })
    }

    pub(crate) async fn recover(network: Network, seed: Vec<u8>) -> Result<GreenlightCredentials> {
        let greenlight_network = network.into();
        let tls_config = TlsConfig::new()?;
        let signer = Signer::new(seed, greenlight_network, tls_config.clone())?;
        let scheduler = Scheduler::new(signer.node_id(), greenlight_network).await?;
        let recover_res: pb::RecoveryResponse = scheduler.recover(&signer).await?;

        Ok(GreenlightCredentials {
            device_key: recover_res.device_key.as_bytes().to_vec(),
            device_cert: recover_res.device_cert.as_bytes().to_vec(),
        })
    }

    async fn get_client(&self) -> Result<node::Client> {
        let scheduler = Scheduler::new(
            self.signer.node_id(),
            self.sdk_config.network.clone().into(),
        )
        .await?;
        let client: node::Client = scheduler.schedule(self.tls_config.clone()).await?;
        Ok(client)
    }
}

#[tonic::async_trait]
impl NodeAPI for Greenlight {
    async fn start(&self) -> Result<()> {
        self.get_client().await?;
        Ok(())
    }

    async fn start_signer(&self, shutdown: mpsc::Receiver<()>) {
        _ = self.signer.run_forever(shutdown).await;
        error!("signer exited");
    }

    async fn stream_incoming_payments(&self) -> Result<Streaming<gl_client::pb::IncomingPayment>> {
        let mut client = self.get_client().await?;
        let stream = client
            .stream_incoming(gl_client::pb::StreamIncomingFilter {})
            .await?
            .into_inner();
        Ok(stream)
    }

    async fn stream_log_messages(&self) -> Result<Streaming<gl_client::pb::LogEntry>> {
        let mut client = self.get_client().await?;
        let stream = client
            .stream_log(gl_client::pb::StreamLogRequest {})
            .await?
            .into_inner();
        Ok(stream)
    }

    fn sign_invoice(&self, invoice: RawInvoice) -> Result<String> {
        let hrp_bytes = invoice.hrp.to_string().as_bytes().to_vec();
        let data_bytes = invoice.data.to_base32();

        // create the message for the signer
        let msg_type: u16 = 8;
        let data_len: u16 = data_bytes.len().try_into()?;
        let mut data_len_bytes = data_len.to_be_bytes().to_vec();
        let mut data_buf = data_bytes
            .to_vec()
            .into_iter()
            .map(|b| u5::to_u8(b))
            .collect();

        let hrp_len: u16 = hrp_bytes.len().try_into()?;
        let mut hrp_len_bytes = hrp_len.to_be_bytes().to_vec();
        let mut hrp_buf = hrp_bytes.to_vec();

        let mut buf = msg_type.to_be_bytes().to_vec();
        buf.append(&mut data_len_bytes);
        buf.append(&mut data_buf);
        buf.append(&mut hrp_len_bytes);
        buf.append(&mut hrp_buf);
        // Sign the invoice using the signer
        let raw_result = self.signer.sign_invoice(buf)?;
        info!(
            "recover id: {:?} raw = {:?}",
            raw_result, raw_result[64] as i32
        );
        // contruct the RecoveryId
        let rid = RecoveryId::from_i32(raw_result[64] as i32).expect("recovery ID");
        let sig = &raw_result[0..64];
        let recoverable_sig = RecoverableSignature::from_compact(sig, rid)
            .map_err(|e| anyhow!(e))?
            .clone();

        let signed_invoice: Result<SignedRawInvoice> = invoice.sign(|_| Ok(recoverable_sig));
        Ok(signed_invoice?.to_string())
    }

    async fn connect_peer(&self, node_id: String, addr: String) -> Result<()> {
        let mut client = self.get_client().await?;
        let connect_req = pb::ConnectRequest { node_id, addr };
        client.connect_peer(connect_req).await?;
        Ok(())
    }

    // implemenet pull changes from greenlight
    async fn pull_changed(&self, since_timestamp: i64) -> Result<SyncResponse> {
        let mut client = self.get_client().await?;

        // list all peers
        let peers = client
            .list_peers(pb::ListPeersRequest::default())
            .await?
            .into_inner();

        // get node info
        let node_info = client
            .get_info(pb::GetInfoRequest::default())
            .await?
            .into_inner();

        // list both off chain funds and on chain fudns
        let funds = client
            .list_funds(pb::ListFundsRequest::default())
            .await?
            .into_inner();
        let offchain_funds = funds.channels;
        let onchain_funds = funds.outputs;

        // filter only connected peers
        let connected_peers: Vec<String> = peers
            .peers
            .clone()
            .iter()
            .filter(|p| p.connected)
            .map(|p| hex::encode(p.id.clone()))
            .collect();

        // make a vector of all channels by searching in peers
        let all_channels: &mut Vec<pb::Channel> = &mut Vec::new();
        peers.peers.clone().iter().for_each(|p| {
            let peer_channels = &mut p.channels.clone();
            all_channels.append(peer_channels);
        });

        // filter only opened channels
        let opened_channels: &mut Vec<&pb::Channel> = &mut all_channels
            .iter()
            .filter(|c| return c.state == String::from("CHANNELD_NORMAL"))
            .collect();

        // calculate channels balance only from opened channels
        let channels_balance = offchain_funds.iter().fold(0, |a, b| {
            let hex_txid = hex::encode(b.funding_txid.clone());
            if opened_channels.iter().any(|c| c.funding_txid == hex_txid) {
                return a + b.our_amount_msat;
            }
            return a;
        });

        // calculate onchain balance
        let onchain_balance = onchain_funds.iter().fold(0, |a, b| {
            a + amount_to_msat(b.amount.clone().unwrap_or_default())
        });

        // calculate payment limits and inbound liquidity
        let mut max_payable: u64 = 0;
        let mut max_receivable_single_channel: u64 = 0;
        opened_channels.iter().try_for_each(|c| -> Result<()> {
            max_payable += amount_to_msat(parse_amount(c.spendable.clone())?);
            let receivable_amount = amount_to_msat(parse_amount(c.receivable.clone())?);
            if receivable_amount > max_receivable_single_channel {
                max_receivable_single_channel = receivable_amount;
            }
            Ok(())
        })?;

        let max_allowed_to_receive_msats = max(MAX_INBOUND_LIQUIDITY_MSAT - channels_balance, 0);
        let node_pubkey = hex::encode(node_info.node_id);

        // construct the node state
        let node_state = NodeState {
            id: node_pubkey.clone(),
            block_height: node_info.blockheight,
            channels_balance_msat: channels_balance,
            onchain_balance_msat: onchain_balance,
            max_payable_msat: max_payable,
            max_receivable_msat: max_allowed_to_receive_msats,
            max_single_payment_amount_msat: MAX_PAYMENT_AMOUNT_MSAT,
            max_chan_reserve_msats: channels_balance - min(max_payable, channels_balance),
            connected_peers: connected_peers,
            inbound_liquidity_msats: max_receivable_single_channel,
        };
        Ok(SyncResponse {
            node_state,
            payments: pull_transactions(node_pubkey.clone(), since_timestamp, client.clone())
                .await?,
        })
    }

    async fn list_peers(&self) -> Result<Vec<Peer>> {
        let mut client = self.get_client().await?;
        Ok(client
            .list_peers(pb::ListPeersRequest::default())
            .await?
            .into_inner()
            .peers)
    }

    async fn create_invoice(
        &self,
        amount_sats: u64,
        description: String,
        preimage: Option<Vec<u8>>,
    ) -> Result<Invoice> {
        let mut client = self.get_client().await?;

        let request = InvoiceRequest {
            amount: Some(Amount {
                unit: Some(Unit::Satoshi(amount_sats)),
            }),
            label: format!(
                "breez-{}",
                SystemTime::now().duration_since(UNIX_EPOCH)?.as_millis()
            ),
            description,
            preimage: preimage.unwrap_or(vec![]),
        };

        Ok(client.create_invoice(request).await?.into_inner())
    }

    async fn send_payment(&self, bolt11: String, amount_sats: Option<u64>) -> Result<Payment> {
        let mut client = self.get_client().await?;

        let request = pb::PayRequest {
            amount: amount_sats
                .map(Unit::Satoshi)
                .map(Some)
                .map(|amt| Amount { unit: amt }),
            bolt11,
            timeout: self.sdk_config.payment_timeout_sec,
        };
        Ok(client.pay(request).await?.into_inner())
    }

    async fn send_spontaneous_payment(&self, node_id: String, amount_sats: u64) -> Result<Payment> {
        let mut client = self.get_client().await?;

        let request = pb::KeysendRequest {
            node_id: hex::decode(node_id)?,
            amount: Some(Amount {
                unit: Some(Unit::Satoshi(amount_sats)),
            }),
            label: format!(
                "breez-{}",
                SystemTime::now().duration_since(UNIX_EPOCH)?.as_millis()
            ),
            extratlvs: vec![],
            routehints: vec![],
        };
        Ok(client.keysend(request).await?.into_inner())
    }

    async fn close_peer_channels(&self, node_id: String) -> Result<CloseChannelResponse> {
        let mut client = self.get_client().await?;

        let request = CloseChannelRequest {
            node_id: hex::decode(node_id)?,
            destination: None,
            unilateraltimeout: None,
        };
        Ok(client.close_channel(request).await?.into_inner())
    }

    async fn sweep(
        &self,
        to_address: String,
        feerate_preset: FeeratePreset,
    ) -> Result<WithdrawResponse> {
        let mut client = self.get_client().await?;

        let fee_rate = pb::Feerate {
            value: Some(pb::feerate::Value::Preset(match feerate_preset {
                FeeratePreset::Regular => pb::FeeratePreset::Normal,
                FeeratePreset::Economy => pb::FeeratePreset::Slow,
                FeeratePreset::Priority => pb::FeeratePreset::Urgent,
            } as i32)),
        };

        let request = pb::WithdrawRequest {
            feerate: Some(fee_rate),
            amount: Some(Amount {
                unit: Some(Unit::All(true)),
            }),
            destination: to_address,
            minconf: None,
            utxos: vec![],
        };

        Ok(client.withdraw(request).await?.into_inner())
    }
}

// pulls transactions from greenlight based on last sync timestamp.
// greenlight gives us the payments via API and for received payments we are looking for settled invoices.
async fn pull_transactions(
    node_pubkey: String,
    since_timestamp: i64,
    client: node::Client,
) -> Result<Vec<crate::models::Payment>> {
    let mut c = client.clone();

    // list invoices
    let invoices = c
        .list_invoices(pb::ListInvoicesRequest::default())
        .await?
        .into_inner();

    // construct the received transactions by filtering the invoices to those paid and beyond the filter timestamp
    let received_transations: Result<Vec<crate::models::Payment>> = invoices
        .invoices
        .into_iter()
        .filter(|i| {
            i.payment_time > 0
                && i.status() == InvoiceStatus::Paid
                && i.payment_time as i64 > since_timestamp
        })
        .map(|i| invoice_to_transaction(node_pubkey.clone(), i))
        .collect();

    // fetch payments from greenlight
    let payments = c
        .list_payments(pb::ListPaymentsRequest::default())
        .await?
        .into_inner();
    debug!("list payments: {:?}", payments);
    // construct the payment transactions
    let sent_transactions: Result<Vec<crate::models::Payment>> = payments
        .payments
        .into_iter()
        .filter(|p| p.created_at as i64 > since_timestamp && p.status() == PayStatus::Complete)
        .map(|p| payment_to_transaction(p))
        .collect();

    let mut transactions: Vec<crate::models::Payment> = Vec::new();
    transactions.extend(received_transations?);
    transactions.extend(sent_transactions?);

    Ok(transactions)
}

// construct a lightning transaction from an invoice
fn invoice_to_transaction(
    node_pubkey: String,
    invoice: pb::Invoice,
) -> Result<crate::models::Payment> {
    let ln_invoice = parse_invoice(&invoice.bolt11)?;
    Ok(crate::models::Payment {
        payment_type: crate::models::PAYMENT_TYPE_RECEIVED.to_string(),
        payment_hash: hex::encode(invoice.payment_hash),
        payment_time: invoice.payment_time as i64,
        label: invoice.label,
        destination_pubkey: node_pubkey,
        amount_msat: amount_to_msat(invoice.amount.unwrap_or_default()) as i32,
        fees_msat: 0,
        payment_preimage: hex::encode(invoice.payment_preimage),
        keysend: false,
        bolt11: invoice.bolt11,
        pending: false,
        description: ln_invoice.description,
    })
}

// construct a lightning transaction from a payment
fn payment_to_transaction(payment: pb::Payment) -> Result<crate::models::Payment> {
    let mut description = None;
    if !payment.bolt11.is_empty() {
        description = parse_invoice(&payment.bolt11)?.description;
    }

    let payment_amount = amount_to_msat(payment.amount.unwrap_or_default()) as i32;
    let payment_amount_sent = amount_to_msat(payment.amount_sent.unwrap_or_default()) as i32;

    Ok(crate::models::Payment {
        payment_type: crate::models::PAYMENT_TYPE_SENT.to_string(),
        payment_hash: hex::encode(payment.payment_hash),
        payment_time: payment.created_at as i64,
        label: "".to_string(),
        destination_pubkey: hex::encode(payment.destination),
        amount_msat: payment_amount,
        fees_msat: payment_amount - payment_amount_sent,
        payment_preimage: hex::encode(payment.payment_preimage),
        keysend: payment.bolt11.is_empty(),
        bolt11: payment.bolt11,
        pending: pb::PayStatus::from_i32(payment.status) == Some(pb::PayStatus::Pending),
        description,
    })
}

fn amount_to_msat(amount: pb::Amount) -> u64 {
    match amount.unit {
        Some(pb::amount::Unit::Millisatoshi(val)) => val,
        Some(pb::amount::Unit::Satoshi(val)) => val * 1000,
        Some(pb::amount::Unit::Bitcoin(val)) => val * 100000000,
        Some(_) => 0,
        None => 0,
    }
}

fn parse_amount(amount_str: String) -> Result<pb::Amount> {
    let mut unit = pb::amount::Unit::Millisatoshi(0);
    if amount_str.ends_with("msat") {
        let t = amount_str.strip_suffix("msat").unwrap().to_string();
        unit = pb::amount::Unit::Millisatoshi(
            amount_str
                .strip_suffix("msat")
                .ok_or(anyhow!("wrong amount format {}", amount_str))?
                .to_string()
                .parse::<u64>()?,
        );
    } else if amount_str.ends_with("sat") {
        unit = pb::amount::Unit::Satoshi(
            amount_str
                .strip_suffix("sat")
                .ok_or(anyhow!("wrong amount format {}", amount_str))?
                .to_string()
                .parse::<u64>()?,
        );
    } else if amount_str.ends_with("bitcoin") {
        unit = pb::amount::Unit::Bitcoin(
            amount_str
                .strip_suffix("bitcoin")
                .ok_or(anyhow!("wrong amount format {}", amount_str))?
                .to_string()
                .parse::<u64>()?,
        );
    };

    Ok(pb::Amount { unit: Some(unit) })
}
