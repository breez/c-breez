import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/shareable_payment_row.dart';
import 'package:flutter/material.dart';

class PaymentDetailsDialogLnAddress extends StatelessWidget {
  final Payment paymentInfo;
  final AutoSizeGroup? labelAutoSizeGroup;
  final AutoSizeGroup? valueAutoSizeGroup;

  const PaymentDetailsDialogLnAddress({
    super.key,
    required this.paymentInfo,
    this.labelAutoSizeGroup,
    this.valueAutoSizeGroup,
  });
  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final details = paymentInfo.details.data;
    if (details is LnPaymentDetails && details.lnAddress != null) {
      return ShareablePaymentRow(
        title: texts.payment_details_dialog_share_lightning_address,
        sharedValue: details.lnAddress!,
        labelAutoSizeGroup: labelAutoSizeGroup,
        valueAutoSizeGroup: valueAutoSizeGroup,
      );
    } else {
      return Container();
    }
  }
}
