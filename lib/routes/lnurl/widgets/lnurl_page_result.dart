import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/utils/exceptions.dart';

class LNURLPageResult {
  final LnUrlProtocol? protocol;
  final SuccessActionProcessed? successAction;
  final Object? error;

  const LNURLPageResult({
    this.protocol,
    this.successAction,
    this.error,
  });

  bool get hasError => error != null;

  String get errorMessage => extractExceptionMessage(
        error ?? "",
        getSystemAppLocalizations(),
        defaultErrorMsg: getSystemAppLocalizations().lnurl_payment_page_unknown_error,
      );
}

// Supported LNURL specs
enum LnUrlProtocol { Auth, Pay, Withdraw }
