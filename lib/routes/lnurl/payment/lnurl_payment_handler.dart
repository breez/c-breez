import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/routes/lnurl/payment/lnurl_payment_dialog.dart';
import 'package:c_breez/routes/lnurl/payment/lnurl_payment_info.dart';
import 'package:c_breez/routes/lnurl/payment/lnurl_payment_page.dart';
import 'package:c_breez/routes/lnurl/payment/success_action/success_action_dialog.dart';
import 'package:c_breez/routes/lnurl/widgets/lnurl_page_result.dart';
import 'package:c_breez/widgets/payment_dialogs/processing_payment_dialog.dart';
import 'package:c_breez/widgets/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger("HandleLNURLPayRequest");

Future<LNURLPageResult?> handlePayRequest(
  BuildContext context,
  GlobalKey firstPaymentItemKey,
  LnUrlPayRequestData data,
) async {
  LNURLPaymentInfo? paymentInfo;
  bool fixedAmount = data.minSendable == data.maxSendable;
  if (fixedAmount && !(data.commentAllowed > 0)) {
    // Show dialog if payment is of fixed amount with no payer comment allowed
    paymentInfo = await showDialog<LNURLPaymentInfo>(
      useRootNavigator: false,
      context: context,
      barrierDismissible: false,
      builder: (_) => LNURLPaymentDialog(data: data),
    );
  } else {
    paymentInfo = await Navigator.of(context).push<LNURLPaymentInfo>(
      FadeInRoute(
        builder: (_) => LNURLPaymentPage(data: data),
      ),
    );
  }
  if (paymentInfo == null) {
    return Future.value();
  }
  // Show Processing Payment Dialog
  // ignore: use_build_context_synchronously
  return await showDialog(
    useRootNavigator: false,
    context: context,
    barrierDismissible: false,
    builder: (_) => ProcessingPaymentDialog(
      isLnurlPayment: true,
      firstPaymentItemKey: firstPaymentItemKey,
      paymentFunc: () {
        final accBloc = context.read<AccountBloc>();
        final req = LnUrlPayRequest(
          amountMsat: paymentInfo!.amount * 1000,
          comment: paymentInfo.comment,
          data: data,
        );
        return accBloc.lnurlPay(req: req);
      },
    ),
  ).then((result) {
    if (result is LnUrlPayResult) {
      if (result is LnUrlPayResult_EndpointSuccess) {
        _log.info("LNURL payment success, action: ${result.data}");
        return LNURLPageResult(
          protocol: LnUrlProtocol.Pay,
          successAction: result.data.successAction,
        );
      } else if (result is LnUrlPayResult_PayError) {
        _log.info("LNURL payment for ${result.data.paymentHash} failed: ${result.data.reason}");
        return LNURLPageResult(
          protocol: LnUrlProtocol.Pay,
          error: result.data.reason,
        );
      } else if (result is LnUrlPayResult_EndpointError) {
        _log.info("LNURL payment failed: ${result.data.reason}");
        return LNURLPageResult(
          protocol: LnUrlProtocol.Pay,
          error: result.data.reason,
        );
      }
    }
    _log.warning("Error sending LNURL payment", result);
    throw LNURLPageResult(error: result).errorMessage;
  });
}

void handleLNURLPaymentPageResult(BuildContext context, LNURLPageResult result) {
  if (result.successAction != null) {
    _handleSuccessAction(context, result.successAction!);
  } else if (result.hasError) {
    _log.info("Handle LNURL payment page result with error '${result.error}'");
    throw Exception(result.errorMessage);
  }
}

Future _handleSuccessAction(BuildContext context, SuccessActionProcessed successAction) {
  String message = '';
  String? url;
  if (successAction is SuccessActionProcessed_Message) {
    message = successAction.data.message;
    _log.info("Handle LNURL payment page result with message action '$message'");
  } else if (successAction is SuccessActionProcessed_Url) {
    message = successAction.data.description;
    url = successAction.data.url;
    _log.info("Handle LNURL payment page result with url action '$message', '$url'");
  } else if (successAction is SuccessActionProcessed_Aes) {
    message = "${successAction.data.description} ${successAction.data.plaintext}";
    _log.info("Handle LNURL payment page result with aes action '$message'");
  }
  return showDialog(
    useRootNavigator: false,
    context: context,
    builder: (_) => SuccessActionDialog(
      message: message,
      url: url,
    ),
  );
}
