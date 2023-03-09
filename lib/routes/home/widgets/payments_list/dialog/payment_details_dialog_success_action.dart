import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/models/payment_minutiae.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/shareable_payment_row.dart';
import 'package:flutter/material.dart';

class PaymentDetailsDialogSuccessAction extends StatelessWidget {
  final PaymentMinutiae paymentMinutiae;

  const PaymentDetailsDialogSuccessAction({
    super.key,
    required this.paymentMinutiae,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final successActionMessage = paymentMinutiae.successActionMessage;
    final successActionUrl = paymentMinutiae.successActionUrl;
    if (successActionMessage.isNotEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ShareablePaymentRow(
            title: texts.payment_details_dialog_action_for_payment_description,
            sharedValue: successActionMessage,
          ),
          if (successActionUrl != null)
            ShareablePaymentRow(
              title: texts.payment_details_dialog_action_for_payment_url,
              sharedValue: successActionUrl,
            ),
        ],
      );
    } else {
      return Container();
    }
  }
}
