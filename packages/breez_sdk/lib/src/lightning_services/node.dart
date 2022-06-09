import 'package:breez_sdk/src/node_api/models.dart';
import 'package:breez_sdk/src/node_api/node_api.dart';
import 'package:fixnum/fixnum.dart';

const _maxPaymentAmount = 4294967;

class LightningNode {

  final NodeAPI _nodeAPI;

  LightningNode(this._nodeAPI);

  Future<NodeState> getAccountState() async {
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
    return _nodeAPI.sendPaymentForRequest(blankInvoicePaymentRequest, amount:amount);
  }
}

enum NodeStatus { connecting, connected, disconnecting, disconnected }

class NodeState {
  final String id;  
  final Int64 blockheight;
  final Int64 balance;
  final Int64 walletBalance;
  final NodeStatus status;
  final Int64 maxAllowedToPay;
  final Int64 maxAllowedToReceive;
  final Int64 maxPaymentAmount;
  final Int64 maxChanReserve;
  final List<String> connectedPeers;
  final Int64 maxInboundLiquidity;
  final Int64 onChainFeeRate;

  NodeState({required this.id, required this.blockheight, required this.balance, required this.walletBalance, required this.status, required this.maxAllowedToPay, required this.maxAllowedToReceive, required this.maxPaymentAmount, required this.maxChanReserve, required this.connectedPeers, required this.maxInboundLiquidity, required this.onChainFeeRate});  
}

NodeState _assembleAccountState(NodeInfo nodeInfo,
    List<ListFundsChannel> offChainFunds, List<ListFundsOutput> onChainFunds, List<Peer> peers) {
  var channelsBalance = offChainFunds.fold<Int64>(Int64(0), (balance, element) => balance + element.ourAmountMsat) ~/ 1000;

  // calculate the on-chain balance  
  var walletBalance = onChainFunds.fold<Int64>(Int64(0), (balance, element) => balance + element.amountMsats) ~/ 1000;


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
    maxPayable += c.spendable ~/ 1000;
    Int64 channelReceivable = Int64(c.receivable ~/ 1000);
    if (channelReceivable > maxReceivableSingleChannel) {
      maxReceivableSingleChannel = channelReceivable;
    }
    maxReceivable += channelReceivable;
  }

  // return the new account state
  return NodeState(    
    blockheight: Int64(nodeInfo.blockheight),
    id: nodeInfo.nodeID,
    balance: channelsBalance,
    walletBalance: walletBalance,
    status: accStatus,
    maxAllowedToPay: maxPayable,
    maxAllowedToReceive: maxReceivable,
    maxPaymentAmount: Int64(_maxPaymentAmount),
    maxChanReserve: channelsBalance - maxPayable,
    connectedPeers: peersList,
    onChainFeeRate: Int64(0),
    maxInboundLiquidity: maxReceivableSingleChannel,    
  );
}