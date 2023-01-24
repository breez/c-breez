import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/shareable_payment_row.dart';
import 'package:flutter/material.dart';

class PaymentDetailsDestinationPubkey extends StatelessWidget {
  final Payment paymentInfo;

  const PaymentDetailsDestinationPubkey({
    super.key,
    required this.paymentInfo,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    LnPaymentDetails? paymentDetails;
    if (paymentInfo.details is LnPaymentDetails) {
      paymentDetails = paymentInfo.details as LnPaymentDetails;
    }
    final destinationPubkey = paymentDetails?.destinationPubkey.trim();

    if (destinationPubkey == null || destinationPubkey.isEmpty) {
      return Container();
    }

    return ShareablePaymentRow(
      title: texts.payment_details_dialog_single_info_node_id,
      sharedValue: destinationPubkey,
    );
  }
}
