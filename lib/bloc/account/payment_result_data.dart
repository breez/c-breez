import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/routes/lnurl/payment/success_action/success_action_data.dart';
import 'package:c_breez/utils/exceptions.dart';

class PaymentResultData {
  final Payment? paymentInfo;
  final Object? error;
  final SuccessActionData? successActionData;

  const PaymentResultData({
    this.paymentInfo,
    this.error,
    this.successActionData,
  });

  String errorMessage(CurrencyState currencyState) {
    final texts = getSystemAppLocalizations();
    String? displayMessage = error != null ? extractExceptionMessage(error!) : null;
    return displayMessage != null
        ? texts.payment_error_to_send(displayMessage)
        : texts.payment_error_to_send_unknown_reason;
  }
}
