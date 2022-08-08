import 'package:breez_sdk/sdk.dart';

class PaymentsState {  
  final List<PaymentInfo> paymentsList;
  final PaymentFilter filter;
  final DateTime? firstDate;

  const PaymentsState(    
    this.paymentsList,
    this.filter, [
    this.firstDate,
  ]);

  PaymentsState.initial()
      : this(
          <PaymentInfo>[],          
          PaymentFilter.initial(),
          DateTime(DateTime.now().year),
        );

  PaymentsState copyWith({
    List<PaymentInfo>? nonFilteredItems,
    List<PaymentInfo>? paymentsList,
    PaymentFilter? filter,
    DateTime? firstDate,
  }) {
    return PaymentsState(      
      paymentsList ?? this.paymentsList,
      filter ?? this.filter,
      firstDate ?? this.firstDate,
    );
  }
}
