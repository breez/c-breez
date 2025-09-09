import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/payment_filters.dart';
import 'package:c_breez/models/payment_minutiae.dart';
import 'package:c_breez/utils/constants/app_constants.dart';
import 'package:flutter/foundation.dart';

import 'account_state.dart';

// assembleAccountState assembles the account state using the local synchronized data.
AccountState? assembleAccountState(
  List<Payment> payments,
  PaymentFilters paymentFilters,
  NodeState? nodeState,
  AccountState state,
) {
  if (nodeState == null) {
    return null;
  }

  final texts = getSystemAppLocalizations();

  // Convert payments to PaymentMinutiae
  final newPayments = payments.map((e) => PaymentMinutiae.fromPayment(e, texts)).toList();

  // Calculate all the new values
  final newId = nodeState.id;
  final newBlockheight = nodeState.blockHeight;
  final newBalanceSat = nodeState.channelsBalanceMsat.toInt() ~/ 1000;
  final newWalletBalanceSat = nodeState.onchainBalanceMsat.toInt() ~/ 1000;
  final newMaxAllowedToPaySat = nodeState.maxPayableMsat.toInt() ~/ 1000;
  final newMaxAllowedToReceiveSat = nodeState.maxReceivableMsat.toInt() ~/ 1000;
  final newMaxPaymentAmountSat = PaymentConstants.maxPaymentAmountSat;
  final newMaxChanReserveSat =
      (nodeState.channelsBalanceMsat.toInt() - nodeState.maxPayableMsat.toInt()) ~/ 1000;
  final newConnectedPeers = nodeState.connectedPeers;
  final newMaxInboundLiquiditySat = nodeState.totalInboundLiquidityMsats.toInt() ~/ 1000;

  // Check if anything actually changed before creating a new state
  if (state.id == newId &&
      state.blockheight == newBlockheight &&
      state.balanceSat == newBalanceSat &&
      state.walletBalanceSat == newWalletBalanceSat &&
      state.maxAllowedToPaySat == newMaxAllowedToPaySat &&
      state.maxAllowedToReceiveSat == newMaxAllowedToReceiveSat &&
      state.maxPaymentAmountSat == newMaxPaymentAmountSat &&
      state.maxChanReserveSat == newMaxChanReserveSat &&
      listEquals(state.connectedPeers, newConnectedPeers) &&
      state.maxInboundLiquiditySat == newMaxInboundLiquiditySat &&
      listEquals(state.payments, newPayments) &&
      state.paymentFilters == paymentFilters &&
      !state.initial) {
    // Nothing changed, return the existing state
    return state;
  }

  // Something changed, create a new state
  return state.copyWith(
    id: newId,
    initial: false,
    blockheight: newBlockheight,
    balanceSat: newBalanceSat,
    walletBalanceSat: newWalletBalanceSat,
    maxAllowedToPaySat: newMaxAllowedToPaySat,
    maxAllowedToReceiveSat: newMaxAllowedToReceiveSat,
    maxPaymentAmountSat: newMaxPaymentAmountSat,
    maxChanReserveSat: newMaxChanReserveSat,
    connectedPeers: newConnectedPeers,
    maxInboundLiquiditySat: newMaxInboundLiquiditySat,
    payments: newPayments,
    paymentFilters: paymentFilters,
    verificationStatus: state.verificationStatus,
  );
}
