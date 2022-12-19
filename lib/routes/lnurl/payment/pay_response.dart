import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/utils/exceptions.dart';

class LNURLPaymentPageResult {
  final SuccessAction? successAction;
  final Object? error;

  const LNURLPaymentPageResult({
    this.successAction,
    this.error,
  });

  bool get hasError => error != null;

  String get errorMessage => extractExceptionMessage(error ?? "");
}
