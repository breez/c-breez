import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/models/payment_minutiae.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/widgets/preview/preview.dart';
import 'package:flutter/material.dart';

class PaymentItemTitle extends StatelessWidget {
  final PaymentMinutiae _paymentMinutiae;

  const PaymentItemTitle(
    this._paymentMinutiae, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      _paymentMinutiae.title,
      style: Theme.of(context).paymentItemTitleTextStyle,
      overflow: TextOverflow.ellipsis,
    );
  }
}

void main() {
  runApp(
    Preview(
      [
        // No title
        PaymentItemTitle(
          PaymentMinutiae.fromPayment(
            const Payment(
              paymentType: PaymentType.Received,
              id: "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",
              feeMsat: 0,
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
          ),
        ),

        // Long title
        PaymentItemTitle(
          PaymentMinutiae.fromPayment(
            const Payment(
              paymentType: PaymentType.Received,
              id: "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",
              feeMsat: 0,
              paymentTime: 1661791810,
              amountMsat: 4321000,
              status: PaymentStatus.Complete,
              description: "A long title\nwith a new line",
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
          ),
        ),

        // Short title
        PaymentItemTitle(
          PaymentMinutiae.fromPayment(
            const Payment(
              paymentType: PaymentType.Received,
              id: "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",
              feeMsat: 0,
              paymentTime: 1661791810,
              amountMsat: 4321000,
              status: PaymentStatus.Complete,
              description: "A short title",
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
          ),
        ),
      ],
    ),
  );
}
