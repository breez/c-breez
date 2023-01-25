import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/payment_result_data.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/routes/lnurl/payment/success_action/success_action_data.dart';
import 'package:c_breez/routes/lnurl/payment/success_action/success_action_dialog.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

final _log = FimberLog("PaymentResultHandler");

class PaymentResultHandler {
  final BuildContext context;
  final AccountBloc accountBloc;
  final CurrencyBloc currencyBloc;

  PaymentResultHandler(this.context, this.accountBloc, this.currencyBloc) {
    _log.v("PaymentResultHandler created");
    accountBloc.paymentResultStream.delay(const Duration(seconds: 1)).listen(
      (paymentResult) async {
        _log.v("Received paymentResult: $paymentResult");
        if (paymentResult is PaymentResultSuccess) {
          final actionData = paymentResult.successActionData;
          _log.v("actionData: $actionData");
          if (actionData != null) {
            handleSuccessAction(context, actionData);
          } else {
            showFlushbar(
              context,
              messageWidget: SingleChildScrollView(
                child: Text(context.texts().home_payment_sent),
              ),
            );
          }
        } else if (paymentResult is PaymentResultError) {
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
    SuccessActionData successActionData,
  ) async {
    // Artificial delay for UX purposes
    return Future.delayed(const Duration(seconds: 1)).then(
      (_) => showDialog(
        useRootNavigator: false,
        context: context,
        builder: (_) => SuccessActionDialog(successActionData),
      ),
    );
  }
}
