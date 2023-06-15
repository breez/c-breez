import 'dart:convert';
import 'dart:typed_data';

import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/generated/breez_translations.dart';
import 'package:c_breez/utils/extensions/breez_pos_message_extractor.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';

final _log = FimberLog("PaymentDetails");

/// Hold formatted data from Payment to be displayed in the UI, using the minutiae noun instead of details or
/// info to avoid conflicts and make it easier to differentiate when reading the code.
class PaymentMinutiae {
  final String id;
  final String title;
  final bool hasDescription;
  final String description;
  final String destinationPubkey;
  final String lnAddress;
  final String paymentPreimage;
  final String successActionMessage;
  final String? successActionUrl;
  final PaymentType paymentType;
  final DateTime paymentTime;
  final Image? image;
  final int feeSat;
  final int feeMilliSat;
  final int amountSat;
  final bool hasMetadata;
  final bool isKeySend;
  final bool isPending;

  const PaymentMinutiae({
    required this.id,
    required this.title,
    required this.hasDescription,
    required this.description,
    required this.destinationPubkey,
    required this.lnAddress,
    required this.paymentPreimage,
    required this.successActionMessage,
    required this.successActionUrl,
    required this.paymentType,
    required this.paymentTime,
    required this.image,
    required this.feeSat,
    required this.feeMilliSat,
    required this.amountSat,
    required this.hasMetadata,
    required this.isKeySend,
    required this.isPending,
  });

  factory PaymentMinutiae.fromPayment(Payment payment, BreezTranslations texts) {
    final factory = _PaymentMinutiaeFactory(payment, texts);
    return PaymentMinutiae(
      id: payment.id,
      title: factory._title(),
      hasDescription: factory._hasDescription(),
      description: factory._description(),
      destinationPubkey: factory._destinationPubkey(),
      lnAddress: factory._lnAddress(),
      paymentPreimage: factory._paymentPreimage(),
      successActionMessage: factory._successActionMessage(),
      successActionUrl: factory._successActionUrl(),
      paymentType: payment.paymentType,
      paymentTime: factory._paymentTime(),
      image: factory._image(),
      feeSat: factory._feeSat(),
      feeMilliSat: payment.feeMsat,
      amountSat: factory._amountSat(),
      hasMetadata: factory._hasMetadata(),
      isKeySend: factory._isKeySend(),
      isPending: payment.pending,
    );
  }
}

class _PaymentMinutiaeFactory {
  final Payment _payment;
  final BreezTranslations _texts;
  final Map<String, dynamic> _metadataMap = {};

  _PaymentMinutiaeFactory(this._payment, this._texts) {
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

  String _title() {
    final description = _payment.description?.replaceAll("\n", " ").trim();
    if (description != null && description.isNotEmpty) {
      if (description == "Bitcoin Transfer") {
        return _texts.payment_info_title_bitcoin_transfer;
      }
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

  String _description() {
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

  String _destinationPubkey() {
    final details = _payment.details.data;
    if (details is LnPaymentDetails) {
      return details.destinationPubkey;
    }
    return "";
  }

  String _lnAddress() {
    final details = _payment.details.data;
    if (details is LnPaymentDetails) {
      return details.lnAddress ?? "";
    }
    return "";
  }

  String _paymentPreimage() {
    final details = _payment.details.data;
    if (details is LnPaymentDetails) {
      return details.paymentPreimage;
    }
    return "";
  }

  String _successActionMessage() {
    final details = _payment.details.data;
    if (details is LnPaymentDetails) {
      final successAction = details.lnurlSuccessAction;
      if (successAction is SuccessActionProcessed_Message) {
        return successAction.data.message;
      } else if (successAction is SuccessActionProcessed_Url) {
        return successAction.data.description;
      } else if (successAction is SuccessActionProcessed_Aes) {
        return "${successAction.data.description} ${successAction.data.plaintext}";
      }
    }
    return "";
  }

  String? _successActionUrl() {
    final details = _payment.details.data;
    if (details is LnPaymentDetails) {
      final successAction = details.lnurlSuccessAction;
      if (successAction is SuccessActionProcessed_Url) {
        return successAction.data.url;
      }
    }
    return null;
  }

  Image? _image() {
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

  DateTime _paymentTime() {
    return DateTime.fromMillisecondsSinceEpoch(_payment.paymentTime * 1000);
  }

  int _feeSat() {
    return _payment.feeMsat ~/ 1000;
  }

  int _amountSat() {
    return _payment.amountMsat ~/ 1000;
  }

  bool _hasDescription() {
    final description = _payment.description;
    return description != null && description.isNotEmpty;
  }

  bool _hasMetadata() {
    return _metadataMap.isNotEmpty;
  }

  bool _isKeySend() {
    final details = _payment.details.data;
    return (details is LnPaymentDetails) ? details.keysend : false;
  }
}
