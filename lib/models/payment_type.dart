enum PaymentType {
  sent,
  received,
}

extension IncomePaymentType on PaymentType {
  bool get isIncome => this == PaymentType.received;
}
