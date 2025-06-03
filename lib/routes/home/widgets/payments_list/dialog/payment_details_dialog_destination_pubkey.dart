import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/models/payment_minutiae.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/shareable_payment_row.dart';
import 'package:flutter/material.dart';

class PaymentDetailsDestinationPubkey extends StatelessWidget {
  final PaymentMinutiae paymentMinutiae;

  const PaymentDetailsDestinationPubkey({super.key, required this.paymentMinutiae});

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final destinationPubkey = paymentMinutiae.destinationPubkey;
    if (destinationPubkey.isNotEmpty) {
      return ShareablePaymentRow(
        title: texts.payment_details_dialog_single_info_node_id,
        sharedValue: destinationPubkey,
      );
    } else {
      return Container();
    }
  }
}
