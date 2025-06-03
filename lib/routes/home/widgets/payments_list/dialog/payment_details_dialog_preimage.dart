import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/models/payment_minutiae.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/shareable_payment_row.dart';
import 'package:flutter/material.dart';

class PaymentDetailsPreimage extends StatelessWidget {
  final PaymentMinutiae paymentMinutiae;

  const PaymentDetailsPreimage({super.key, required this.paymentMinutiae});

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    final paymentPreimage = paymentMinutiae.paymentPreimage;
    if (paymentPreimage.isNotEmpty) {
      return ShareablePaymentRow(
        title: texts.payment_details_dialog_single_info_pre_image,
        sharedValue: paymentPreimage,
      );
    } else {
      return Container();
    }
  }
}
