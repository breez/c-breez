import 'dart:convert';

import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/generated/breez_translations.dart';
import 'package:c_breez/utils/extensions/breez_pos_message_extractor.dart';

extension PaymentExtensions on Payment {
  String extractTitle(BreezTranslations texts) {
    final description = this.description?.replaceAll("\n", " ").trim();
    if (description != null && description.isNotEmpty) {
      return extractPosMessage(description) ?? description;
    }

    final details = this.details;
    if (details is PaymentDetails_ClosedChannel) {
      final state = details.data.state;
      switch (state) {
        case ChannelState.PendingOpen:
          return texts.payment_info_title_pending_opened_channel;
        case ChannelState.Opened:
          return texts.payment_info_title_opened_channel;
        case ChannelState.PendingClose:
          return texts.payment_info_title_pending_closed_channel;
        case ChannelState.Closed:
          return texts.payment_info_title_closed_channel;
      }
    }
    final detailsData = details.data;
    if (detailsData is LnPaymentDetails && detailsData.lnurlMetadata != null) {
      final metadataMap = {
        for (var v in json.decode(detailsData.lnurlMetadata!)) v[0] as String: v[1],
      };
      String? title = metadataMap['text/identifier'] ?? metadataMap['text/plain'];
      if (title != null) {
        return title;
      }
    }

    return texts.wallet_dashboard_payment_item_no_title;
  }

  String extractDescription(BreezTranslations texts) {
    final description = this.description?.replaceAll("\n", " ").trim();

    if (description != null && description.startsWith("Bitrefill")) {
      return description.substring(9, description.length).trimLeft();
    }

    if (description != null && description.isNotEmpty) {
      return extractPosMessage(description) ?? description;
    }

    final details = this.details;
    if (details is PaymentDetails_ClosedChannel) {
      final state = details.data.state;
      switch (state) {
        case ChannelState.PendingOpen:
          return texts.payment_info_title_pending_opened_channel;
        case ChannelState.Opened:
          return texts.payment_info_title_opened_channel;
        case ChannelState.PendingClose:
          return texts.payment_info_title_pending_closed_channel;
        case ChannelState.Closed:
          return texts.payment_info_title_closed_channel;
      }
    }
    final detailsData = details.data;
    if (detailsData is LnPaymentDetails && detailsData.lnurlMetadata != null) {
      final metadataMap = {
        for (var v in json.decode(detailsData.lnurlMetadata!)) v[0] as String: v[1],
      };
      String? description = metadataMap['text/long-desc'] ?? metadataMap['text/plain'];
      if (description != null) {
        return description;
      }
    }

    return texts.wallet_dashboard_payment_item_no_title;
  }
}
