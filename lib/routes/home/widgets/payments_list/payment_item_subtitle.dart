import 'package:breez_sdk/sdk.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/date.dart';
import 'package:c_breez/widgets/preview/preview.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

class PaymentItemSubtitle extends StatelessWidget {
  final PaymentInfo _paymentInfo;

  const PaymentItemSubtitle(
    this._paymentInfo, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    final caption = themeData.isBreezLight
        ? const TextStyle(
            color: Color(0xb3303234),
            fontSize: 10.5,
            fontWeight: FontWeight.w400,
            height: 1.16,
            letterSpacing: 0.39,
          )
        : TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 10.5,
            fontWeight: FontWeight.w400,
            height: 1.16,
            letterSpacing: 0.39,
          );

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          BreezDateUtils.formatTimelineRelative(
            DateTime.fromMillisecondsSinceEpoch(
              _paymentInfo.creationTimestamp.toInt() * 1000,
            ),
          ),
          style: caption,
        ),
        _paymentInfo.pending
            ? Text(
                texts.wallet_dashboard_payment_item_balance_pending_suffix,
                style: caption.copyWith(
                  color: theme.customData[theme.themeId]?.pendingTextColor,
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}

void main() {
  runApp(Preview([
    // Not pending
    PaymentItemSubtitle(PaymentInfo(
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

    // Pending
    PaymentItemSubtitle(PaymentInfo(
      type: PaymentType.received,
      amountMsat: Int64(4321000),
      feeMsat: Int64(0),
      creationTimestamp: Int64(1661791810),
      pending: true,
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
  ]));
}
