import 'dart:async';

import 'package:c_breez/bloc/transaction/transaction_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class WithdrawFudsBloc extends Cubit<WithdrawFudsState> {
  WithdrawFudsBloc() : super(WithdrawFudsState.initial());

  Future fetchTransactionConst() async {
    // TODO: fetch real transaction costs, this is a mock
    await Future.delayed(const Duration(seconds: 3));
    emit(WithdrawFudsState.info(
      TransactionCostSpeed.regular,
      const TransactionCost(600000, 1.0),
      const TransactionCost(1200000, 2.0),
      const TransactionCost(1800000, 2.0),
    ));
  }

  Future selectTransactionSpeed(
    TransactionCostSpeed speed,
  ) async {
    emit(state.copyWith(
      selectedSpeed: speed,
    ));
  }
}
