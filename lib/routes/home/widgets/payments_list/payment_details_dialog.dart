import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_amount.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_date.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_content_title.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_destination_pubkey.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_expiration.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_preimage.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/payment_details_dialog_title.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';

final AutoSizeGroup _labelGroup = AutoSizeGroup();
final AutoSizeGroup _valueGroup = AutoSizeGroup();

final _log = FimberLog("PaymentDetailsDialog");

Future<void> showPaymentDetailsDialog(
  BuildContext context,
  Payment paymentInfo,
) {
  _log.v("showPaymentDetailsDialog: ${paymentInfo.id}");
  return showDialog<void>(
    useRootNavigator: false,
    context: context,
    builder: (_) => AlertDialog(
      titlePadding: EdgeInsets.zero,
      title: PaymentDetailsDialogTitle(
        paymentInfo: paymentInfo,
      ),
      contentPadding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PaymentDetailsDialogContentTitle(
                paymentInfo: paymentInfo,
              ),
              PaymentDetailsDialogAmount(
                paymentInfo: paymentInfo,
                labelAutoSizeGroup: _labelGroup,
                valueAutoSizeGroup: _valueGroup,
              ),
              PaymentDetailsDialogDate(
                paymentInfo: paymentInfo,
                labelAutoSizeGroup: _labelGroup,
                valueAutoSizeGroup: _valueGroup,
              ),
              PaymentDetailsDialogExpiration(
                paymentInfo: paymentInfo,
                labelAutoSizeGroup: _labelGroup,
              ),
              PaymentDetailsPreimage(
                paymentInfo: paymentInfo,
              ),
              PaymentDetailsDestinationPubkey(
                paymentInfo: paymentInfo,
              ),
            ],
          ),
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(12.0),
          top: Radius.circular(13.0),
        ),
      ),
    ),
  );
}
