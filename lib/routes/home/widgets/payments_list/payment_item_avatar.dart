import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/widgets/breez_avatar.dart';
import 'package:flutter/material.dart';

class PaymentItemAvatar extends StatelessWidget {
  final Payment paymentItem;
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
          paymentItem.paymentType == PaymentType.Received ? Icons.add_rounded : Icons.remove_rounded,
          color: const Color(0xb3303234),
        ),
      );
    } else {
      // paymentItem.imageURL is missing
      return BreezAvatar("", radius: radius);
    }
  }

  bool get _shouldShowLeadingIcon {
    final hasDescription = (paymentItem.description != null && paymentItem.description!.isNotEmpty);
    final details = paymentItem.details.data;
    final isKeySend = (details is LnPaymentDetails) ? details.keysend : false;
    final isClosedChannelPayment = paymentItem.paymentType == PaymentType.ClosedChannel;

    return hasDescription || isKeySend || isClosedChannelPayment;
  }
}
