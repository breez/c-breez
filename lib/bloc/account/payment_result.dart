import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/utils/exceptions.dart';

class PaymentResult {
  final Payment? paymentInfo;
  final Object? error;

  const PaymentResult({
    this.paymentInfo,
    this.error,
  });

  String errorMessage() {
    final texts = getSystemAppLocalizations();
    String? displayMessage = error != null ? extractExceptionMessage(error!, texts) : null;
    return displayMessage != null
        ? texts.payment_error_to_send(displayMessage)
        : texts.payment_error_to_send_unknown_reason;
  }
}
