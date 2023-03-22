import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/routes/lnurl/payment/lnurl_payment_dialog.dart';
import 'package:c_breez/routes/lnurl/payment/lnurl_payment_info.dart';
import 'package:c_breez/routes/lnurl/payment/lnurl_payment_page.dart';
import 'package:c_breez/routes/lnurl/payment/success_action/success_action_dialog.dart';
import 'package:c_breez/routes/lnurl/widgets/lnurl_page_result.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:c_breez/widgets/payment_dialogs/processing_payment_dialog.dart';
import 'package:c_breez/widgets/route.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _log = FimberLog("handleLNURLPayRequest");

Future<LNURLPageResult?> handlePayRequest(
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
      if (result is LnUrlPayResult_EndpointSuccess) {
        _log.v("LNURL payment success, action: ${result.data}");
        return LNURLPageResult(
          protocol: LnUrlProtocol.Pay,
          successAction: result.data,
        );
      } else if (result is LnUrlPayResult_EndpointError) {
        _log.v("LNURL payment failed: ${result.data.reason}");
        return LNURLPageResult(
          protocol: LnUrlProtocol.Pay,
          error: result.data.reason,
        );
      }
    }
    _log.w("Error sending LNURL payment", ex: result);
    throw LNURLPageResult(error: result).errorMessage;
  });
}

void handleLNURLPaymentPageResult(BuildContext context, LNURLPageResult result) {
  if (result.successAction != null) {
    _handleSuccessAction(context, result.successAction!);
  } else {
    _log.v("Handle LNURL payment page result with error '${result.error}'");
    final texts = context.texts();
    throw Exception(
      extractExceptionMessage(
        result.error!,
        texts,
        defaultErrorMsg: texts.lnurl_payment_page_unknown_error,
      ),
    );
  }
}

Future _handleSuccessAction(BuildContext context, SuccessActionProcessed successAction) {
  String message = '';
  String? url;
  if (successAction is SuccessActionProcessed_Message) {
    message = successAction.data.message;
    _log.v("Handle LNURL payment page result with message action '$message'");
  } else if (successAction is SuccessActionProcessed_Url) {
    message = successAction.data.description;
    url = successAction.data.url;
    _log.v("Handle LNURL payment page result with url action '$message', '$url'");
  } else if (successAction is SuccessActionProcessed_Aes) {
    message = "${successAction.data.description} ${successAction.data.plaintext}";
    _log.v("Handle LNURL payment page result with aes action '$message'");
  }
  // Artificial delay for UX purposes
  return Future.delayed(const Duration(seconds: 1)).then(
    (_) => showDialog(
      useRootNavigator: false,
      context: context,
      builder: (_) => SuccessActionDialog(
        message: message,
        url: url,
      ),
    ),
  );
}
