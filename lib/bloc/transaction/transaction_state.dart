abstract class WithdrawFudsState {
  const WithdrawFudsState();

  factory WithdrawFudsState.initial() => const WithdrawFudsEmptyState();

  factory WithdrawFudsState.info(
    TransactionCostSpeed selectedSpeed,
    TransactionCost economy,
    TransactionCost regular,
    TransactionCost priority,
  ) =>
      WithdrawFudsInfoState(
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
  final TransactionCostSpeed selectedSpeed;
  final TransactionCost economy;
  final TransactionCost regular;
  final TransactionCost priority;

  const WithdrawFudsInfoState(
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
      selectedSpeed ?? this.selectedSpeed,
      economy,
      regular,
      priority,
    );
  }
}

enum TransactionCostSpeed {
  economy,
  regular,
  priority,
}

class TransactionCost {
  final int waitingTime;
  final double fee;

  const TransactionCost(
    this.waitingTime,
    this.fee,
  );
}
