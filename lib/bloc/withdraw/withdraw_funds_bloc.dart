import 'dart:async';

import 'package:breez_sdk/breez_bridge.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/bloc/withdraw/withdraw_funds_state.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:fimber/fimber.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

final _log = FimberLog("WithdrawFundsBloc");

class WithdrawFundsBloc extends Cubit<WithdrawFudsState> {
  final BreezBridge _breezLib;

  WithdrawFundsBloc(
    this._breezLib,
  ) : super(WithdrawFudsState.initial());

  Future fetchTransactionConst() async {
    _log.v("fetchTransactionConst");
    emit(WithdrawFudsState.initial());

    RecommendedFees recommendedFees;
    try {
      recommendedFees = await _breezLib.recommendedFees();
      _log.v("fetchTransactionConst recommendedFees: $recommendedFees");
    } catch (e) {
      _log.e("fetchTransactionConst error", ex: e);
      emit(WithdrawFudsState.error(extractExceptionMessage(e)));
      return;
    }

    emit(WithdrawFudsState.info(
      TransactionCost(const Duration(minutes: 60), recommendedFees.hourFee),
      TransactionCost(const Duration(minutes: 30), recommendedFees.halfHourFee),
      TransactionCost(const Duration(minutes: 10), recommendedFees.fastestFee),
    ));
  }

  Future<void> sweepAllCoins(
    String toAddress,
    FeeratePreset feeratePreset,
  ) async {
    await _breezLib.sweep(toAddress: toAddress, feeratePreset: feeratePreset);
  }
}
