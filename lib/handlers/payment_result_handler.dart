import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/routes/lnurl/payment/success_action/success_action_dialog.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class PaymentResultHandler {
  final _log = FimberLog("PaymentResultHandler");

  final BuildContext context;
  final AccountBloc accountBloc;
  final CurrencyBloc currencyBloc;

  PaymentResultHandler(this.context, this.accountBloc, this.currencyBloc) {
    _log.v("PaymentResultHandler created");
    accountBloc.paymentResultStream.delay(const Duration(seconds: 1)).listen(
      (paymentResult) async {
        _log.v("Received paymentResult: $paymentResult");
        if (paymentResult.successAction != null) {
          _log.v("paymentResult successAction: ${paymentResult.successAction}");
          handleSuccessAction(context, paymentResult.successAction!);
        } else if (paymentResult.paymentInfo != null) {
          final texts = context.texts();
          showFlushbar(
            context,
            messageWidget: SingleChildScrollView(
              child: Text(
                  paymentResult.paymentInfo!.paymentType == PaymentType.Received
                      ? texts.successful_payment_received
                      : texts.home_payment_sent),
            ),
          );
        } else if (paymentResult.error != null) {
          _log.v("paymentResult error: ${paymentResult.error}");
          showFlushbar(
            context,
            message: paymentResult.errorMessage(currencyBloc.state),
          );
        }
      },
    );
  }

  Future handleSuccessAction(
    BuildContext context,
    SuccessAction successAction,
  ) async {
    // Artificial delay for UX purposes
    return Future.delayed(const Duration(seconds: 1)).then(
      (_) => showDialog(
        useRootNavigator: false,
        context: context,
        builder: (_) => SuccessActionDialog(successAction),
      ),
    );
  }
}
