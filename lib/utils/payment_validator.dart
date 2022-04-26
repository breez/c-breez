import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/models/currency.dart';
import 'package:fixnum/fixnum.dart';

class PaymentValidator {
  final BitcoinCurrency _currency;
  final void Function(Int64 amount, bool outgoing) _validatePayment;

  PaymentValidator(this._validatePayment, this._currency);

  String validateIncoming(Int64 amount) {
    return _validate(amount, false);
  }

  String validateOutgoing(Int64 amount) {
    return _validate(amount, true);
  }

  String _validate(Int64 amount, bool outgoing) {
    try {
      _validatePayment(amount, outgoing);
    } on PaymentExceededLimitError catch (e) {
      return 'Payment exceeds the limit (${_currency.format(e.limitSat)})';
    } on PaymentBellowReserveError catch (e) {
      return "Breez requires you to keep ${_currency.format(e.reserveAmount)} in your balance.";
    } on InsufficientLocalBalanceError {
      return "Insufficient local balance";
    }

    return "";
  }
}
