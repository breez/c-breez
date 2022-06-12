import 'package:c_breez/bloc/account/payments_state.dart';
import 'package:c_breez/models/payment_filter.dart';
import 'package:c_breez/models/payment_info.dart';
import 'package:fixnum/fixnum.dart';
import 'package:c_breez/repositories/dao/db.dart' as db;
import 'account_bloc.dart';
import 'account_state.dart';

// assembleAccountState assembles the account state using the local synchronized data.
AccountState? assembleAccountState(List<PaymentInfo> payments, PaymentFilterModel paymentsFilter, db.NodeState? nodeState) {
  if (nodeState == null) {
    return null;
  }

  // return the new account state
  return AccountState(
    initial: false,
    blockheight: Int64(nodeState.blockHeight),
    id: nodeState.nodeID,
    balance: Int64(nodeState.channelsBalanceMsats ~/ 1000),
    walletBalance: Int64(nodeState.onchainBalanceMsats ~/ 1000),
    status: AccountStatus.values[nodeState.connectionStatus],
    maxAllowedToPay: Int64(nodeState.maxAllowedToPayMsats ~/ 1000),
    maxAllowedToReceive: Int64(nodeState.maxAllowedToReceiveMsats ~/ 1000),
    maxPaymentAmount: Int64(maxPaymentAmount),
    maxChanReserve: Int64( (nodeState.channelsBalanceMsats - nodeState.maxAllowedToPayMsats) ~/ 1000),
    connectedPeers: nodeState.connectedPeers.split(","),
    onChainFeeRate: Int64(0),
    maxInboundLiquidity: Int64(nodeState.maxInboundLiquidityMsats ~/ 1000),
    payments: PaymentsState(payments, _filterPayments(payments, paymentsFilter), paymentsFilter, null),
  );
}

List<PaymentInfo> _filterPayments(List<PaymentInfo> paymentsList, PaymentFilterModel filter) {
  return paymentsList.where((p) {
    if (!filter.paymentType.contains(p.type)) {
      return false;
    }
    if (filter.startDate != null && p.creationTimestamp.toInt() * 1000 < filter.startDate!.millisecondsSinceEpoch) {
      return false;
    }
    if (filter.endDate != null && p.creationTimestamp.toInt() * 1000 > filter.endDate!.millisecondsSinceEpoch) {
      return false;
    }
    return true;
  }).toList();
}
