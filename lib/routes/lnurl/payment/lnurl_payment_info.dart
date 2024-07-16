class LNURLPaymentInfo {
  final int amountSat;
  final String? comment;

  const LNURLPaymentInfo({
    required this.amountSat,
    this.comment,
  });
}
