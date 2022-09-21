import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/routes/lnurl/payment/success_action/success_action_data.dart';
import 'package:c_breez/routes/lnurl/payment/success_action/success_action_dialog.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:flutter/material.dart';

class PaymentResultHandler {
  final BuildContext context;
  final AccountBloc accountBloc;
  final CurrencyBloc currencyBloc;

  PaymentResultHandler(this.context, this.accountBloc, this.currencyBloc) {
    accountBloc.paymentResultStream.listen((paymentResult) async {
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
  }

  Future handleSuccessAction(
    BuildContext context,
    SuccessActionData successActionData,
  ) async {
    // Artificial delay for UX purposes
    await Future.delayed(const Duration(seconds: 1));
    return await showDialog(
      useRootNavigator: false,
      context: context,
      builder: (_) => SuccessActionDialog(successActionData),
    );
  }
}
