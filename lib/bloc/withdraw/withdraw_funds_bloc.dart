import 'dart:async';

import 'package:breez_sdk/breez_bridge.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/bloc/withdraw/withdraw_funds_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class WithdrawFundsBloc extends Cubit<WithdrawFudsState> {
  final BreezBridge _breezLib;

  WithdrawFundsBloc(
    this._breezLib,
  ) : super(WithdrawFudsState.initial());

  Future fetchTransactionConst() async {
    throw Exception("not implemented");
    /*
    final recommendedFees = await _breezLib.fetchRecommendedFees();
    emit(WithdrawFudsState.info(
      TransactionCost(const Duration(minutes: 10), recommendedFees.fastestFee),
      TransactionCost(const Duration(minutes: 30), recommendedFees.halfHourFee),
      TransactionCost(const Duration(minutes: 60), recommendedFees.hourFee),
    ));
     */
  }

  Future<void> sweepAllCoins(
      String toAddress, FeeratePreset feeratePreset) async {
    await _breezLib.sweep(toAddress: toAddress, feeratePreset: feeratePreset);
  }
}
