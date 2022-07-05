import 'dart:async';

import 'package:c_breez/bloc/withdraw/withdraw_funds_state.dart';
import 'package:fixnum/fixnum.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class WithdrawFudsBloc extends Cubit<WithdrawFudsState> {
  WithdrawFudsBloc() : super(WithdrawFudsState.initial());

  Future fetchTransactionConst() async {
    // TODO: fetch real transaction costs, this is a mock
    await Future.delayed(const Duration(seconds: 3));
    emit(WithdrawFudsState.info(
      Int64(1234),
      TransactionCostSpeed.regular,
      TransactionCost(const Duration(minutes: 10), Int64(10)),
      TransactionCost(const Duration(minutes: 20), Int64(60)),
      TransactionCost(const Duration(minutes: 30), Int64(120)),
    ));
  }

  Future selectTransactionSpeed(
    TransactionCostSpeed speed,
  ) async {
    emit(state.copyWith(
      selectedSpeed: speed,
    ));
  }

  Future<void> withdraw() async {
    // TODO: real transaction, this is a mock
    await Future.delayed(const Duration(seconds: 3));
    emit(WithdrawFudsState.info(
      Int64(0),
      TransactionCostSpeed.regular,
      TransactionCost(const Duration(minutes: 10), Int64(10)),
      TransactionCost(const Duration(minutes: 20), Int64(60)),
      TransactionCost(const Duration(minutes: 30), Int64(120)),
    ));
  }
}
