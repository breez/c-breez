import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

class PaymentDetailsDialogExpiration extends StatelessWidget {
  final Payment paymentInfo;
  final AutoSizeGroup? labelAutoSizeGroup;

  const PaymentDetailsDialogExpiration({
    super.key,
    required this.paymentInfo,
    this.labelAutoSizeGroup,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    if (!paymentInfo.pending) {
      return Container();
    }

    return Container(
      height: 36.0,
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: AutoSizeText(
              texts.payment_details_dialog_expiration,
              style: themeData.primaryTextTheme.headlineMedium,
              textAlign: TextAlign.left,
              maxLines: 1,
              group: labelAutoSizeGroup,
            ),
          ),
        ],
      ),
    );
  }
}
