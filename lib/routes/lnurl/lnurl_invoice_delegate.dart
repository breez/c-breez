import 'dart:async';

import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/routes/lnurl/auth/lnurl_auth_handler.dart';
import 'package:c_breez/routes/lnurl/payment/lnurl_payment_handler.dart';
import 'package:c_breez/routes/lnurl/withdraw/lnurl_withdraw_handler.dart';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';

import 'widgets/lnurl_page_result.dart';

final _log = Logger("HandleLNURL");

Future handleLNURL(
  BuildContext context,
  GlobalKey firstPaymentItemKey,
  dynamic requestData,
) {
  _log.fine("Handling lnurl requestData: $requestData");
  if (requestData is LnUrlPayRequestData) {
    _log.fine("Handling payParams: $requestData");
    return handlePayRequest(context, firstPaymentItemKey, requestData);
  } else if (requestData is LnUrlWithdrawRequestData) {
    _log.fine("Handling withdrawalParams: $requestData");
    return handleWithdrawRequest(context, requestData);
  } else if (requestData is LnUrlAuthRequestData) {
    _log.fine("Handling lnurl auth: $requestData");
    return handleAuthRequest(context, requestData);
  } else if (requestData is LnUrlErrorData) {
    _log.fine("Handling lnurl error: $requestData");
    throw requestData.reason;
  }
  _log.warning("Unsupported lnurl $requestData");
  throw context.texts().lnurl_error_unsupported;
}

void handleLNURLPageResult(BuildContext context, LNURLPageResult result) {
  _log.fine("handle $result");
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
