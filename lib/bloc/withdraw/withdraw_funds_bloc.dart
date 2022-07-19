import 'dart:async';

import 'package:c_breez/bloc/withdraw/withdraw_funds_state.dart';
import 'package:fixnum/fixnum.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:breez_sdk/sdk.dart';

class WithdrawFudsBloc extends Cubit<WithdrawFudsState> {
  final LightningNode _lightningNode;

  WithdrawFudsBloc(
    this._lightningNode,
  ) : super(WithdrawFudsState.initial());

  Future fetchTransactionConst() async {
    // TODO: fetch real transaction costs, this is a mock
    await Future.delayed(const Duration(seconds: 3));
    emit(WithdrawFudsState.info(
      TransactionCost(const Duration(minutes: 10), Int64(10)),
      TransactionCost(const Duration(minutes: 20), Int64(60)),
      TransactionCost(const Duration(minutes: 30), Int64(120)),
    ));
  }

  Future<void> sweepAllCoins(String address, TransactionCostSpeed speed) async {
    await _lightningNode.sweepAllCoinsTransactions(address, speed);
  }
}
