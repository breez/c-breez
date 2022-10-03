import 'dart:async';

import 'package:c_breez/bloc/withdraw/withdraw_funds_state.dart';
import 'package:fixnum/fixnum.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:breez_sdk/sdk.dart';

class WithdrawFundsBloc extends Cubit<WithdrawFudsState> {
  final LightningNode _lightningNode;

  WithdrawFundsBloc(
    this._lightningNode,
  ) : super(WithdrawFudsState.initial());

  Future fetchTransactionConst() async {
    final recommendedFees = await _lightningNode.fetchRecommendedFees();
    emit(WithdrawFudsState.info(
      TransactionCost(const Duration(minutes: 10), Int64(recommendedFees.fastestFee)),
      TransactionCost(const Duration(minutes: 30), Int64(recommendedFees.halfHourFee)),
      TransactionCost(const Duration(minutes: 60), Int64(recommendedFees.hourFee)),
    ));
  }

  Future<void> sweepAllCoins(String address, TransactionCostSpeed speed) async {
    await _lightningNode.sweepAllCoinsTransactions(address, speed);
  }
}
