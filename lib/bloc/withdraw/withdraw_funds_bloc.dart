import 'dart:async';

import 'package:breez_sdk/breez_bridge.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/bloc/withdraw/withdraw_funds_state.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:c_breez/utils/locale.dart';
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
      _log.v("fetchTransactionConst recommendedFees: fastestFee: ${recommendedFees.fastestFee}, "
          "halfHourFee: ${recommendedFees.halfHourFee}, hourFee: ${recommendedFees.hourFee}");
    } catch (e) {
      _log.e("fetchTransactionConst error", ex: e);
      emit(WithdrawFudsState.error(extractExceptionMessage(e)));
      return;
    }

    final nodeState = await _breezLib.getNodeState();
    if (nodeState == null) {
      _log.e("Failed to get node state");
      emit(WithdrawFudsState.error(getSystemAppLocalizations().node_state_error));
      return;
    }
    final inputs = nodeState.outpoints.length;
    _log.v("NodeState outputs count: $inputs");

    emit(WithdrawFudsState.info(
      TransactionCost(
        TransactionCostKind.economy,
        const Duration(minutes: 60),
        recommendedFees.hourFee,
        inputs,
      ),
      TransactionCost(
        TransactionCostKind.regular,
        const Duration(minutes: 30),
        recommendedFees.halfHourFee,
        inputs,
      ),
      TransactionCost(
        TransactionCostKind.priority,
        const Duration(minutes: 10),
        recommendedFees.fastestFee,
        inputs,
      ),
    ));
  }

  Future<void> sweepAllCoins(
    String toAddress,
    int feeRateSatsPerByte,
  ) async {
    await _breezLib.sweep(
      toAddress: toAddress,
      feeRateSatsPerByte: feeRateSatsPerByte,
    );
  }
}
