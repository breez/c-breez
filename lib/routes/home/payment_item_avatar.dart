import 'package:c_breez/models/account.dart';
import 'package:c_breez/widgets/breez_avatar.dart';
import 'package:flutter/material.dart';

class PaymentItemAvatar extends StatelessWidget {
  final PaymentInfo paymentItem;
  final double radius;

  const PaymentItemAvatar(this.paymentItem, {this.radius = 20.0});

  @override
  Widget build(BuildContext context) {
    if (_shouldShowLeadingIcon) {
      IconData icon = [PaymentType.RECEIVED].contains(paymentItem.type)
          ? Icons.add_rounded
          : Icons.remove_rounded;
      Widget child = Icon(icon, color: const Color(0xb3303234));
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white,
        child: child,
      );
    } else {
      return BreezAvatar(paymentItem.imageURL, radius: radius);
    }
  }

  bool get _shouldShowLeadingIcon => paymentItem.keySend;
}
