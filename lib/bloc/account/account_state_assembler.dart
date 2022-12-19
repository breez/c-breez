import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/bloc/account/payment_filters.dart';

import 'account_bloc.dart';
import 'account_state.dart';

// assembleAccountState assembles the account state using the local synchronized data.
AccountState? assembleAccountState(
  List<Payment> payments,
  PaymentFilters paymentFilters,
  NodeState? nodeState,
) {
  if (nodeState == null) {
    return null;
  }

  // return the new account state
  return AccountState(
    id: nodeState.id,
    initial: false,
    blockheight: nodeState.blockHeight,
    balance: nodeState.channelsBalanceMsat.toInt() ~/ 1000,
    walletBalance: nodeState.onchainBalanceMsat ~/ 1000,
    maxAllowedToPay: nodeState.maxPayableMsat ~/ 1000,
    maxAllowedToReceive: nodeState.maxReceivableMsat ~/ 1000,
    maxPaymentAmount: maxPaymentAmount,
    maxChanReserve: (nodeState.channelsBalanceMsat.toInt() -
            nodeState.maxPayableMsat.toInt()) ~/
        1000,
    connectedPeers: nodeState.connectedPeers,
    onChainFeeRate: 0,
    maxInboundLiquidity: nodeState.inboundLiquidityMsats ~/ 1000,
    payments: payments,
    paymentFilters: paymentFilters,
    status: ConnectionStatus.CONNECTED,
  );
}
