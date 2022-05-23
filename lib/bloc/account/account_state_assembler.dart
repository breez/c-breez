import 'package:c_breez/models/payment_info.dart';
import 'package:fixnum/fixnum.dart';
import 'package:c_breez/models/account.dart';
import 'package:c_breez/repositories/dao/db.dart' as db;
import 'account_bloc.dart';
import 'account_state.dart';

// assembleAccountState assembles the account state using the local synchronized data.
AccountState? assembleAccountState(List<PaymentInfo> payments, PaymentFilterModel paymentsFilter, db.NodeInfo? nodeInfo,
    List<db.OffChainFund> offChainFunds, List<db.OnChainFund> onChainFunds, List<db.PeerWithChannels> peers) {
  var channelsBalance = offChainFunds.fold<Int64>(Int64(0), (balance, element) => balance + element.ourAmountMsat) ~/ 1000;

  // calculate the on-chain balance
  var walletBalance = onChainFunds.fold<Int64>(Int64(0), (balance, element) => balance + element.amountMsat) ~/ 1000;


  // assemble the peers list and channels list.
  var channels = List<db.Channel>.empty(growable: true);
  List<String> peersList = List<String>.empty(growable: true);
  for (var p in peers) {
    peersList.add(p.peer.peerId);
    channels.addAll(p.channels);
  }

  // calculate the account status based on the channels status.
  bool hasActive = channels.any((c) => c.channelState == db.ChannelState.OPEN.index);
  bool hasPendingOpen = channels.any((c) => c.channelState == db.ChannelState.PENDING_OPEN.index);
  bool hasPendingClose = channels.any((c) => c.channelState == db.ChannelState.PENDING_CLOSED.index);

  AccountStatus accStatus = AccountStatus.DISCONNECTED;
  if (hasActive) {
    accStatus = AccountStatus.CONNECTED;
  } else if (hasPendingOpen) {
    accStatus = AccountStatus.CONNECTING;
  } else if (hasPendingClose) {
    accStatus = AccountStatus.DISCONNECTION;
  }

  // calculate incoming and outgoing liquidity
  Int64 maxPayable = Int64(0);
  Int64 maxReceivable = Int64(0);
  Int64 maxReceivableSingleChannel = Int64(0);
  for (var c in channels) {
    maxPayable += c.spendableMsat ~/ 1000;
    Int64 channelReceivable = Int64(c.receivableMsat ~/ 1000);
    if (channelReceivable > maxReceivableSingleChannel) {
      maxReceivableSingleChannel = channelReceivable;
    }
    maxReceivable += channelReceivable;
  }

  if (nodeInfo == null) {
    return null;
  }

  // return the new account state
  return AccountState(
    initial: false,
    blockheight: Int64(nodeInfo.node.blockheight),
    id: nodeInfo.node.nodeID,
    balance: channelsBalance,
    walletBalance: walletBalance,
    status: accStatus,
    maxAllowedToPay: maxPayable,
    maxAllowedToReceive: maxReceivable,
    maxPaymentAmount: Int64(maxPaymentAmount),
    maxChanReserve: channelsBalance - maxPayable,
    connectedPeers: peersList,
    onChainFeeRate: Int64(0),
    maxInboundLiquidity: maxReceivableSingleChannel,
    payments: PaymentsState(payments, _filterPayments(payments, paymentsFilter), paymentsFilter, null),
  );
}

List<PaymentInfo> _filterPayments(List<PaymentInfo> paymentsList, PaymentFilterModel filter) {
  return paymentsList.where((p) {
    if (!filter.paymentType.contains(p.type)) {
      return false;
    }
    if (filter.startDate != null && p.creationTimestamp!.toInt() * 1000 < filter.startDate!.millisecondsSinceEpoch) {
      return false;
    }
    if (filter.endDate != null && p.creationTimestamp!.toInt() * 1000 > filter.endDate!.millisecondsSinceEpoch) {
      return false;
    }
    return true;
  }).toList();
}
