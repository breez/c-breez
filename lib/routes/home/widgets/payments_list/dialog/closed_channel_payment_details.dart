import 'package:breez_sdk/bridge_generated.dart' as sdk;
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/config.dart';
import 'package:c_breez/models/payment_minutiae.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/tx_widget.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:flutter/material.dart';

class ClosedChannelPaymentDetailsWidget extends StatelessWidget {
  final PaymentMinutiae paymentMinutiae;

  const ClosedChannelPaymentDetailsWidget({
    Key? key,
    required this.paymentMinutiae,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();
    return FutureBuilder<Config>(
      future: Config.instance(),
      builder: (BuildContext context, AsyncSnapshot<Config> snapshot) {
        if (snapshot.hasData) {
          final blockExplorer = snapshot.data!.defaultMempoolUrl;
          if (paymentMinutiae.status == sdk.PaymentStatus.Complete) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: TextSpan(
                    style: themeData.dialogTheme.contentTextStyle,
                    text: texts.payment_details_dialog_closed_channel_local_wallet,
                  ),
                ),
                if (paymentMinutiae.paymentType == sdk.PaymentType.ClosedChannel &&
                    paymentMinutiae.closingTxid != null) ...[
                  TxWidget(
                    txURL: "$blockExplorer/tx/${paymentMinutiae.closingTxid!}",
                    txID: paymentMinutiae.closingTxid!,
                  ),
                ],
              ],
            );
          }
          // TODO pendingExpirationHeight
          // TODO hoursToExpire
          String estimation = texts.payment_details_dialog_closed_channel_transfer_no_estimation;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: TextSpan(
                  style: themeData.dialogTheme.contentTextStyle,
                  text: estimation,
                ),
              ),
              if (paymentMinutiae.fundingTxid != null) ...[
                TxWidget(
                  txURL: "$blockExplorer/tx/${paymentMinutiae.fundingTxid!}",
                  txID: paymentMinutiae.fundingTxid!,
                ),
              ],
              if (paymentMinutiae.closingTxid != null) ...[
                TxWidget(
                  txURL: "$blockExplorer/tx/${paymentMinutiae.closingTxid!}",
                  txID: paymentMinutiae.closingTxid!,
                ),
              ]
            ],
          );
        } else {
          return const Loader();
        }
      },
    );
  }
}
