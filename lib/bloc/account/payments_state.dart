import 'package:c_breez/models/payment_filter.dart';
import 'package:c_breez/models/payment_info.dart';

class PaymentsState {
  final List<PaymentInfo> nonFilteredItems;
  final List<PaymentInfo> paymentsList;
  final PaymentFilterModel filter;
  final DateTime? firstDate;

  const PaymentsState(
    this.nonFilteredItems,
    this.paymentsList,
    this.filter, [
    this.firstDate,
  ]);

  PaymentsState.initial()
      : this(
          <PaymentInfo>[],
          <PaymentInfo>[],
          PaymentFilterModel.initial(),
          DateTime(DateTime.now().year),
        );

  PaymentsState copyWith({
    List<PaymentInfo>? nonFilteredItems,
    List<PaymentInfo>? paymentsList,
    PaymentFilterModel? filter,
    DateTime? firstDate,
  }) {
    return PaymentsState(
      nonFilteredItems ?? this.nonFilteredItems,
      paymentsList ?? this.paymentsList,
      filter ?? this.filter,
      firstDate ?? this.firstDate,
    );
  }
}
