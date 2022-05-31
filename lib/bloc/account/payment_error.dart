import 'package:fixnum/fixnum.dart';

class PaymentExceededLimitError implements Exception {
  final Int64 limitSat;

  const PaymentExceededLimitError(
    this.limitSat,
  );
}

class PaymentBellowReserveError implements Exception {
  final Int64 reserveAmount;

  const PaymentBellowReserveError(
    this.reserveAmount,
  );
}

class InsufficientLocalBalanceError implements Exception {
  const InsufficientLocalBalanceError();
}
