import 'package:breez_sdk/src/node_api/models.dart';
import 'package:breez_sdk/src/node_api/node_api.dart';
import 'package:fixnum/fixnum.dart';

const _maxPaymentAmountMsats = 4294967000;

class LightningNode {
  final NodeAPI _nodeAPI;

  LightningNode(this._nodeAPI);

  Future<NodeState> getState() async {
    final peers = await _nodeAPI.listPeers();
    final nodeInfo = await _nodeAPI.getNodeInfo();
    final funds = await _nodeAPI.listFunds();
    return _assembleAccountState(nodeInfo, funds.channelFunds, funds.onchainFunds, peers);
  }

  Future<List<OutgoingLightningPayment>> getOutgoingPaymentsSince(DateTime since) async {
    final outgoingPayments = await _nodeAPI.getPayments();
    return outgoingPayments.where((p) => DateTime.fromMillisecondsSinceEpoch(p.creationTimestamp).isAfter(since)).toList();
  }

  Future<List<Invoice>> getIncomingPaymentsSince() async {
    final invoices = await _nodeAPI.getInvoices();
    return invoices.where((i) => i.receivedMsats > 0).toList();
  }

  Future<Invoice> requestPayment(Int64 amount, {String? description, Int64? expiry}) {
    return _nodeAPI.addInvoice(amount, description: description, expiry: expiry);
  }

  Future sendPaymentForRequest(String blankInvoicePaymentRequest, {Int64? amount}) {
    return _nodeAPI.sendPaymentForRequest(blankInvoicePaymentRequest, amount: amount);
  }
}

enum NodeStatus { connecting, connected, disconnecting, disconnected }

class NodeState {
  final String id;
  final Int64 blockheight;
  final Int64 channelsBalanceMsats;
  final Int64 onchainBalanceMsats;
  final NodeStatus status;
  final Int64 maxAllowedToPayMsats;
  final Int64 maxAllowedToReceiveMsats;
  final Int64 maxPaymentAmountMsats;
  final Int64 maxChanReserveMsats;
  final List<String> connectedPeers;
  final Int64 maxInboundLiquidityMsats;
  final Int64 onChainFeeRate;

  NodeState(
      {required this.id,
      required this.blockheight,
      required this.channelsBalanceMsats,
      required this.onchainBalanceMsats,
      required this.status,
      required this.maxAllowedToPayMsats,
      required this.maxAllowedToReceiveMsats,
      required this.maxPaymentAmountMsats,
      required this.maxChanReserveMsats,
      required this.connectedPeers,
      required this.maxInboundLiquidityMsats,
      required this.onChainFeeRate});
}

NodeState _assembleAccountState(
    NodeInfo nodeInfo, List<ListFundsChannel> offChainFunds, List<ListFundsOutput> onChainFunds, List<Peer> peers) {
  var channelsBalance = offChainFunds.fold<Int64>(Int64(0), (balance, element) => balance + element.ourAmountMsat);

  // calculate the on-chain balance
  var walletBalance = onChainFunds.fold<Int64>(Int64(0), (balance, element) => balance + element.amountMsats);

  // assemble the peers list and channels list.
  var channels = List<Channel>.empty(growable: true);
  List<String> peersList = List<String>.empty(growable: true);
  for (var p in peers) {
    peersList.add(p.id);
    channels.addAll(p.channels);
  }

  // calculate the account status based on the channels status.
  bool hasActive = channels.any((c) => c.state == ChannelState.OPEN);
  bool hasPendingOpen = channels.any((c) => c.state == ChannelState.PENDING_OPEN);
  bool hasPendingClose = channels.any((c) => c.state == ChannelState.PENDING_CLOSED);

  NodeStatus accStatus = NodeStatus.disconnected;
  if (hasActive) {
    accStatus = NodeStatus.connected;
  } else if (hasPendingOpen) {
    accStatus = NodeStatus.connecting;
  } else if (hasPendingClose) {
    accStatus = NodeStatus.disconnecting;
  }

  // calculate incoming and outgoing liquidity
  Int64 maxPayable = Int64(0);
  Int64 maxReceivable = Int64(0);
  Int64 maxReceivableSingleChannel = Int64(0);
  for (var c in channels) {
    maxPayable += c.spendable;
    Int64 channelReceivable = Int64(c.receivable);
    if (channelReceivable > maxReceivableSingleChannel) {
      maxReceivableSingleChannel = channelReceivable;
    }
    maxReceivable += channelReceivable;
  }

  // return the new account state
  return NodeState(
    blockheight: Int64(nodeInfo.blockheight),
    id: nodeInfo.nodeID,
    channelsBalanceMsats: channelsBalance,
    onchainBalanceMsats: walletBalance,
    status: accStatus,
    maxAllowedToPayMsats: maxPayable,
    maxAllowedToReceiveMsats: maxReceivable,
    maxPaymentAmountMsats: Int64(_maxPaymentAmountMsats),
    maxChanReserveMsats: channelsBalance - maxPayable,
    connectedPeers: peersList,
    onChainFeeRate: Int64(0),
    maxInboundLiquidityMsats: maxReceivableSingleChannel,
  );
}
