import 'package:c_breez/repositories/dao/db.dart' as db;
import 'package:breez_sdk/sdk.dart' as lntoolkit;

extension NodeStateAdapter on lntoolkit.NodeState {
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
}

extension PeerAdapter on lntoolkit.Peer {
  db.PeerWithChannels toDbPeer() {
    return db.PeerWithChannels(
        db.Peer(peerId: id, connected: connected, features: features),
        channels
            .map((c) => db.Channel(
                  channelState: c.state.index,
                  shortChannelId: c.shortChannelId,
                  direction: c.direction,
                  channelId: c.channelId,
                  fundingTxid: c.fundingTxid,
                  closeToAddr: c.closeToAddr,
                  closeTo: c.closeTo,
                  private: c.private,
                  totalMsat: c.total,
                  dustLimitMsat: c.dustLimit,
                  spendableMsat: c.spendable,
                  receivableMsat: c.receivable,
                  theirToSelfDelay: c.theirToSelfDelay,
                  ourToSelfDelay: c.ourToSelfDelay,
                  peerId: id,
                ))
            .toList());
  }
}

extension OutgoingLightningPaymentAdapter on lntoolkit.OutgoingLightningPayment {
  db.OutgoingLightningPayment toDbOutgoingLightningPayment() {
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
    );
  }
}

extension InvoiceAdapter on lntoolkit.Invoice {
  db.Invoice toDbInvoice() {
    return db.Invoice(
      label: label,
      amountMsat: amountMsats.toInt(),
      receivedMsat: receivedMsats.toInt(),
      status: status.index,
      paymentTime: paymentTime,
      expiryTime: expiryTime,
      bolt11: bolt11,
      paymentPreimage: paymentPreimage,
      paymentHash: paymentHash,
    );
  }
}
