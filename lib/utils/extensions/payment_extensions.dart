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

    return texts.wallet_dashboard_payment_item_no_title;
  }
}
