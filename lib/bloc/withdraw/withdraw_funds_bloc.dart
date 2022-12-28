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

  Future fetchTransactionCost() async {
    _log.v("fetchTransactionCost");
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
    int feeRate,
  ) async {
    await _breezLib.sweep(
      toAddress: toAddress,
      // Multiply by 1000 to convert from sat/byte to sat/kbyte
      // https://github.com/breez/c-breez/pull/312#discussion_r1058397422
      feeratePerkw: feeRate * 1000,
      // TODO remove this argument when this bug
      // https://github.com/fzyzcjy/flutter_rust_bridge/issues/828 is fixed
      // the FeeratePreset will be ignored as we are passing the feeratePerkw
      feeratePreset: FeeratePreset.Economy,
    );
  }
}
