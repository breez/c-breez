import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/utils/exceptions.dart';

class LNURLPaymentPageResult {
  final SuccessActionProcessed? successAction;
  final Object? error;

  const LNURLPaymentPageResult({
    this.successAction,
    this.error,
  });

  bool get hasError => error != null;

  String get errorMessage => extractExceptionMessage(error ?? "", getSystemAppLocalizations());
}

class LNURLPaymentInfo {
  final int amount;
  final String? comment;

  const LNURLPaymentInfo({
    required this.amount,
    this.comment,
  });
}
