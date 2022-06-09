import 'package:c_breez/repositories/dao/db.dart' as db;
import 'package:breez_sdk/sdk.dart' as lntoolkit;

extension NodeInfoAdapter on lntoolkit.NodeInfo {
  db.NodeInfo toDbNodeInfo() {
    return db.NodeInfo(
        db.Node(
            nodeID: nodeID,
            nodeAlias: nodeAlias,
            numPeers: numPeers,
            blockheight: blockheight,
            version: version,
            network: network),
        addresses
            .map((a) => db.NodeAddresse(
                id: 0,
                type: a.type.index,
                addr: a.addr,
                port: a.port,
                nodeId: nodeID))
            .toList());
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

extension ChannelFundsAdapter on lntoolkit.ListFundsChannel {
  db.OffChainFund toDbOffchainFund() {
    return db.OffChainFund(
      peerId: peerId,
      connected: connected,
      shortChannelId: shortChannelId.toInt(),
      ourAmountMsat: ourAmountMsat.toInt(),
      amountMsat: amountMsat.toInt(),
      fundingTxid: fundingTxid,
      fundingOutput: fundingOutput,
    );
  }
}

extension OnchainFundsAdapter on lntoolkit.ListFundsOutput {
  db.OnChainFund toDbOnchainFund() {
    return db.OnChainFund(
      txid: outpoint.txid,
      outnum: outpoint.outnum,
      amountMsat: amountMsats.toInt(),
      address: address,
      outputStatus: status.index,
    );
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
