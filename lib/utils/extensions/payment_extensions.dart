import 'dart:convert';
import 'dart:typed_data';

import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/generated/breez_translations.dart';
import 'package:c_breez/utils/extensions/breez_pos_message_extractor.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';

final _log = FimberLog("PaymentExtensions");

class PaymentExtensions {
  final Payment _payment;
  final BreezTranslations _texts;
  final Map<String, dynamic> _metadataMap = {};

  PaymentExtensions(this._payment, this._texts) {
    final detailsData = _payment.details.data;
    if (detailsData is LnPaymentDetails) {
      final metadata = detailsData.lnurlMetadata;
      if (metadata != null && metadata.isNotEmpty) {
        try {
          _metadataMap.addAll(json.decode(metadata));
        } catch (e) {
          _log.w("Failed to parse metadata: $metadata", ex: e);
        }
      }
    }
  }

  String title() {
    final description = _payment.description?.replaceAll("\n", " ").trim();
    if (description != null && description.isNotEmpty) {
      return extractPosMessage(description) ?? description;
    }

    final details = _payment.details;
    if (details is PaymentDetails_ClosedChannel) {
      final state = details.data.state;
      switch (state) {
        case ChannelState.PendingOpen:
          return _texts.payment_info_title_pending_opened_channel;
        case ChannelState.Opened:
          return _texts.payment_info_title_opened_channel;
        case ChannelState.PendingClose:
          return _texts.payment_info_title_pending_closed_channel;
        case ChannelState.Closed:
          return _texts.payment_info_title_closed_channel;
      }
    }
    String? title = _metadataMap['text/identifier'] ?? _metadataMap['text/plain'];
    if (title != null) {
      return title;
    }

    return _texts.wallet_dashboard_payment_item_no_title;
  }

  String description() {
    final description = _payment.description?.replaceAll("\n", " ").trim();

    if (description != null && description.startsWith("Bitrefill")) {
      return description.substring(9, description.length).trimLeft();
    }

    if (description != null && description.isNotEmpty) {
      return extractPosMessage(description) ?? description;
    }

    final details = _payment.details;
    if (details is PaymentDetails_ClosedChannel) {
      final state = details.data.state;
      switch (state) {
        case ChannelState.PendingOpen:
          return _texts.payment_info_title_pending_opened_channel;
        case ChannelState.Opened:
          return _texts.payment_info_title_opened_channel;
        case ChannelState.PendingClose:
          return _texts.payment_info_title_pending_closed_channel;
        case ChannelState.Closed:
          return _texts.payment_info_title_closed_channel;
      }
    }
    String? metadataDescription = _metadataMap['text/long-desc'] ?? _metadataMap['text/plain'];
    if (metadataDescription != null) {
      return metadataDescription;
    }

    return _texts.wallet_dashboard_payment_item_no_title;
  }

  Image? image() {
    String? base64String = _metadataMap['image/png;base64'] ?? _metadataMap['image/jpeg;base64'];
    if (base64String != null && base64String.isNotEmpty) {
      if (base64String.startsWith("data:image")) {
        base64String = base64String.split(",").last;
      }
      Uint8List bytes;
      try {
        bytes = base64Decode(base64String);
      } catch (e) {
        _log.w("Failed to decode image: $base64String", ex: e);
        return null;
      }
      if (bytes.isNotEmpty) {
        const imageSize = 128.0;
        return Image.memory(
          bytes,
          width: imageSize,
          fit: BoxFit.fitWidth,
        );
      }
    }
    return null;
  }

  bool hasDescription() {
    final description = _payment.description;
    return description != null && description.isNotEmpty;
  }

  bool hasMetadata() {
    return _metadataMap.isNotEmpty;
  }

  bool isKeySend() {
    final details = _payment.details.data;
    return (details is LnPaymentDetails) ? details.keysend : false;
  }
}
