use crate::invoice::parse_invoice;
use crate::models::{LightningTransaction, NodeAPI, NodeState, SyncResponse};
use anyhow::Result;
use gl_client::{node, pb};
use hex;
use std::cmp::max;

const MAX_PAYMENT_AMOUNT_MSAT: u64 = 4294967000;
const MAX_INBOUND_LIQUIDITY_MSAT: u64 = 4000000000;

pub(crate) struct Greenlight {
    client: node::Client,
}

impl Greenlight {
    pub(crate) fn from_client(client: node::Client) -> Greenlight {
        Greenlight { client }
    }
}

#[tonic::async_trait]
impl NodeAPI for Greenlight {
    // implemenet pull changes from greenlight
    async fn pull_changed(&self, since_timestamp: i64) -> Result<SyncResponse> {
        let client = &mut self.client.clone();

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
            .filter(|c| {
                let open_chan_statuses = vec![
                    String::from("CHANNELD_AWAITING_LOCKIN"),
                    String::from("DUALOPEND_OPEN_INIT"),
                    String::from("DUALOPEND_AWAITING_LOCKIN"),
                ];
                return open_chan_statuses.contains(&c.state);
            })
            .collect();

        // calculate channels balance only from opened channels
        let channels_balance = offchain_funds.iter().fold(0, |a, b| {
            let hex_txid = hex::encode(b.funding_txid.clone());
            if opened_channels.iter().any(|c| c.funding_txid == hex_txid) {
                return a + b.amount_msat;
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
            max_chan_reserve_msats: channels_balance - max_payable,
            connected_peers: connected_peers,
            inbound_liquidity_msats: max_receivable_single_channel,
        };
        Ok(SyncResponse {
            node_state,
            transactions: pull_transactions(
                node_pubkey.clone(),
                since_timestamp,
                self.client.clone(),
            )
            .await?,
        })
    }
}

// pulls transactions from greenlight based on last sync timestamp.
// greenlight gives us the payments via API and for received payments we are looking for settled invoices.
async fn pull_transactions(
    node_pubkey: String,
    since_timestamp: i64,
    client: node::Client,
) -> Result<Vec<LightningTransaction>> {
    let mut c = client.clone();

    // list invoices
    let invoices = c
        .list_invoices(pb::ListInvoicesRequest::default())
        .await?
        .into_inner();

    // construct the received transactions by filtering the invoices to those paid and beyond the filter timestamp
    let received_transations: Result<Vec<LightningTransaction>> = invoices
        .invoices
        .into_iter()
        .filter(|i| i.payment_time as i64 >= since_timestamp)
        .map(|i| invoice_to_transaction(node_pubkey.clone(), i))
        .collect();

    // fetch payments from greenlight
    let payments = c
        .list_payments(pb::ListPaymentsRequest::default())
        .await?
        .into_inner();

    // construct the payment transactions
    let sent_transactions: Result<Vec<LightningTransaction>> = payments
        .payments
        .into_iter()
        .filter(|p| p.created_at as i64 >= since_timestamp)
        .map(|p| payment_to_transaction(p))
        .collect();

    let mut transactions: Vec<LightningTransaction> = Vec::new();
    transactions.extend(received_transations?);
    transactions.extend(sent_transactions?);

    Ok(transactions)
}

// construct a lightning transaction from an invoice
fn invoice_to_transaction(
    node_pubkey: String,
    invoice: pb::Invoice,
) -> Result<LightningTransaction> {
    let ln_invoice = parse_invoice(&invoice.bolt11)?;
    Ok(LightningTransaction {
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
        description: Some(ln_invoice.description),
    })
}

// construct a lightning transaction from a payment
fn payment_to_transaction(payment: pb::Payment) -> Result<LightningTransaction> {
    let mut description = None;
    if !payment.bolt11.is_empty() {
        description = Some(parse_invoice(&payment.bolt11)?.description);
    }

    let payment_amount = amount_to_msat(payment.amount.unwrap_or_default()) as i32;
    let payment_amount_sent = amount_to_msat(payment.amount_sent.unwrap_or_default()) as i32;

    Ok(LightningTransaction {
        payment_type: crate::models::PAYMENT_TYPE_SENT.to_string(),
        payment_hash: hex::encode(payment.payment_hash),
        payment_time: payment.created_at as i64,
        label: "".to_string(),
        destination_pubkey: hex::encode(payment.destination),
        amount_msat: payment_amount,
        fees_msat: payment_amount - payment_amount_sent,
        payment_preimage: hex::encode(payment.payment_preimage),
        keysend: !payment.bolt11.is_empty(),
        bolt11: payment.bolt11,
        pending: pb::PayStatus::from_i32(payment.status) == Some(pb::PayStatus::Pending),
        description: description,
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
    if amount_str.ends_with("sat") {
        unit = pb::amount::Unit::Satoshi(
            amount_str
                .strip_prefix("sat")
                .unwrap()
                .to_string()
                .parse::<u64>()?,
        );
    } else if amount_str.ends_with("msat") {
        unit = pb::amount::Unit::Millisatoshi(
            amount_str
                .strip_prefix("msat")
                .unwrap()
                .to_string()
                .parse::<u64>()?,
        );
    } else if amount_str.ends_with("bitcoin") {
        unit = pb::amount::Unit::Bitcoin(
            amount_str
                .strip_prefix("bitcoin")
                .unwrap()
                .to_string()
                .parse::<u64>()?,
        );
    };

    Ok(pb::Amount { unit: Some(unit) })
}

// Int64 _amountStringToMsat(String amount) {
//  if (amount.endsWith("msat")) {
//    return Int64.parseInt(amount.replaceAll("msat", ""));
//  }
//  if (amount.endsWith("sat")) {
//    return Int64.parseInt(amount.replaceAll("sat", "")) * 1000;
//  }
//  if (amount.isEmpty) {
//    return Int64.ZERO;
//  }