import 'package:breez_translations/generated/breez_translations.dart';
import 'package:c_breez/bloc/account/payment_error.dart';
import 'package:c_breez/models/currency.dart';
import 'package:c_breez/utils/utils.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('PaymentValidator');

/// Validates payment operations, checking limits and balances
class PaymentValidator {
  /// Translation strings for localized error messages
  final BreezTranslations texts;

  /// The currency used for validation and formatting
  final BitcoinCurrency currency;

  /// The function that performs the actual validation logic
  final void Function(int amountSat, bool outgoing, bool channelCreationPossible, {int? channelMinimumFeeSat})
  validatePayment;

  final bool channelCreationPossible;

  final int? channelMinimumFeeSat;

  /// Creates a new PaymentValidator
  ///
  /// [validatePayment] The function that performs the validation
  /// [currency] The Bitcoin currency unit to use for formatting
  /// [texts] Translation strings for error messages
  const PaymentValidator({
    required this.texts,
    required this.currency,
    required this.validatePayment,
    required this.channelCreationPossible,
    this.channelMinimumFeeSat,
  });

  /// Validates an incoming payment
  ///
  /// [amount] The payment amount in satoshis
  /// Returns an error message if validation fails, null otherwise
  String? validateIncoming(int amount) {
    return _validate(amount, false);
  }

  /// Validates an outgoing payment
  ///
  /// [amount] The payment amount in satoshis
  /// Returns an error message if validation fails, null otherwise
  String? validateOutgoing(int amount) {
    return _validate(amount, true);
  }

  /// Internal validation method
  ///
  /// [amount] The payment amount in satoshis
  /// [outgoing] Whether the payment is outgoing
  /// Returns an error message if validation fails, null otherwise
  String? _validate(int amount, bool outgoing) {
    _logger.info('Validating ${outgoing ? "outgoing" : "incoming"} payment of $amount satoshis');

    try {
      validatePayment(amount, outgoing, channelCreationPossible, channelMinimumFeeSat: channelMinimumFeeSat);
      return null;
    } on Exception catch (e) {
      return _handleException(e);
    }
  }

  /// Handles validation exceptions and returns appropriate error messages
  ///
  /// [e] The exception that occurred during validation
  /// Returns a user-friendly error message
  String _handleException(Exception e) {
    _logger.warning('Payment validation failed', e);

    if (e is PaymentExceededLimitError) {
      return texts.invoice_payment_validator_error_payment_exceeded_limit(currency.format(e.limitSat));
    } else if (e is PaymentBelowLimitError) {
      return texts.invoice_payment_validator_error_payment_below_invoice_limit(currency.format(e.limitSat));
    } else if (e is PaymentBelowReserveError) {
      return texts.invoice_payment_validator_error_payment_below_limit(currency.format(e.reserveAmountSat));
    } else if (e is PaymentExceededLiquidityError) {
      return "Insufficient inbound liquidity (${currency.format(e.limitSat)})";
    } else if (e is InsufficientLocalBalanceError) {
      return texts.invoice_payment_validator_error_insufficient_local_balance;
    } else if (e is PaymentBelowSetupFeesError) {
      return texts.invoice_payment_validator_error_payment_below_setup_fees_error(
        currency.format(e.setupFeesSat),
      );
    } else if (e is PaymentExceededLiquidityChannelCreationNotPossibleError) {
      return texts.lnurl_fetch_invoice_error_max(currency.format(e.limitSat));
    } else if (e is NoChannelCreationZeroLiquidityError) {
      return texts.lsp_error_cannot_open_channel;
    } else {
      return texts.invoice_payment_validator_error_unknown(ExceptionHandler.extractMessage(e, texts));
    }
  }
}
