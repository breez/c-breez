class PaymentExceededLimitError implements Exception {
  final int limitSat;

  const PaymentExceededLimitError(
    this.limitSat,
  );
}

class PaymentBelowReserveError implements Exception {
  final int reserveAmount;

  const PaymentBelowReserveError(
    this.reserveAmount,
  );
}

class InsufficientLocalBalanceError implements Exception {
  const InsufficientLocalBalanceError();
}

class PaymentBelowSetupFeesError implements Exception {
  final int setupFees;

  const PaymentBelowSetupFeesError(
    this.setupFees,
  );
}
