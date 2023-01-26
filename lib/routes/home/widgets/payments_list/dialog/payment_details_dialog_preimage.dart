import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/shareable_payment_row.dart';
import 'package:flutter/material.dart';

class PaymentDetailsPreimage extends StatelessWidget {
  final Payment paymentInfo;

  const PaymentDetailsPreimage({
    super.key,
    required this.paymentInfo,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    final details = paymentInfo.details.data;
    if (details is LnPaymentDetails && details.paymentPreimage.isNotEmpty) {
      return ShareablePaymentRow(
        title: texts.payment_details_dialog_single_info_pre_image,
        sharedValue: details.paymentPreimage,
      );
    } else {
      return Container();
    }
  }
}
