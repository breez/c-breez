import 'package:c_breez/routes/lnurl/auth/lnurl_auth_handler.dart';
import 'package:c_breez/routes/lnurl/payment/lnurl_payment_handler.dart';
import 'package:c_breez/routes/lnurl/withdraw/lnurl_withdraw_handler.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'widgets/lnurl_page_result.dart';

final _log = Logger("HandleLNURL");

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
