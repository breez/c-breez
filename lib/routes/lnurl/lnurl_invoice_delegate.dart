import 'dart:async';

import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_sdk/bridge_generated.dart' as sdk;
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/routes/create_invoice/create_invoice_page.dart';
import 'package:c_breez/routes/lnurl/payment/lnurl_payment_dialog.dart';
import 'package:c_breez/routes/lnurl/payment/lnurl_payment_page.dart';
import 'package:c_breez/routes/lnurl/payment/pay_response.dart';
import 'package:c_breez/routes/lnurl/withdraw/withdraw_response.dart';
import 'package:c_breez/widgets/payment_dialogs/processing_payment_dialog.dart';
import 'package:c_breez/widgets/route.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _log = FimberLog("handleLNURL");

Future handleLNURL(
  BuildContext context,
  GlobalKey firstPaymentItemKey,
  dynamic requestData,
) {
  _log.v("Handling lnurl requestData: $requestData");
  if (requestData is LnUrlPayRequestData) {
    _log.v("Handling payParams: $requestData");
    return handlePayRequest(context, firstPaymentItemKey, requestData);
  } else if (requestData is LnUrlWithdrawRequestData) {
    _log.v("Handling withdrawalParams: $requestData");
    return handleWithdrawRequest(context, requestData);
  } else if (requestData is LnUrlErrorData) {
    _log.v("Handling lnurl error: $requestData");
    throw requestData.reason;
  }
  _log.w("Unsupported lnurl $requestData");
  throw context.texts().lnurl_error_unsupported;
}

Future<LNURLPaymentPageResult?> handlePayRequest(
  BuildContext context,
  GlobalKey firstPaymentItemKey,
  LnUrlPayRequestData requestData,
) async {
  LNURLPaymentInfo? paymentInfo;
  bool fixedAmount = requestData.minSendable == requestData.maxSendable;
  if (fixedAmount && !(requestData.commentAllowed > 0)) {
    // Show dialog if payment is of fixed amount with no payer comment allowed
    paymentInfo = await showDialog<LNURLPaymentInfo>(
      useRootNavigator: false,
      context: context,
      barrierDismissible: false,
      builder: (_) => LNURLPaymentDialog(requestData: requestData),
    );
  } else {
    paymentInfo = await Navigator.of(context).push<LNURLPaymentInfo>(
      FadeInRoute(
        builder: (_) => LNURLPaymentPage(requestData: requestData),
      ),
    );
  }
  if (paymentInfo == null) {
    return Future.value();
  }
  // Artificial wait for UX purposes
  await Future.delayed(const Duration(milliseconds: 800));
  // Show Processing Payment Dialog
  // ignore: use_build_context_synchronously
  return await showDialog(
    useRootNavigator: false,
    context: context,
    barrierDismissible: false,
    builder: (_) => ProcessingPaymentDialog(
      isLnurlPayment: true,
      firstPaymentItemKey: firstPaymentItemKey,
      paymentFunc: () => context.read<AccountBloc>().lnurlPay(
            amount: paymentInfo!.amount,
            comment: paymentInfo.comment,
            reqData: requestData,
          ),
    ),
  ).then((result) {
    if (result is LnUrlPayResult) {
      if (result is sdk.LnUrlPayResult_EndpointSuccess) {
        _log.v("LNURL payment success, action: ${result.data}");
        return LNURLPaymentPageResult(
          successAction: result.data,
        );
      } else if (result is sdk.LnUrlPayResult_EndpointError) {
        _log.v("LNURL payment failed: ${result.data.reason}");
        return LNURLPaymentPageResult(
          error: result.data.reason,
        );
      }
    }
    _log.w("Error sending LNURL payment", ex: result);
    throw LNURLPaymentPageResult(error: result).errorMessage;
  });
}

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
