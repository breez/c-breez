import 'dart:async';

import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/routes/create_invoice/create_invoice_page.dart';
import 'package:c_breez/routes/create_invoice/widgets/successful_payment.dart';
import 'package:c_breez/routes/lnurl/widgets/lnurl_page_result.dart';
import 'package:c_breez/widgets/transparent_page_route.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';

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
  final log = FimberLog("handleLNURLWithdrawPageResult");
  if (result.error == null) {
    log.v("Handle LNURL withdraw page result with success");
    Navigator.of(context).push(
      TransparentPageRoute((ctx) => const SuccessfulPaymentRoute()),
    );
  } else {
    log.v("Handle LNURL withdraw page result with error '${result.error}'");
    throw result.error!;
  }
}
