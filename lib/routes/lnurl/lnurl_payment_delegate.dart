import 'package:c_breez/widgets/route.dart';
import 'package:dart_lnurl/dart_lnurl.dart';
import 'package:flutter/material.dart';

import 'lnurl_payment_dialog.dart';
import 'lnurl_payment_page.dart';

void handleLNURLPayRequest(
    BuildContext context, LNURLPayParams payParams, Function() onComplete) {
  bool fixedAmount = payParams.minSendable == payParams.maxSendable;
  if (fixedAmount && !(payParams.commentAllowed > 0)) {
    // Show dialog if payment is of fixed amount with no payer comment allowed
    showDialog(
      useRootNavigator: false,
      context: context,
      barrierDismissible: false,
      builder: (_) => LNURLPaymentDialog(payParams, onComplete: onComplete),
    );
  } else {
    Navigator.of(context).push(
      FadeInRoute(
        builder: (_) => LNURLPaymentPage(payParams, onComplete: onComplete),
      ),
    );
  }
}
