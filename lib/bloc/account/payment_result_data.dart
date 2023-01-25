import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/routes/lnurl/payment/success_action/success_action_data.dart';
import 'package:c_breez/utils/exceptions.dart';

abstract class PaymentResultData {
  const PaymentResultData();

  factory PaymentResultData.success(
    SuccessActionData? successActionData,
  ) {
    return PaymentResultSuccess(successActionData);
  }

  factory PaymentResultData.error(
    Object? error,
  ) {
    return PaymentResultError(error);
  }
}

class PaymentResultSuccess extends PaymentResultData {
  final SuccessActionData? successActionData;

  const PaymentResultSuccess(
    this.successActionData,
  );
}

class PaymentResultError extends PaymentResultData {
  final Object? error;

  const PaymentResultError(
    this.error,
  );

  String errorMessage(CurrencyState currencyState) {
    final texts = getSystemAppLocalizations();
    String? displayMessage = error != null ? extractExceptionMessage(error!) : null;
    return displayMessage != null
        ? texts.payment_error_to_send(displayMessage)
        : texts.payment_error_to_send_unknown_reason;
  }
}
