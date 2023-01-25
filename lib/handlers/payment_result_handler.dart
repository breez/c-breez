import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/routes/lnurl/payment/success_action/success_action_data.dart';
import 'package:c_breez/routes/lnurl/payment/success_action/success_action_dialog.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:flutter/material.dart';

class PaymentResultHandler {
  final BuildContext context;
  final AccountBloc accountBloc;
  final CurrencyBloc currencyBloc;

  PaymentResultHandler(this.context, this.accountBloc, this.currencyBloc) {
    accountBloc.paymentResultStream.listen(
      (paymentResult) async {
        Future.delayed(const Duration(seconds: 1), () {
          if (paymentResult.successActionData != null) {
            handleSuccessAction(context, paymentResult.successActionData!);
          } else if (paymentResult.paymentInfo != null) {
            showFlushbar(
              context,
              messageWidget: SingleChildScrollView(
                child: Text(context.texts().home_payment_sent),
              ),
            );
          } else if (paymentResult.error != null) {
            showFlushbar(
              context,
              message: paymentResult.errorMessage(currencyBloc.state),
            );
          }
        });
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
