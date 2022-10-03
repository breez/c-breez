import 'package:breez_sdk/sdk.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/widgets/preview/preview.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

class PaymentItemTitle extends StatelessWidget {
  final PaymentInfo _paymentInfo;

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
    final shortTitle = _paymentInfo.shortTitle;
    if (shortTitle.isNotEmpty) return shortTitle;

    final longTitle = _paymentInfo.longTitle;
    if (longTitle.isNotEmpty) return longTitle;

    return context.texts().wallet_dashboard_payment_item_no_title;
  }
}

void main() {
  runApp(Preview([
    // No title
    PaymentItemTitle(PaymentInfo(
      type: PaymentType.received,
      amountMsat: Int64(4321000),
      feeMsat: Int64(0),
      creationTimestamp: Int64(1661791810),
      pending: false,
      keySend: false,
      paymentHash: "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",
      preimage: null,
      destination: "0264a67069b7cbd4ea3db0709d9f605e11643a66fe434d77eaf9bf960a323dda5d",
      pendingExpirationTimestamp: null,
      description: "",
      longTitle: "",
      shortTitle: "",
      imageURL: null,
    )),

    // Long title
    PaymentItemTitle(PaymentInfo(
      type: PaymentType.received,
      amountMsat: Int64(4321000),
      feeMsat: Int64(0),
      creationTimestamp: Int64(1661791810),
      pending: false,
      keySend: false,
      paymentHash: "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",
      preimage: null,
      destination: "0264a67069b7cbd4ea3db0709d9f605e11643a66fe434d77eaf9bf960a323dda5d",
      pendingExpirationTimestamp: null,
      description: "",
      longTitle: "A long title\nwith a new line",
      shortTitle: "",
      imageURL: null,
    )),

    // Short title
    PaymentItemTitle(PaymentInfo(
      type: PaymentType.received,
      amountMsat: Int64(4321000),
      feeMsat: Int64(0),
      creationTimestamp: Int64(1661791810),
      pending: false,
      keySend: false,
      paymentHash: "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",
      preimage: null,
      destination: "0264a67069b7cbd4ea3db0709d9f605e11643a66fe434d77eaf9bf960a323dda5d",
      pendingExpirationTimestamp: null,
      description: "",
      longTitle: "",
      shortTitle: "A short title",
      imageURL: null,
    )),
  ]));
}
