import 'package:c_breez/bloc/account/payment_error.dart';
import 'package:c_breez/models/currency.dart';
import 'package:fixnum/fixnum.dart';

class PaymentValidator {
  final BitcoinCurrency _currency;
  final void Function(
    Int64 amount,
    bool outgoing, {
    Int64? channelMinimumFee,
  }) _validatePayment;
  final Int64? channelMinimumFee;

  PaymentValidator(
    this._validatePayment,
    this._currency, {
    this.channelMinimumFee,
  });

  String? validateIncoming(Int64 amount) {
    return _validate(amount, false);
  }

  String? validateOutgoing(Int64 amount) {
    return _validate(amount, true);
  }

  String? _validate(Int64 amount, bool outgoing) {
    try {
      _validatePayment(amount, outgoing, channelMinimumFee: channelMinimumFee);
    } on PaymentExceededLimitError catch (e) {
      return 'Payment exceeds the limit (${_currency.format(e.limitSat)})';
    } on PaymentBelowReserveError catch (e) {
      return "Breez requires you to keep ${_currency.format(e.reserveAmount)} in your balance.";
    } on InsufficientLocalBalanceError {
      return "Insufficient local balance";
    } on PaymentBelowSetupFeesError catch (e) {
      return "Insufficient amount to cover the setup fees of ${_currency.format(e.setupFees)}";
    }

    return null;
  }
}
