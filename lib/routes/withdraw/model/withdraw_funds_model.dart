enum WithdrawKind {
  withdraw_funds,
  unexpected_funds,
}

class WithdrawFundsPolicy {
  final WithdrawKind withdrawKind;
  final int minValue;
  final int maxValue;

  const WithdrawFundsPolicy(
    this.withdrawKind,
    this.minValue,
    this.maxValue,
  );

  @override
  String toString() {
    return 'WithdrawFundsPolicy{withdrawKind: $withdrawKind, minValue: $minValue, maxValue: $maxValue}';
  }
}
