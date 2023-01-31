import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/tx_widget.dart';
import 'package:flutter/material.dart';

class ClosedChannelPaymentDetailsWidget extends StatelessWidget {
  final Payment paymentInfo;

  const ClosedChannelPaymentDetailsWidget({
    Key? key,
    required this.paymentInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    if (!paymentInfo.pending) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            text: TextSpan(
              style: themeData.dialogTheme.contentTextStyle,
              text: texts.payment_details_dialog_closed_channel_local_wallet,
            ),
          ),
          // TODO waiting for closeChannelTxUrl and closeChannelTx
          const TxWidget(
            txURL: "",
            txID: "",
          ),
        ],
      );
    }

    int lockHeight = 0; // TODO pendingExpirationHeight
    double hoursToUnlock = 0.0; // TODO hoursToExpire

    int roundedHoursToUnlock = hoursToUnlock.round();
    String hoursToUnlockStr = roundedHoursToUnlock > 1
        ? texts.payment_details_dialog_closed_channel_about_hours(
            roundedHoursToUnlock.toString(),
          )
        : texts.payment_details_dialog_closed_channel_about_hour;
    String estimation = lockHeight > 0 && hoursToUnlock > 0
        ? texts.payment_details_dialog_closed_channel_transfer_estimation(
            lockHeight,
            hoursToUnlockStr,
          )
        : texts.payment_details_dialog_closed_channel_transfer_no_estimation;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            style: themeData.dialogTheme.contentTextStyle,
            text: estimation,
          ),
        ),
        // TODO waiting for closeChannelTxUrl and closeChannelTx
        const TxWidget(
          txURL: "",
          txID: "",
        ),
        // TODO waiting for remoteCloseChannelTxUrl and remoteCloseChannelTx
        const TxWidget(
          txURL: "",
          txID: "",
        ),
      ],
    );
  }
}
