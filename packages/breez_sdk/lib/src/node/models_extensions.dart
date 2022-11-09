import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_sdk/src/node/models.dart';
import 'package:breez_sdk/src/node/node_api/models.dart';
import 'package:breez_sdk/src/storage/dao/db.dart' as db;

import '../../native_toolkit.dart';

extension NodeStateAdapter on NodeState {
  db.NodeState toDbNodeState() {
    return db.NodeState(
        nodeID: id,
        channelsBalanceMsats: channelsBalanceMsat,
        onchainBalanceMsats: onchainBalanceMsat,
        blockHeight: blockHeight,
        connectionStatus: 0, // ?
        maxAllowedToPayMsats: maxPayableMsat,
        maxAllowedToReceiveMsats: maxReceivableMsat,
        maxPaymentAmountMsats: maxSinglePaymentAmountMsat,
        maxChanReserveMsats: maxChanReserveMsats,
        connectedPeers: connectedPeers.join(","),
        maxInboundLiquidityMsats: inboundLiquidityMsats,
        onChainFeeRate: 0); // ?
  }

  static NodeState fromDbNodeState(db.NodeState dbState) {
    return NodeState(
      id: dbState.nodeID,
      channelsBalanceMsat: dbState.channelsBalanceMsats,
      onchainBalanceMsat: dbState.onchainBalanceMsats,
      blockHeight: dbState.blockHeight,
      //status: NodeStatus.values[dbState.connectionStatus],
      maxPayableMsat: dbState.maxAllowedToPayMsats,
      maxReceivableMsat: dbState.maxAllowedToReceiveMsats,
      maxSinglePaymentAmountMsat: dbState.maxPaymentAmountMsats,
      maxChanReserveMsats: dbState.maxChanReserveMsats,
      connectedPeers: dbState.connectedPeers.split(","),
      inboundLiquidityMsats: dbState.maxInboundLiquidityMsats,
    );
  }
}

extension OutgoingLightningPaymentAdapter on OutgoingLightningPayment {
  Future<db.OutgoingLightningPayment> toDbOutgoingLightningPayment() async {
    var description = "";
    if (bolt11.isNotEmpty) {
      final invoice = await getNativeToolkit().parseInvoice(invoice: bolt11);
      description = invoice.description;
    }
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
      description: description,
    );
  }

  Future<PaymentInfo> toPaymentInfo() async {
    var description = "";
    if (bolt11.isNotEmpty) {
      final invoice = await getNativeToolkit().parseInvoice(invoice: bolt11);
      description = invoice.description;
    }    
    return PaymentInfo(
            type: PaymentType.sent,
            amountMsat: amountMsats,
            destination: destination,
            shortTitle: description,
            description: description,
            feeMsat: feeMsats,
            creationTimestamp: creationTimestamp,
            pending: pending,
            keySend: isKeySend,
            paymentHash: paymentHash);
  }

  static OutgoingLightningPayment fromDbOutgoingLightningPayment(db.OutgoingLightningPayment dbPayment) {
    return OutgoingLightningPayment(
      creationTimestamp: dbPayment.createdAt,
      paymentHash: dbPayment.paymentHash,
      destination: dbPayment.destination,
      feeMsats: dbPayment.feeMsat,
      amountMsats: dbPayment.amountMsats,
      amountSentMsats: dbPayment.amountSentMsats,
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

  Future<PaymentInfo> toPaymentInfo(String thisNodeID) async {    
    return PaymentInfo(
            type: PaymentType.received,
            amountMsat: receivedMsats,
            feeMsat: 0,
            destination: thisNodeID,
            shortTitle:  description,
            creationTimestamp: paymentTime,
            pending: false,
            keySend: false,
            paymentHash: paymentHash);
  }

  static Invoice fromDbInvoice(db.Invoice dbInvoice) {
    return Invoice(
      label: dbInvoice.label,
      description: "",
      amountMsats: dbInvoice.amountMsat,
      receivedMsats: dbInvoice.receivedMsat,
      status: InvoiceStatus.values[dbInvoice.status],
      paymentTime: dbInvoice.paymentTime,
      expiryTime: dbInvoice.expiryTime,
      bolt11: dbInvoice.bolt11,
      paymentPreimage: dbInvoice.paymentPreimage,
      paymentHash: dbInvoice.paymentHash,
    );
  }
}
