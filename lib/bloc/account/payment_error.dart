class PaymentExceededLimitError implements Exception {
  final int limitSat;

  const PaymentExceededLimitError(this.limitSat);
}

class PaymentBelowLimitError implements Exception {
  final int limitSat;

  const PaymentBelowLimitError(this.limitSat);
}

class PaymentBelowReserveError implements Exception {
  final int reserveAmountSat;

  const PaymentBelowReserveError(this.reserveAmountSat);
}

class InsufficientLocalBalanceError implements Exception {
  const InsufficientLocalBalanceError();
}

class PaymentBelowSetupFeesError implements Exception {
  final int setupFeesSat;

  const PaymentBelowSetupFeesError(this.setupFeesSat);
}

class PaymentExceededLiquidityError implements Exception {
  final int limitSat;

  const PaymentExceededLiquidityError(this.limitSat);
}

class PaymentExceededLiquidityChannelCreationNotPossibleError implements Exception {
  final int limitSat;

  const PaymentExceededLiquidityChannelCreationNotPossibleError(this.limitSat);
}

class NoChannelCreationZeroLiquidityError implements Exception {}
