import 'dart:async';

import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/routes/create_invoice/create_invoice_page.dart';
import 'package:c_breez/routes/lnurl/withdraw/withdraw_response.dart';
import 'package:flutter/material.dart';

Future<LNURLWithdrawPageResult?> handleWithdrawRequest(
  BuildContext context,
  LnUrlWithdrawRequestData requestData,
) async {
  Completer<LNURLWithdrawPageResult?> completer = Completer();
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => CreateInvoicePage(
        requestData: requestData,
        onFinish: (LNURLWithdrawPageResult? response) {
          completer.complete(response);
          Navigator.of(context).popUntil((route) => route.settings.name == "/");
        },
      ),
    ),
  );

  return completer.future;
}
