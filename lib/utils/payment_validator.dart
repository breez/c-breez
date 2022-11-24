import 'package:c_breez/bloc/account/payment_error.dart';
import 'package:c_breez/models/currency.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentValidator {
  final BitcoinCurrency _currency;
  final void Function(
    int amount,
    bool outgoing, {
    int? channelMinimumFee,
  }) _validatePayment;
  final int? channelMinimumFee;
  final AppLocalizations texts;

  PaymentValidator(
    this._validatePayment,
    this._currency, {
    this.channelMinimumFee,
    required this.texts,
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
      return texts.invoice_payment_validator_error_payment_exceeded_limit(
        _currency.format(e.limitSat),
      );
    } on PaymentBelowReserveError catch (e) {
      return texts.invoice_payment_validator_error_payment_below_limit(
        _currency.format(e.reserveAmount),
      );
    } on InsufficientLocalBalanceError {
      return texts.invoice_payment_validator_error_insufficient_local_balance;
    } on PaymentBelowSetupFeesError catch (e) {
      return texts.invoice_payment_validator_error_payment_below_setup_fees_error(
        _currency.format(e.setupFees),
      );
    } catch (e) {
      return texts.invoice_payment_validator_error_unknown(
        e.toString(),
      );
    }

    return null;
  }
}
