import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_sdk/sdk.dart' as breez_sdk;

import 'account_bloc.dart';
import 'account_state.dart';

// assembleAccountState assembles the account state using the local synchronized data.
AccountState? assembleAccountState(breez_sdk.PaymentsState payments, breez_sdk.PaymentFilter paymentsFilter, NodeState? nodeState) {
  if (nodeState == null) {
    return null;
  }

  // return the new account state
  return AccountState(
    initial: false,
    blockheight: nodeState.blockHeight,
    id: nodeState.id,
    balance: nodeState.channelsBalanceMsat.toInt() ~/ 1000,
    walletBalance: nodeState.onchainBalanceMsat ~/ 1000,
    status: AccountStatus.values[1], //AccountStatus.values[nodeState.status.index],
    maxAllowedToPay: nodeState.maxPayableMsat ~/ 1000,
    maxAllowedToReceive: nodeState.maxReceivableMsat ~/ 1000,
    maxPaymentAmount: maxPaymentAmount,
    maxChanReserve: (nodeState.channelsBalanceMsat.toInt() - nodeState.maxPayableMsat.toInt()) ~/ 1000,
    connectedPeers: nodeState.connectedPeers,
    onChainFeeRate: 0,
    maxInboundLiquidity: nodeState.inboundLiquidityMsats ~/ 1000,
    payments: payments,
  );
}