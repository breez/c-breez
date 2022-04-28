import 'package:c_breez/repositorires/dao/db.dart' as db;
import 'package:c_breez/services/lightning/models.dart';

extension NodeInfoAdapter on NodeInfo {
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

extension PeerAdapter on Peer {
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

extension ChannelFundsAdapter on ListFundsChannel {
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

extension OnchainFundsAdapter on ListFundsOutput {
  db.OnChainFund toDbOnchainFund() {
    return db.OnChainFund(
      txid: outpoint.txid,
      outnum: outpoint.outnum,
      amountMsat: amount.toInt(),
      address: address,
      outputStatus: status.index,
    );
  }
}

extension OutgoingLightningPaymentAdapter on OutgoingLightningPayment {
  db.OutgoingLightningPayment toDbOutgoingLightningPayment() {
    return db.OutgoingLightningPayment(
      createdAt: creationTimestamp,
      paymentHash: paymentHash,
      destination: destination,
      feeMsat: fee.toInt(),
      amount: amount.toInt(),
      amountSent: amountSent.toInt(),
      preimage: preimage,
      isKeySend: isKeySend,
      pending: pending,
      bolt11: bolt11,
    );
  }
}

extension InvoiceAdapter on Invoice {
  db.Invoice toDbInvoice() {
    return db.Invoice(
      label: label,
      amountMsat: amountSats.toInt() * 1000,
      receivedMsat: received.toInt() * 1000,
      status: status.index,
      paymentTime: paymentTime,
      expiryTime: expiryTime,
      bolt11: bolt11,
      paymentPreimage: paymentPreimage,
      paymentHash: paymentHash,
    );
  }
}
