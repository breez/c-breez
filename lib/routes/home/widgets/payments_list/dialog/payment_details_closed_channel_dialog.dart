import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/models/payment_minutiae.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/closed_channel_payment_details.dart';
import 'package:flutter/material.dart';

class PaymentDetailsDialogClosedChannelDialog extends StatelessWidget {
  final PaymentMinutiae paymentMinutiae;

  const PaymentDetailsDialogClosedChannelDialog({
    Key? key,
    required this.paymentMinutiae,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(24, 22, 0, 16),
      title: Text(
        paymentMinutiae.isPending
            ? texts.payment_details_dialog_closed_channel_title_pending
            : texts.payment_details_dialog_closed_channel_title,
        style: themeData.dialogTheme.titleTextStyle,
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      content: ClosedChannelPaymentDetailsWidget(
        paymentMinutiae: paymentMinutiae,
      ),
      actions: [
        SimpleDialogOption(
          onPressed: () => Navigator.pop(context),
          child: Text(
            texts.payment_details_dialog_closed_channel_ok,
            style: themeData.primaryTextTheme.labelLarge,
          ),
        ),
      ],
    );
  }
}
