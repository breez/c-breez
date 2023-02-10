import 'dart:async';

import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/routes/create_invoice/create_invoice_page.dart';
import 'package:c_breez/routes/lnurl/payment/lnurl_payment_dialog.dart';
import 'package:c_breez/routes/lnurl/payment/lnurl_payment_page.dart';
import 'package:c_breez/routes/lnurl/payment/pay_response.dart';
import 'package:c_breez/routes/lnurl/withdraw/withdraw_response.dart';
import 'package:c_breez/widgets/route.dart';
import 'package:dart_lnurl/dart_lnurl.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';

final _log = FimberLog("handleLNURL");

Future handleLNURL(
  BuildContext context,
  LNURLParseResult lnurlParseResult,
) {
  final payParams = lnurlParseResult.payParams;
  if (payParams != null) {
    _log.v("Handling payParams: $payParams");
    return handlePayRequest(context, payParams);
  }

  final withdrawalParams = lnurlParseResult.withdrawalParams;
  if (withdrawalParams != null) {
    _log.v("Handling withdrawalParams: $withdrawalParams");
    return handleWithdrawRequest(context, withdrawalParams);
  }

  _log.w("Unsupported lnurl $lnurlParseResult");
  throw context.texts().lnurl_error_unsupported;
}

Future<LNURLPaymentPageResult?> handlePayRequest(
  BuildContext context,
  LNURLPayParams payParams,
) async {
  bool fixedAmount = payParams.minSendable == payParams.maxSendable;
  LNURLPaymentPageResult? pageResult;
  final reqData = LnUrlPayRequestData(
    callback: payParams.callback,
    minSendable: payParams.minSendable,
    maxSendable: payParams.maxSendable,
    metadataStr: payParams.metadata,
    commentAllowed: payParams.commentAllowed,
  );
  if (fixedAmount && !(payParams.commentAllowed > 0)) {
    // Show dialog if payment is of fixed amount with no payer comment allowed
    pageResult = await showDialog<LNURLPaymentPageResult>(
      useRootNavigator: false,
      context: context,
      barrierDismissible: false,
      builder: (_) => LNURLPaymentDialog(
        requestData: reqData,
        domain: payParams.domain,
      ),
    );
  } else {
    pageResult = await Navigator.of(context).push<LNURLPaymentPageResult>(
      FadeInRoute(
        builder: (_) => LNURLPaymentPage(
          requestData: reqData,
          domain: payParams.domain,
          name: payParams.payerData?.name,
          auth: payParams.payerData?.auth,
          email: payParams.payerData?.email,
          identifier: payParams.payerData?.identifier,
        ),
      ),
    );
  }

  if (pageResult == null) {
    return Future.value();
  }
  if (pageResult.hasError) {
    throw pageResult.errorMessage;
  }
  return pageResult;
}

Future<LNURLWithdrawPageResult?> handleWithdrawRequest(
  BuildContext context,
  LNURLWithdrawParams withdrawParams,
) async {
  final requestData = LnUrlWithdrawRequestData(
    callback: withdrawParams.callback,
    minWithdrawable: withdrawParams.minWithdrawable,
    maxWithdrawable: withdrawParams.maxWithdrawable,
    k1: withdrawParams.k1,
    defaultDescription: withdrawParams.defaultDescription,
  );

  Completer<LNURLWithdrawPageResult?> completer = Completer();
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => CreateInvoicePage(
      requestData: requestData,
      domain: withdrawParams.domain,
      onFinish: (LNURLWithdrawPageResult? response) {
        completer.complete(response);
        Navigator.of(context).popUntil((route) => route.settings.name == "/");
      },
    ),
  ));

  return completer.future;
}
