import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/utils/extensions/payment_extensions.dart';
import 'package:c_breez/widgets/breez_avatar.dart';
import 'package:flutter/material.dart';

class PaymentItemAvatar extends StatefulWidget {
  final Payment paymentItem;
  final double radius;

  const PaymentItemAvatar(
    this.paymentItem, {
    this.radius = 20.0,
    Key? key,
  }) : super(key: key);

  @override
  State<PaymentItemAvatar> createState() => _PaymentItemAvatarState();
}

class _PaymentItemAvatarState extends State<PaymentItemAvatar> {
  PaymentExtensions? paymentExtensions;

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final paymentExtensions = this.paymentExtensions ??= PaymentExtensions(widget.paymentItem, texts);

    if (paymentExtensions.hasDescription() ||
        paymentExtensions.hasMetadata() ||
        paymentExtensions.isKeySend() ||
        widget.paymentItem.paymentType == PaymentType.ClosedChannel) {
      final metadataImage = paymentExtensions.image();

      return CircleAvatar(
        radius: widget.radius,
        backgroundColor: Colors.white,
        child: (metadataImage != null)
            ? metadataImage
            : Icon(
                widget.paymentItem.paymentType == PaymentType.Received
                    ? Icons.add_rounded
                    : Icons.remove_rounded,
                color: const Color(0xb3303234),
              ),
      );
    } else {
      return BreezAvatar("", radius: widget.radius);
    }
  }
}
