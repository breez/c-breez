import 'dart:async';

import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/routes/create_invoice/create_invoice_page.dart';
import 'package:c_breez/routes/create_invoice/widgets/successful_payment.dart';
import 'package:c_breez/routes/lnurl/widgets/lnurl_page_result.dart';
import 'package:c_breez/widgets/error_dialog.dart';
import 'package:c_breez/widgets/transparent_page_route.dart';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';

final _log = Logger("HandleLNURLWithdrawPageResult");

Future<LNURLPageResult?> handleWithdrawRequest(
  BuildContext context,
  LnUrlWithdrawRequestData requestData,
) async {
  Completer<LNURLPageResult?> completer = Completer();
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => CreateInvoicePage(
        requestData: requestData,
        onFinish: (LNURLPageResult? response) {
          completer.complete(response);
          Navigator.of(context).popUntil((route) => route.settings.name == "/");
        },
      ),
    ),
  );

  return completer.future;
}

void handleLNURLWithdrawPageResult(BuildContext context, LNURLPageResult result) {
  _log.fine("handle $result");
  if (result.hasError) {
    _log.fine("Handle LNURL withdraw page result with error '${result.error}'");
    final texts = context.texts();
    final themeData = Theme.of(context);
    promptError(
      context,
      texts.invoice_receive_fail,
      Text(
        texts.invoice_receive_fail_message(result.errorMessage),
        style: themeData.dialogTheme.contentTextStyle,
      ),
    );
    throw result.error!;
  } else {
    _log.fine("Handle LNURL withdraw page result with success");
    Navigator.of(context).push(
      TransparentPageRoute((ctx) => const SuccessfulPaymentRoute()),
    );
  }
}
