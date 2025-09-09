import 'dart:convert';
import 'dart:typed_data';

import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/generated/breez_translations.dart';
import 'package:c_breez/utils/extensions/breez_pos_message_extractor.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final _log = Logger("PaymentDetails");

/// Hold formatted data from Payment to be displayed in the UI, using the minutiae noun instead of details or
/// info to avoid conflicts and make it easier to differentiate when reading the code.
class PaymentMinutiae {
  final String id;
  final String title;
  final bool hasDescription;
  final String description;
  final String destinationPubkey;
  final String lnAddress;
  final String lnurlPayDomain;
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
  final PaymentStatus status;
  final String? fundingTxid;
  final String? closingTxid;
  final int? pendingExpirationBlock;

  const PaymentMinutiae({
    required this.id,
    required this.title,
    required this.hasDescription,
    required this.description,
    required this.destinationPubkey,
    required this.lnAddress,
    required this.lnurlPayDomain,
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
    required this.status,
    required this.fundingTxid,
    required this.closingTxid,
    required this.pendingExpirationBlock,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;

    final PaymentMinutiae otherPayment = other as PaymentMinutiae;

    return id == otherPayment.id &&
        title == otherPayment.title &&
        hasDescription == otherPayment.hasDescription &&
        description == otherPayment.description &&
        destinationPubkey == otherPayment.destinationPubkey &&
        lnAddress == otherPayment.lnAddress &&
        lnurlPayDomain == otherPayment.lnurlPayDomain &&
        paymentPreimage == otherPayment.paymentPreimage &&
        successActionMessage == otherPayment.successActionMessage &&
        successActionUrl == otherPayment.successActionUrl &&
        paymentType == otherPayment.paymentType &&
        paymentTime == otherPayment.paymentTime &&
        _imageEquals(image, otherPayment.image) &&
        feeSat == otherPayment.feeSat &&
        feeMilliSat == otherPayment.feeMilliSat &&
        amountSat == otherPayment.amountSat &&
        hasMetadata == otherPayment.hasMetadata &&
        isKeySend == otherPayment.isKeySend &&
        status == otherPayment.status &&
        fundingTxid == otherPayment.fundingTxid &&
        closingTxid == otherPayment.closingTxid &&
        pendingExpirationBlock == otherPayment.pendingExpirationBlock;
  }

  @override
  int get hashCode {
    // Split into two groups since Object.hash only accepts up to 20 arguments
    final hash1 = Object.hash(
      id,
      title,
      hasDescription,
      description,
      destinationPubkey,
      lnAddress,
      lnurlPayDomain,
      paymentPreimage,
      successActionMessage,
      successActionUrl,
      paymentType,
      paymentTime,
      _imageHashCode(image),
      feeSat,
      feeMilliSat,
      amountSat,
      hasMetadata,
      isKeySend,
      status,
      fundingTxid,
    );

    final hash2 = Object.hash(closingTxid, pendingExpirationBlock);

    return Object.hash(hash1, hash2);
  }

  // Helper methods for Image comparison
  bool _imageEquals(Image? a, Image? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;

    // For simplicity, compare by width, height, and fit
    // In practice, you might want to compare the actual image data
    return a.width == b.width && a.height == b.height && a.fit == b.fit;
  }

  int _imageHashCode(Image? image) {
    if (image == null) return 0;
    return Object.hash(image.width, image.height, image.fit);
  }

  factory PaymentMinutiae.fromPayment(Payment payment, BreezTranslations texts) {
    final factory = _PaymentMinutiaeFactory(payment, texts);
    return PaymentMinutiae(
      id: payment.id,
      title: factory._title(),
      hasDescription: factory._hasDescription(),
      description: factory._description(),
      destinationPubkey: factory._destinationPubkey(),
      lnAddress: factory._lnAddress(),
      lnurlPayDomain: factory._lnurlPayDomain(),
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
      status: payment.status,
      fundingTxid: factory._fundingTx(),
      closingTxid: factory._closedTx(),
      pendingExpirationBlock: factory._pendingExpirationBlock(),
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
      _parseMetadata(detailsData);
    }
  }

  void _parseMetadata(LnPaymentDetails detailsData) {
    final metadata = detailsData.lnurlMetadata;
    if (metadata == null || metadata.isEmpty) {
      return;
    }

    try {
      final parsed = json.decode(metadata);
      if (parsed is! List) {
        _log.warning("Unknown runtime type of $parsed for $metadata");
        return;
      }

      for (var item in parsed) {
        if (item is! List || item.length != 2) {
          _log.warning("Unknown runtime type of item $item");
          continue;
        }

        final key = item[0];
        final value = item[1];
        if (key is! String) {
          _log.warning("Unknown runtime type of key $key");
          continue;
        }

        _metadataMap[key] = value;
      }
    } catch (e) {
      _log.warning("Failed to parse metadata: $metadata", e);
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

  String _lnurlPayDomain() {
    final details = _payment.details.data;
    if (details is LnPaymentDetails) {
      return details.lnurlPayDomain ?? "";
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
        final result = successAction.result;
        if (result is AesSuccessActionDataResult_Decrypted) {
          return "${result.data.description} ${result.data.plaintext}";
        }
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
        _log.warning("Failed to decode image: $base64String", e);
        return null;
      }
      if (bytes.isNotEmpty) {
        // same value as in breezmobile
        const imageSize = 20 * 0.6 * 2;
        return Image.memory(bytes, width: imageSize, height: imageSize, fit: BoxFit.fitHeight);
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

  String? _fundingTx() {
    final details = _payment.details.data;
    if (details is ClosedChannelPaymentDetails) {
      return details.fundingTxid;
    }
    return null;
  }

  String? _closedTx() {
    final details = _payment.details.data;
    if (details is ClosedChannelPaymentDetails) {
      return details.closingTxid;
    }
    return null;
  }

  int? _pendingExpirationBlock() {
    final details = _payment.details.data;
    if (_payment.status == PaymentStatus.Pending && details is LnPaymentDetails) {
      return details.pendingExpirationBlock;
    }
    return null;
  }
}
