import 'dart:async';

import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/routes/lnurl/auth/lnurl_auth_handler.dart';
import 'package:c_breez/routes/lnurl/payment/lnurl_payment_handler.dart';
import 'package:c_breez/routes/lnurl/withdraw/lnurl_withdraw_handler.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';

Future handleLNURL(
  BuildContext context,
  GlobalKey firstPaymentItemKey,
  dynamic requestData,
) {
  final log = FimberLog("handleLNURL");
  log.v("Handling lnurl requestData: $requestData");
  if (requestData is LnUrlPayRequestData) {
    log.v("Handling payParams: $requestData");
    return handlePayRequest(context, firstPaymentItemKey, requestData);
  } else if (requestData is LnUrlWithdrawRequestData) {
    log.v("Handling withdrawalParams: $requestData");
    return handleWithdrawRequest(context, requestData);
  } else if (requestData is LnUrlAuthRequestData) {
    log.v("Handling lnurl auth: $requestData");
    return handleAuthRequest(context, requestData);
  } else if (requestData is LnUrlErrorData) {
    log.v("Handling lnurl error: $requestData");
    throw requestData.reason;
  }
  log.w("Unsupported lnurl $requestData");
  throw context.texts().lnurl_error_unsupported;
}
