import 'dart:convert';

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
      final metadataImage = _getMetadataImage();

      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white,
        child: (metadataImage != null)
            ? metadataImage
            : Icon(
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
    bool hasMetadataDescription = false;
    if (details is LnPaymentDetails && details.lnurlMetadata != null) {
      final metadataMap = {
        for (var v in json.decode(details.lnurlMetadata!)) v[0] as String: v[1],
      };
      hasMetadataDescription = metadataMap.isNotEmpty;
    }
    return hasDescription || hasMetadataDescription || isKeySend || isClosedChannelPayment;
  }

  Image? _getMetadataImage() {
    final details = paymentItem.details.data;
    if (details is LnPaymentDetails && details.lnurlMetadata != null) {
      final metadataMap = {
        for (var v in json.decode(details.lnurlMetadata!)) v[0] as String: v[1],
      };
      String? base64String = metadataMap['image/png;base64'] ?? metadataMap['image/jpeg;base64'];
      if (base64String != null) {
        final bytes = base64Decode(base64String);
        if (bytes.isNotEmpty) {
          const imageSize = 128.0;
          return Image.memory(
            bytes,
            width: imageSize,
            fit: BoxFit.fitWidth,
          );
        }
      }
    }
    return null;
  }
}
