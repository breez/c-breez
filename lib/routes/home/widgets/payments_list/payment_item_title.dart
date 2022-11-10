import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/widgets/preview/preview.dart';
import 'package:flutter/material.dart';

class PaymentItemTitle extends StatelessWidget {
  final LightningTransaction _paymentInfo;

  const PaymentItemTitle(
    this._paymentInfo, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      _title(context).replaceAll("\n", " "),
      style: Theme.of(context).paymentItemTitleTextStyle,
      overflow: TextOverflow.ellipsis,
    );
  }

  String _title(BuildContext context) {
    final shortTitle = _paymentInfo.label;
    if (shortTitle.isNotEmpty) return shortTitle;

    final longTitle = _paymentInfo.label;
    if (longTitle.isNotEmpty) return longTitle;

    return context.texts().wallet_dashboard_payment_item_no_title;
  }
}

void main() {
  runApp(Preview([
    // No title
    PaymentItemTitle(
      LightningTransaction(
        paymentType: "received",
        label: "",
        bolt11: "",
        destinationPubkey:
            "0264a67069b7cbd4ea3db0709d9f605e11643a66fe434d77eaf9bf960a323dda5d",
        paymentHash:
            "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",
        feesMsat: 0,
        keysend: false,
        paymentPreimage: "",
        paymentTime: 1661791810,
        amountMsat: 4321000,
        pending: false,
        description: "",
      ),
    ),

    // Long title
    PaymentItemTitle(
      LightningTransaction(
        paymentType: "received",
        label: "A long title\nwith a new line",
        bolt11: "",
        destinationPubkey:
            "0264a67069b7cbd4ea3db0709d9f605e11643a66fe434d77eaf9bf960a323dda5d",
        paymentHash:
            "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",
        feesMsat: 0,
        keysend: false,
        paymentPreimage: "",
        paymentTime: 1661791810,
        amountMsat: 4321000,
        pending: false,
        description: "",
      ),
    ),

    // Short title
    PaymentItemTitle(
      LightningTransaction(
        paymentType: "received",
        label: "A short title",
        bolt11: "",
        destinationPubkey:
            "0264a67069b7cbd4ea3db0709d9f605e11643a66fe434d77eaf9bf960a323dda5d",
        paymentHash:
            "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",
        feesMsat: 0,
        keysend: false,
        paymentPreimage: "",
        paymentTime: 1661791810,
        amountMsat: 4321000,
        pending: false,
        description: "",
      ),
    ),
  ]));
}
