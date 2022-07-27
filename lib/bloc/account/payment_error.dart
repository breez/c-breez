import 'package:fixnum/fixnum.dart';

class PaymentExceededLimitError implements Exception {
  final Int64 limitSat;

  const PaymentExceededLimitError(
    this.limitSat,
  );
}

class PaymentBelowReserveError implements Exception {
  final Int64 reserveAmount;

  const PaymentBelowReserveError(
    this.reserveAmount,
  );
}

class InsufficientLocalBalanceError implements Exception {
  const InsufficientLocalBalanceError();
}
