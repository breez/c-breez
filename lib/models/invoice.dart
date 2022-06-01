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
}
