// _paymentsStream subscribes to local storage changes and exposes a stream of both incoming and outgoing payments.
import 'dart:math';

import 'package:breez_sdk/src/node/models.dart';
import 'package:breez_sdk/src/node/models_extensions.dart';
import 'package:breez_sdk/src/node/node_api/node_api.dart';
import 'package:breez_sdk/src/node/node_service.dart';
import 'package:breez_sdk/src/storage/storage.dart';
import 'package:fimber/fimber.dart';
import 'package:fixnum/fixnum.dart';

import 'node_api/models.dart';

final _log = FimberLog("GreenlightService");

class NodeStateSyncer {

  final NodeAPI _nodeAPI;
  final Storage _stroage;

  NodeStateSyncer(this._nodeAPI, this._stroage);  

  // Sync  
  Future syncState() async {
    await _syncNodeInfo();
    await _syncOutgoingPayments();
    await _syncSettledInvoices();
  }

  Future _syncNodeInfo() async {
    _log.i("_syncNodeState started");
    final peers = await _nodeAPI.listPeers();
    final nodeInfo = await _nodeAPI.getNodeInfo();
    final funds = await _nodeAPI.listFunds();
    final state = _assembleAccountState(nodeInfo, funds.channelFunds, funds.onchainFunds, peers);

    await _stroage.setNodeState(state.toDbNodeState());
    _log.i("_syncNodeState finished");
  }

  Future _syncOutgoingPayments() async {
    _log.i("_syncOutgoingPayments");
    var outgoingPayments = await _nodeAPI.getPayments();
    await _stroage.addOutgoingPayments(outgoingPayments.map((p) => p.toDbOutgoingLightningPayment()).toList());
    _log.i("_syncOutgoingPayments finished");
  }

  Future _syncSettledInvoices() async {
    _log.i("_syncSettledInvoices started");
    var invoices = await _nodeAPI.getInvoices();
    await _stroage.addIncomingPayments(invoices.map((p) => p.toDbInvoice()).toList());
    _log.i("_syncSettledInvoices finished");
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
    Int64 maxReceivableSingleChannel = Int64(0);
    for (var c in channels) {
      maxPayable += c.spendable;
      Int64 channelReceivable = Int64(c.receivable);
      if (channelReceivable > maxReceivableSingleChannel) {
        maxReceivableSingleChannel = channelReceivable;
      }
    }

    final maxAllowedToReceiveMsats = max(maxInboundLiquidityMsats - channelsBalance.toInt(), 0);

    // return the new account state
    return NodeState(
      blockheight: Int64(nodeInfo.blockheight),
      id: nodeInfo.nodeID,
      channelsBalanceMsats: channelsBalance,
      onchainBalanceMsats: walletBalance,
      status: accStatus,
      maxAllowedToPayMsats: maxPayable,
      maxAllowedToReceiveMsats: Int64(maxAllowedToReceiveMsats),
      maxPaymentAmountMsats: Int64(maxPaymentAmountMsats),
      maxChanReserveMsats: channelsBalance - maxPayable,
      connectedPeers: peersList,
      onChainFeeRate: Int64(0),
      maxInboundLiquidityMsats: maxReceivableSingleChannel,
    );
  }
}
