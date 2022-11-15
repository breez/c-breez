

abstract class WithdrawFudsState {
  const WithdrawFudsState();

  factory WithdrawFudsState.initial() => const WithdrawFudsEmptyState();

  factory WithdrawFudsState.info(
    TransactionCost economy,
    TransactionCost regular,
    TransactionCost priority,
  ) =>
      WithdrawFudsInfoState(
        economy,
        regular,
        priority,
      );
}

class WithdrawFudsEmptyState extends WithdrawFudsState {
  const WithdrawFudsEmptyState();
}

class WithdrawFudsInfoState extends WithdrawFudsState {
  final TransactionCost economy;
  final TransactionCost regular;
  final TransactionCost priority;

  const WithdrawFudsInfoState(
    this.economy,
    this.regular,
    this.priority,
  );
}

class TransactionCost {
  final Duration waitingTime;
  final int fee;

  const TransactionCost(
    this.waitingTime,
    this.fee,
  );
}
