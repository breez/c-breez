import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/date.dart';
import 'package:c_breez/widgets/preview/preview.dart';
import 'package:flutter/material.dart';

class PaymentItemSubtitle extends StatelessWidget {
  final Payment _paymentInfo;

  const PaymentItemSubtitle(
    this._paymentInfo, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    final subtitleTextStyle = themeData.paymentItemSubtitleTextStyle;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          BreezDateUtils.formatTimelineRelative(
            DateTime.fromMillisecondsSinceEpoch(
              _paymentInfo.paymentTime * 1000,
            ),
          ),
          style: subtitleTextStyle,
        ),
        _paymentInfo.pending
            ? Text(
                texts.wallet_dashboard_payment_item_balance_pending_suffix,
                style: subtitleTextStyle.copyWith(
                  color: themeData.customData.pendingTextColor,
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}

void main() {
  runApp(
    Preview(
      [
        // Not pending
        PaymentItemSubtitle(
          Payment(
            paymentType: PaymentType.Received,
            id: "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",
            feeMsat: 1234,
            paymentTime: 1661791810,
            amountMsat: 4321000,
            pending: false,
            description: "",
            details: PaymentDetails.ln(
              data: LnPaymentDetails(
                paymentHash: "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",
                label: "",
                destinationPubkey: "0264a67069b7cbd4ea3db0709d9f605e11643a66fe434d77eaf9bf960a323dda5d",
                paymentPreimage: "",
                keysend: false,
                bolt11: "",
              ),
            ),
          ),
        ),

        // Pending
        PaymentItemSubtitle(
          Payment(
            paymentType: PaymentType.Received,
            id: "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",
            feeMsat: 1234,
            paymentTime: 1661791810,
            amountMsat: 4321000,
            pending: true,
            description: "",
            details: PaymentDetails.ln(
              data: LnPaymentDetails(
                paymentHash: "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",
                label: "",
                destinationPubkey: "0264a67069b7cbd4ea3db0709d9f605e11643a66fe434d77eaf9bf960a323dda5d",
                paymentPreimage: "",
                keysend: false,
                bolt11: "",
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
