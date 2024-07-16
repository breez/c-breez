import 'package:breez_translations/generated/breez_translations.dart';
import 'package:c_breez/bloc/account/payment_error.dart';
import 'package:c_breez/models/currency.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:logging/logging.dart';

final _log = Logger("PaymentValidator");

class PaymentValidator {
  final BreezTranslations texts;
  final BitcoinCurrency currency;
  final void Function(
    int amountSat,
    bool outgoing,
    bool channelCreationPossible, {
    int? channelMinimumFeeSat,
  }) validatePayment;
  final bool channelCreationPossible;
  final int? channelMinimumFeeSat;

  const PaymentValidator({
    required this.texts,
    required this.currency,
    required this.validatePayment,
    required this.channelCreationPossible,
    this.channelMinimumFeeSat,
  });

  String? validateIncoming(int amountSat) {
    return _validate(amountSat, false);
  }

  String? validateOutgoing(int amountSat) {
    return _validate(amountSat, true);
  }

  String? _validate(int amountSat, bool outgoing) {
    _log.info("Validating for $amountSat and $outgoing");
    try {
      validatePayment(
        amountSat,
        outgoing,
        channelCreationPossible,
        channelMinimumFeeSat: channelMinimumFeeSat,
      );
    } on PaymentExceededLimitError catch (e) {
      _log.info("Got PaymentExceededLimitError", e);
      return texts.invoice_payment_validator_error_payment_exceeded_limit(
        currency.format(e.limitSat),
      );
    } on PaymentBelowLimitError catch (e) {
      _log.info("Got PaymentBelowLimitError", e);
      return texts.invoice_payment_validator_error_payment_below_invoice_limit(
        currency.format(e.limitSat),
      );
    } on PaymentBelowReserveError catch (e) {
      _log.info("Got PaymentBelowReserveError", e);
      return texts.invoice_payment_validator_error_payment_below_limit(
        currency.format(e.reserveAmountSat),
      );
    } on PaymentExceededLiquidityError catch (e) {
      return "Insufficient inbound liquidity (${currency.format(e.limitSat)})";
    } on InsufficientLocalBalanceError {
      return texts.invoice_payment_validator_error_insufficient_local_balance;
    } on PaymentBelowSetupFeesError catch (e) {
      _log.info("Got PaymentBelowSetupFeesError", e);
      return texts.invoice_payment_validator_error_payment_below_setup_fees_error(
        currency.format(e.setupFeesSat),
      );
    } on PaymentExceededLiquidityChannelCreationNotPossibleError catch (e) {
      return texts.lnurl_fetch_invoice_error_max(currency.format(e.limitSat));
    } on NoChannelCreationZeroLiquidityError {
      return texts.lsp_error_cannot_open_channel;
    } catch (e) {
      _log.info("Got Generic error", e);
      return texts.invoice_payment_validator_error_unknown(
        extractExceptionMessage(e, texts),
      );
    }

    return null;
  }
}
