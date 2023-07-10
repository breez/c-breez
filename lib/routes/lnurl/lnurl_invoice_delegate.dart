import 'dart:async';

import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/routes/lnurl/auth/lnurl_auth_handler.dart';
import 'package:c_breez/routes/lnurl/payment/lnurl_payment_handler.dart';
import 'package:c_breez/routes/lnurl/withdraw/lnurl_withdraw_handler.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';

import 'widgets/lnurl_page_result.dart';

final _log = FimberLog("handleLNURL");

Future handleLNURL(
  BuildContext context,
  dynamic requestData,
) {
  _log.v("Handling lnurl requestData: $requestData");
  if (requestData is LnUrlPayRequestData) {
    _log.v("Handling payParams: $requestData");
    return handlePayRequest(context, requestData);
  } else if (requestData is LnUrlWithdrawRequestData) {
    _log.v("Handling withdrawalParams: $requestData");
    return handleWithdrawRequest(context, requestData);
  } else if (requestData is LnUrlAuthRequestData) {
    _log.v("Handling lnurl auth: $requestData");
    return handleAuthRequest(context, requestData);
  } else if (requestData is LnUrlErrorData) {
    _log.v("Handling lnurl error: $requestData");
    throw requestData.reason;
  }
  _log.w("Unsupported lnurl $requestData");
  throw context.texts().lnurl_error_unsupported;
}

void handleLNURLPageResult(BuildContext context, LNURLPageResult result) {
  _log.v("handle $result");
  switch (result.protocol) {
    case LnUrlProtocol.Pay:
      handleLNURLPaymentPageResult(context, result);
      break;
    case LnUrlProtocol.Withdraw:
      handleLNURLWithdrawPageResult(context, result);
      break;
    case LnUrlProtocol.Auth:
      handleLNURLAuthPageResult(context, result);
      break;
    default:
      break;
  }
}
