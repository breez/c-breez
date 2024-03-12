import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/models/payment_minutiae.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/shareable_payment_row.dart';
import 'package:flutter/material.dart';

class PaymentDetailsDialogLnurlPayDomain extends StatelessWidget {
  final PaymentMinutiae paymentMinutiae;
  final AutoSizeGroup? labelAutoSizeGroup;
  final AutoSizeGroup? valueAutoSizeGroup;

  const PaymentDetailsDialogLnurlPayDomain({
    super.key,
    required this.paymentMinutiae,
    this.labelAutoSizeGroup,
    this.valueAutoSizeGroup,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final lnurlPayDomain = paymentMinutiae.lnurlPayDomain;
    if (lnurlPayDomain.isNotEmpty) {
      return ShareablePaymentRow(
        title: texts.payment_details_dialog_share_lightning_address,
        sharedValue: lnurlPayDomain,
        labelAutoSizeGroup: labelAutoSizeGroup,
        valueAutoSizeGroup: valueAutoSizeGroup,
      );
    } else {
      return Container();
    }
  }
}
