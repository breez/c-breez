import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/routes/lnurl/payment/success_action/success_action_data.dart';
import 'package:c_breez/utils/locale.dart';

class PaymentResultData {
  final Payment? paymentInfo;
  final Object? error;
  final SuccessActionData? successActionData;

  PaymentResultData({
    this.paymentInfo,
    this.error,
    this.successActionData,
  });

  String errorMessage(CurrencyState currencyState) {
    final texts = getSystemAppLocalizations();
    String? displayMessage = error?.toString();
    if (displayMessage != null) {
      displayMessage =
          RegExp(r'(?<=message: ")(.*)(?=",)').stringMatch(displayMessage);
    }
    return displayMessage ??=
        texts.payment_error_to_send('').replaceAll(':', '');
  }
}
