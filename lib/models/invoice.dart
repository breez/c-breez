import 'package:c_breez/utils/extensions/breez_pos_message_extractor.dart';

class Invoice {
  final String bolt11;
  final String paymentHash;
  final String description;
  final int amountMsat;
  final int expiry;
  final int lspFee;

  const Invoice({
    required this.bolt11,
    required this.paymentHash,
    this.description = "",
    required this.amountMsat,
    required this.expiry,
    this.lspFee = 0,
  });

  String get payeeName => "";

  String get payerName => "";

  String get payerImageURL => "";

  String get payeeImageURL => "";

  String extractDescription() {
    return extractPosMessage(description) ?? description;
  }
}
