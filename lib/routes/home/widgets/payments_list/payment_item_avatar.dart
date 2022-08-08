import 'package:breez_sdk/sdk.dart' as breez_sdk;
import 'package:c_breez/widgets/breez_avatar.dart';
import 'package:flutter/material.dart';

class PaymentItemAvatar extends StatelessWidget {
  final breez_sdk.PaymentInfo paymentItem;
  final double radius;

  const PaymentItemAvatar(
    this.paymentItem, {
    this.radius = 20.0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_shouldShowLeadingIcon) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white,
        child: Icon(
          paymentItem.type.isIncome ? Icons.add_rounded : Icons.remove_rounded,
          color: const Color(0xb3303234),
        ),
      );
    } else {
      return BreezAvatar(paymentItem.imageURL, radius: radius);
    }
  }

  bool get _shouldShowLeadingIcon => paymentItem.keySend;
}
