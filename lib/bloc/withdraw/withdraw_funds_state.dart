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
  final TransactionCostKind kind;
  final Duration waitingTime;
  final int _fee;
  final int _inputs;

  const TransactionCost(
    this.kind,
    this.waitingTime,
    this._fee,
    this._inputs,
  );

  int calculateFee() {
    final input = _inputs * 148;
    const output = 2 * 34;
    const extra = 10;
    final size = input + output + extra;
    return _fee * size;
  }
}

enum TransactionCostKind {
  economy,
  regular,
  priority,
}
