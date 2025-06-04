import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_sdk/sdk.dart';
import 'package:c_breez/models/payment_minutiae.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/payment_details_closed_channel_dialog.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_amount.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_content_title.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_date.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_description.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_destination_pubkey.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_expiration.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_ln_address.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_lnurl_pay_domain.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_preimage.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_success_action.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_title.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final AutoSizeGroup _labelGroup = AutoSizeGroup();
final AutoSizeGroup _valueGroup = AutoSizeGroup();

final _log = Logger("PaymentDetailsDialog");

class PaymentDetailsDialog extends StatelessWidget {
  final PaymentMinutiae paymentMinutiae;

  PaymentDetailsDialog({super.key, required this.paymentMinutiae}) {
    _log.info("PaymentDetailsDialog for payment: ${paymentMinutiae.id}");
  }

  @override
  Widget build(BuildContext context) {
    if (paymentMinutiae.paymentType == PaymentType.ClosedChannel) {
      return PaymentDetailsDialogClosedChannelDialog(paymentMinutiae: paymentMinutiae);
    }

    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      title: PaymentDetailsDialogTitle(paymentMinutiae: paymentMinutiae),
      contentPadding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PaymentDetailsDialogContentTitle(paymentMinutiae: paymentMinutiae),
              PaymentDetailsDialogDescription(paymentMinutiae: paymentMinutiae),
              PaymentDetailsDialogAmount(
                paymentMinutiae: paymentMinutiae,
                labelAutoSizeGroup: _labelGroup,
                valueAutoSizeGroup: _valueGroup,
              ),
              PaymentDetailsDialogDate(
                paymentMinutiae: paymentMinutiae,
                labelAutoSizeGroup: _labelGroup,
                valueAutoSizeGroup: _valueGroup,
              ),
              PaymentDetailsDialogLnAddress(
                paymentMinutiae: paymentMinutiae,
                labelAutoSizeGroup: _labelGroup,
                valueAutoSizeGroup: _valueGroup,
              ),
              PaymentDetailsDialogLnurlPayDomain(
                paymentMinutiae: paymentMinutiae,
                labelAutoSizeGroup: _labelGroup,
                valueAutoSizeGroup: _valueGroup,
              ),
              PaymentDetailsDialogSuccessAction(paymentMinutiae: paymentMinutiae),
              PaymentDetailsDialogExpiration(
                paymentMinutiae: paymentMinutiae,
                labelAutoSizeGroup: _labelGroup,
              ),
              PaymentDetailsPreimage(paymentMinutiae: paymentMinutiae),
              PaymentDetailsDestinationPubkey(paymentMinutiae: paymentMinutiae),
            ],
          ),
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.0), top: Radius.circular(13.0)),
      ),
    );
  }
}
