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
import 'package:dart_lnurl/dart_lnurl.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _log = FimberLog("handleLNURL");

Future handleLNURL(
  BuildContext context,
  LNURLParseResult lnurlParseResult,
  GlobalKey firstPaymentItemKey,
) {
  final payParams = lnurlParseResult.payParams;
  if (payParams != null) {
    _log.v("Handling payParams: $payParams");
    return handlePayRequest(context, payParams, context.read<AccountBloc>(), firstPaymentItemKey);
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
  AccountBloc accountBloc,
  GlobalKey firstPaymentItemKey,
) async {
  final texts = context.texts();
  bool fixedAmount = payParams.minSendable == payParams.maxSendable;
  LNURLPaymentInfo? paymentInfo;
  final reqData = LnUrlPayRequestData(
    callback: payParams.callback,
    minSendable: payParams.minSendable,
    maxSendable: payParams.maxSendable,
    metadataStr: payParams.metadata,
    commentAllowed: payParams.commentAllowed,
    domain: payParams.domain,
  );
  if (fixedAmount && !(payParams.commentAllowed > 0)) {
    // Show dialog if payment is of fixed amount with no payer comment allowed
    paymentInfo = await showDialog<LNURLPaymentInfo>(
      useRootNavigator: false,
      context: context,
      barrierDismissible: false,
      builder: (_) => LNURLPaymentDialog(
        requestData: reqData,
        domain: payParams.domain,
      ),
    );
  } else {
    paymentInfo = await Navigator.of(context).push<LNURLPaymentInfo>(
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
      paymentFunc: () => accountBloc.lnurlPay(
        amount: paymentInfo!.amount,
        comment: paymentInfo.comment,
        reqData: reqData,
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
