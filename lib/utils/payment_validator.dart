import 'package:breez_translations/generated/breez_translations.dart';
import 'package:c_breez/bloc/account/payment_error.dart';
import 'package:c_breez/models/currency.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:fimber/fimber.dart';

final _log = FimberLog("PaymentValidator");

class PaymentValidator {
  final BitcoinCurrency currency;
  final void Function(
    int amount,
    bool outgoing, {
    int? channelMinimumFee,
  }) validatePayment;
  final int? channelMinimumFee;
  final BreezTranslations texts;

  const PaymentValidator({
    required this.validatePayment,
    required this.currency,
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
    _log.v("Validating for $amount and $outgoing");
    try {
      validatePayment(amount, outgoing, channelMinimumFee: channelMinimumFee);
    } on PaymentExceededLimitError catch (e) {
      _log.v("Got PaymentExceededLimitError", ex: e);
      return texts.invoice_payment_validator_error_payment_exceeded_limit(
        currency.format(e.limitSat),
      );
    } on PaymentBelowLimitError catch (e) {
      _log.v("Got PaymentBelowLimitError", ex: e);
      return texts.invoice_payment_validator_error_payment_below_invoice_limit(
        currency.format(e.limitSat),
      );
    } on PaymentBelowReserveError catch (e) {
      _log.v("Got PaymentBelowReserveError", ex: e);
      return texts.invoice_payment_validator_error_payment_below_limit(
        currency.format(e.reserveAmount),
      );
    } on PaymentExceedLiquidityError catch (e) {
      return "Insufficient inbound liquidity (${currency.format(e.limitSat)})";
    } on InsufficientLocalBalanceError {
      return texts.invoice_payment_validator_error_insufficient_local_balance;
    } on PaymentBelowSetupFeesError catch (e) {
      _log.v("Got PaymentBelowSetupFeesError", ex: e);
      return texts.invoice_payment_validator_error_payment_below_setup_fees_error(
        currency.format(e.setupFees),
      );
    } on PaymentExcededLiqudityChannelCreationNotPossibleError catch (e) {
      return texts.lnurl_fetch_invoice_error_max(currency.format(e.limitSat));
    } on NoChannelCreationZeroLiqudityError {
      return texts.lsp_error_cannot_open_channel;
    } catch (e) {
      _log.v("Got Generic error", ex: e);
      return texts.invoice_payment_validator_error_unknown(
        extractExceptionMessage(e, texts),
      );
    }

    return null;
  }
}
