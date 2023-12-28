import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/models/payment_minutiae.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/date.dart';
import 'package:c_breez/widgets/preview/preview.dart';
import 'package:flutter/material.dart';

class PaymentItemSubtitle extends StatelessWidget {
  final PaymentMinutiae _paymentMinutiae;

  const PaymentItemSubtitle(
    this._paymentMinutiae, {
    super.key,
  });

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
          BreezDateUtils.formatTimelineRelative(_paymentMinutiae.paymentTime),
          style: subtitleTextStyle,
        ),
        _paymentMinutiae.status == PaymentStatus.Pending
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
          PaymentMinutiae.fromPayment(
            const Payment(
              paymentType: PaymentType.Received,
              id: "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",
              feeMsat: 1234,
              paymentTime: 1661791810,
              amountMsat: 4321000,
              status: PaymentStatus.Complete,
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
            getSystemAppLocalizations(),
            800000,
          ),
        ),

        // Pending
        PaymentItemSubtitle(
          PaymentMinutiae.fromPayment(
            const Payment(
              paymentType: PaymentType.Received,
              id: "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",
              feeMsat: 1234,
              paymentTime: 1661791810,
              amountMsat: 4321000,
              status: PaymentStatus.Pending,
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
            getSystemAppLocalizations(),
            800000,
          ),
        ),
      ],
    ),
  );
}
