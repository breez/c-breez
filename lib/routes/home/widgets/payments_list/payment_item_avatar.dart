import 'package:breez_sdk/sdk.dart';
import 'package:c_breez/models/payment_minutiae.dart';
import 'package:c_breez/widgets/breez_avatar.dart';
import 'package:flutter/material.dart';

class PaymentItemAvatar extends StatelessWidget {
  final PaymentMinutiae paymentMinutiae;
  final double radius;

  const PaymentItemAvatar(this.paymentMinutiae, {this.radius = 20.0, super.key});

  @override
  Widget build(BuildContext context) {
    if (paymentMinutiae.hasDescription ||
        paymentMinutiae.hasMetadata ||
        paymentMinutiae.isKeySend ||
        paymentMinutiae.paymentType == PaymentType.ClosedChannel) {
      final metadataImage = paymentMinutiae.image;

      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white,
        child: (metadataImage != null)
            ? metadataImage
            : Icon(
                paymentMinutiae.paymentType == PaymentType.Received
                    ? Icons.add_rounded
                    : Icons.remove_rounded,
                color: const Color(0xb3303234),
              ),
      );
    } else {
      return BreezAvatar("", radius: radius);
    }
  }
}
