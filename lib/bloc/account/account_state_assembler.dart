import 'package:breez_sdk/sdk.dart' as breez_sdk;
import 'package:c_breez/bloc/account/payments_state.dart';
import 'package:fixnum/fixnum.dart';
import 'account_bloc.dart';
import 'account_state.dart';

// assembleAccountState assembles the account state using the local synchronized data.
AccountState? assembleAccountState(List<breez_sdk.PaymentInfo> payments, breez_sdk.PaymentFilter paymentsFilter, breez_sdk.NodeState? nodeState) {
  if (nodeState == null) {
    return null;
  }

  // return the new account state
  return AccountState(
    initial: false,
    blockheight: nodeState.blockheight,
    id: nodeState.id,
    balance: Int64(nodeState.channelsBalanceMsats.toInt() ~/ 1000),
    walletBalance: Int64(nodeState.onchainBalanceMsats.toInt() ~/ 1000),
    status: AccountStatus.values[nodeState.status.index],
    maxAllowedToPay: Int64(nodeState.maxAllowedToPayMsats.toInt() ~/ 1000),
    maxAllowedToReceive: Int64(nodeState.maxAllowedToReceiveMsats.toInt() ~/ 1000),
    maxPaymentAmount: Int64(maxPaymentAmount),
    maxChanReserve: Int64( (nodeState.channelsBalanceMsats.toInt() - nodeState.maxAllowedToPayMsats.toInt()) ~/ 1000),
    connectedPeers: nodeState.connectedPeers,
    onChainFeeRate: Int64(0),
    maxInboundLiquidity: Int64(nodeState.maxInboundLiquidityMsats.toInt() ~/ 1000),
    payments: PaymentsState(payments, paymentsFilter, null),
  );
}