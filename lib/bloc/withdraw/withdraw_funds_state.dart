abstract class WithdrawFudsState {
  const WithdrawFudsState();

  factory WithdrawFudsState.initial() => const WithdrawFudsEmptyState();

  factory WithdrawFudsState.error(
    String error,
  ) =>
      WithdrawFudsErrorState(error);

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

class WithdrawFudsErrorState extends WithdrawFudsState {
  final String message;

  const WithdrawFudsErrorState(
    this.message,
  );
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
  final int _fee;
  final TransactionCostKind kind;

  const TransactionCost(
    this.waitingTime,
    this._fee,
    this.kind,
  );

  int calculateFee() {
    const input = 1 * 148;
    const output = 2 * 34;
    const extra = 10;
    const size = input + output + extra;
    return _fee * size;
  }
}

enum TransactionCostKind {
  economy,
  regular,
  priority,
}
