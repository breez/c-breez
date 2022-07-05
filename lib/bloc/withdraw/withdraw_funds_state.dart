import 'package:fixnum/fixnum.dart';

abstract class WithdrawFudsState {
  const WithdrawFudsState();

  factory WithdrawFudsState.initial() => const WithdrawFudsEmptyState();

  factory WithdrawFudsState.info(
    Int64 sats,
    TransactionCostSpeed selectedSpeed,
    TransactionCost economy,
    TransactionCost regular,
    TransactionCost priority,
  ) =>
      WithdrawFudsInfoState(
        sats,
        selectedSpeed,
        economy,
        regular,
        priority,
      );

  WithdrawFudsState copyWith({
    TransactionCostSpeed? selectedSpeed,
  });
}

class WithdrawFudsEmptyState extends WithdrawFudsState {
  const WithdrawFudsEmptyState();

  @override
  WithdrawFudsState copyWith({
    TransactionCostSpeed? selectedSpeed,
  }) {
    return this;
  }
}

class WithdrawFudsInfoState extends WithdrawFudsState {
  final Int64 sats;
  final TransactionCostSpeed selectedSpeed;
  final TransactionCost economy;
  final TransactionCost regular;
  final TransactionCost priority;

  const WithdrawFudsInfoState(
    this.sats,
    this.selectedSpeed,
    this.economy,
    this.regular,
    this.priority,
  );

  @override
  WithdrawFudsState copyWith({
    TransactionCostSpeed? selectedSpeed,
  }) {
    return WithdrawFudsInfoState(
      sats,
      selectedSpeed ?? this.selectedSpeed,
      economy,
      regular,
      priority,
    );
  }

  TransactionCost selectedCost() {
    switch (selectedSpeed) {
      case TransactionCostSpeed.economy:
        return economy;
      case TransactionCostSpeed.regular:
        return regular;
      case TransactionCostSpeed.priority:
        return priority;
    }
  }

  Int64 receive() => sats - selectedCost().fee;
}

enum TransactionCostSpeed {
  economy,
  regular,
  priority,
}

class TransactionCost {
  final Duration waitingTime;
  final Int64 fee;

  const TransactionCost(
    this.waitingTime,
    this.fee,
  );
}
