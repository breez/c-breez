import 'package:c_breez/routes/lnurl/payment/pay_response.dart';
import 'package:c_breez/routes/lnurl/withdraw/withdraw_response.dart';
import 'package:c_breez/widgets/route.dart';
import 'package:dart_lnurl/dart_lnurl.dart';
import 'package:flutter/material.dart';

import 'payment/lnurl_payment_dialog.dart';
import 'payment/lnurl_payment_page.dart';
import 'withdraw/lnurl_withdraw_dialog.dart';

Future handleLNURL(
  BuildContext context,
  LNURLParseResult lnurlParseResult,
) {
  if (lnurlParseResult.payParams != null) {
    return handlePayRequest(context, lnurlParseResult.payParams!);
  }
  if (lnurlParseResult.withdrawalParams != null) {
    return handleWithdrawRequest(context, lnurlParseResult.withdrawalParams!);
  }

  throw "Unsupported lnurl";
}

Future<LNURLPayResult?> handlePayRequest(
  BuildContext context,
  LNURLPayParams payParams,
) async {
  bool fixedAmount = payParams.minSendable == payParams.maxSendable;
  LNURLPaymentPageResult? pageResult;
  if (fixedAmount && !(payParams.commentAllowed > 0)) {
    // Show dialog if payment is of fixed amount with no payer comment allowed
    pageResult = await showDialog<LNURLPaymentPageResult>(
      useRootNavigator: false,
      context: context,
      barrierDismissible: false,
      builder: (_) => LNURLPaymentDialog(payParams),
    );
  } else {
    pageResult = await Navigator.of(context).push<LNURLPaymentPageResult>(
      FadeInRoute(
        builder: (_) => LNURLPaymentPage(payParams),
      ),
    );
  }

  if (pageResult == null) {
    return Future.value();
  }
  if (pageResult.error != null) {
    throw pageResult.error.toString();
  }
  return pageResult.result;
}

Future handleWithdrawRequest(
  BuildContext context,
  LNURLWithdrawParams withdrawParams,
) async {
  LNURLWithdrawPageResult? pageResult;
  pageResult = await showDialog<LNURLWithdrawPageResult>(
    useRootNavigator: false,
    context: context,
    barrierDismissible: false,
    builder: (_) => LNURLWithdrawDialog(withdrawParams),
  );
  if (pageResult == null) {
    return Future.value();
  }
  if (pageResult.error != null) {
    throw pageResult.error.toString();
  }
}
