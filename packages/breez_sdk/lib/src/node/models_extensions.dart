import 'package:breez_sdk/src/node/models.dart';
import 'package:breez_sdk/src/node/node_api/models.dart';
import 'package:breez_sdk/src/storage/dao/db.dart' as db;
import 'package:fixnum/fixnum.dart';

import '../native_toolkit.dart';

extension NodeStateAdapter on NodeState {
  db.NodeState toDbNodeState() {
    return db.NodeState(
        nodeID: id,
        channelsBalanceMsats: channelsBalanceMsats.toInt(),
        onchainBalanceMsats: onchainBalanceMsats.toInt(),
        blockHeight: blockheight.toInt(),
        connectionStatus: status.index,
        maxAllowedToPayMsats: maxAllowedToPayMsats.toInt(),
        maxAllowedToReceiveMsats: maxAllowedToReceiveMsats.toInt(),
        maxPaymentAmountMsats: maxPaymentAmountMsats.toInt(),
        maxChanReserveMsats: maxChanReserveMsats.toInt(),
        connectedPeers: connectedPeers.join(","),
        maxInboundLiquidityMsats: maxInboundLiquidityMsats.toInt(),
        onChainFeeRate: onChainFeeRate.toInt());
  }

  static NodeState fromDbNodeState(db.NodeState dbState) {
    return NodeState(
      id: dbState.nodeID,
      channelsBalanceMsats: Int64(dbState.channelsBalanceMsats),
      onchainBalanceMsats: Int64(dbState.onchainBalanceMsats),
      blockheight: Int64(dbState.blockHeight),
      status: NodeStatus.values[dbState.connectionStatus],
      maxAllowedToPayMsats: Int64(dbState.maxAllowedToPayMsats),
      maxAllowedToReceiveMsats: Int64(dbState.maxAllowedToReceiveMsats),
      maxPaymentAmountMsats: Int64(dbState.maxPaymentAmountMsats),
      maxChanReserveMsats: Int64(dbState.maxChanReserveMsats),
      connectedPeers: dbState.connectedPeers.split(","),
      maxInboundLiquidityMsats: Int64(dbState.maxInboundLiquidityMsats),
      onChainFeeRate: Int64(dbState.onChainFeeRate),
    );
  }
}

extension OutgoingLightningPaymentAdapter on OutgoingLightningPayment {
  Future<db.OutgoingLightningPayment> toDbOutgoingLightningPayment() async {
    final invoice = await getNativeToolkit().parseInvoice(invoice: bolt11);
    return db.OutgoingLightningPayment(
      createdAt: creationTimestamp,
      paymentHash: paymentHash,
      destination: destination,
      feeMsat: feeMsats.toInt(),
      amountMsats: amountMsats.toInt(),
      amountSentMsats: amountSentMsats.toInt(),
      preimage: preimage,
      isKeySend: isKeySend,
      pending: pending,
      bolt11: bolt11,
      description: invoice.description,
    );
  }

  static OutgoingLightningPayment fromDbOutgoingLightningPayment(db.OutgoingLightningPayment dbPayment) {
    return OutgoingLightningPayment(
      creationTimestamp: dbPayment.createdAt,
      paymentHash: dbPayment.paymentHash,
      destination: dbPayment.destination,
      feeMsats: Int64(dbPayment.feeMsat),
      amountMsats: Int64(dbPayment.amountMsats),
      amountSentMsats: Int64(dbPayment.amountSentMsats),
      preimage: dbPayment.preimage,
      isKeySend: dbPayment.isKeySend,
      pending: dbPayment.pending,
      bolt11: dbPayment.bolt11,
    );
  }
}

extension InvoiceAdapter on Invoice {  
  db.Invoice toDbInvoice() {        
    return db.Invoice(      
      label: label,      
      amountMsat: amountMsats.toInt(),
      receivedMsat: receivedMsats.toInt(),
      status: status.index,
      paymentTime: paymentTime,
      expiryTime: expiryTime,
      bolt11: bolt11,
      description: description,
      paymentPreimage: paymentPreimage,
      paymentHash: paymentHash,
    );
  }

  static Invoice fromDbInvoice(db.Invoice dbInvoice) {
    return Invoice(
      label: dbInvoice.label,
      description: "",
      amountMsats: Int64(dbInvoice.amountMsat),
      receivedMsats: Int64(dbInvoice.receivedMsat),
      status: InvoiceStatus.values[dbInvoice.status],
      paymentTime: dbInvoice.paymentTime,
      expiryTime: dbInvoice.expiryTime,
      bolt11: dbInvoice.bolt11,
      paymentPreimage: dbInvoice.paymentPreimage,
      paymentHash: dbInvoice.paymentHash,
    );
  }
}
