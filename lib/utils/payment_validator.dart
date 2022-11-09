import 'package:c_breez/bloc/account/payment_error.dart';
import 'package:c_breez/models/currency.dart';

class PaymentValidator {
  final BitcoinCurrency _currency;
  final void Function(
    int amount,
    bool outgoing, {
    int? channelMinimumFee,
  }) _validatePayment;
  final int? channelMinimumFee;

  PaymentValidator(
    this._validatePayment,
    this._currency, {
    this.channelMinimumFee,
  });

  String? validateIncoming(int amount) {
    return _validate(amount, false);
  }

  String? validateOutgoing(int amount) {
    return _validate(amount, true);
  }

  String? _validate(int amount, bool outgoing) {
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
