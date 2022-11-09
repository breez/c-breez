import 'dart:async';

import 'package:breez_sdk/sdk.dart';
import 'package:c_breez/bloc/withdraw/withdraw_funds_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class WithdrawFundsBloc extends Cubit<WithdrawFudsState> {
  final LightningNode _lightningNode;

  WithdrawFundsBloc(
    this._lightningNode,
  ) : super(WithdrawFudsState.initial());

  Future fetchTransactionConst() async {
    final recommendedFees = await _lightningNode.fetchRecommendedFees();
    emit(WithdrawFudsState.info(
      TransactionCost(const Duration(minutes: 10), recommendedFees.fastestFee),
      TransactionCost(const Duration(minutes: 30), recommendedFees.halfHourFee),
      TransactionCost(const Duration(minutes: 60), recommendedFees.hourFee),
    ));
  }

  Future<void> sweepAllCoins(String address, TransactionCostSpeed speed) async {
    await _lightningNode.sweepAllCoinsTransactions(address, speed);
  }
}
