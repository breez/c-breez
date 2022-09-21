import 'package:breez_sdk/sdk.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/routes/lnurl/payment/success_action/success_action_data.dart';
import 'package:c_breez/utils/fiat_conversion.dart';
import 'package:c_breez/utils/locale.dart';
import 'package:fixnum/fixnum.dart';

class PaymentResultData {
  final PaymentInfo? paymentInfo;
  final Object? error;
  final SuccessActionData? successActionData;

  PaymentResultData({
    this.paymentInfo,
    this.error,
    this.successActionData,
  });

  String errorMessage(CurrencyState currencyState) {
    final texts = getSystemAppLocalizations();
    final errorMessage = error?.toString();
    if (errorMessage != null) {
      var displayError = paymentErrorsMapping()[errorMessage];
      if (displayError != null) {
        return displayError;
      }
      var parts = errorMessage.split(":");
      if (parts.length == 2) {
        switch (parts[0]) {
          case 'insufficient balance':
            try {
              final amount = Int64.parseInt(parts[1]);
              String amountText = currencyState.bitcoinCurrency.format(amount);
              if (currencyState.fiatCurrency != null &&
                  currencyState.fiatExchangeRate != null) {
                FiatConversion conversion = FiatConversion(
                  currencyState.fiatCurrency!,
                  currencyState.fiatExchangeRate!,
                );
                amountText = conversion.format(amount);
              }

              return texts.payment_error_insufficient_balance_amount(
                amountText,
              );
            } catch (err) {
              return texts.payment_error_to_send(
                errorMessage.split("\n").first,
              );
            }
        }
      }
    }
    return texts.payment_error_to_send('').replaceAll(':', '');
  }
}

Map<String, String> paymentErrorsMapping() {
  final texts = getSystemAppLocalizations();
  return {
    "FAILURE_REASON_INSUFFICIENT_BALANCE":
        texts.payment_error_insufficient_balance,
    "FAILURE_REASON_INCORRECT_PAYMENT_DETAILS":
        texts.payment_error_incorrect_payment_details,
    "FAILURE_REASON_ERROR": texts.payment_error_unexpected_error,
    "FAILURE_REASON_NO_ROUTE": texts.payment_error_no_route,
    "FAILURE_REASON_TIMEOUT": texts.payment_error_payment_timeout_exceeded,
    "FAILURE_REASON_NONE": texts.payment_error_none,
  };
}
