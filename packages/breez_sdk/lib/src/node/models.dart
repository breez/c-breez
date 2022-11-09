

enum PaymentType {
  sent,
  received,
}

extension IncomePaymentType on PaymentType {
  bool get isIncome => this == PaymentType.received;
}

class PaymentInfo {
  final PaymentType type;
  final int amountMsat;
  final int feeMsat;
  final int creationTimestamp;
  final bool keySend;
  final String paymentHash;
  final String? preimage;
  final String destination;
  final bool pending;
  final int? pendingExpirationTimestamp;
  final String description;
  final String longTitle;
  final String shortTitle;
  final String? imageURL;

  const PaymentInfo({
    required this.type,
    required this.amountMsat,
    required this.feeMsat,
    required this.creationTimestamp,
    this.pending = false,
    this.keySend = false,
    required this.paymentHash,
    this.preimage,
    required this.destination,
    this.pendingExpirationTimestamp,
    this.description = "",
    this.longTitle = "",
    required this.shortTitle,
    this.imageURL,
  });

  int get amountSat => amountMsat ~/ 1000;
  int get feeSat => feeMsat ~/ 1000;
}

class PaymentFilter {
  final List<PaymentType> paymentType;
  final DateTime? startDate;
  final DateTime? endDate;

  const PaymentFilter(
    this.paymentType, {
    this.startDate,
    this.endDate,
  });

  PaymentFilter.initial()
      : this([
          PaymentType.sent,
          PaymentType.received,
        ]);

  bool allowAll() {
    return paymentType.contains(PaymentType.sent) &&
        paymentType.contains(PaymentType.received) &&
        startDate == null &&
        endDate == null;
  }

  PaymentFilter copyWith({
    List<PaymentType>? filter,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return PaymentFilter(
      filter ?? paymentType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  bool includes(PaymentInfo p) {
    if (!paymentType.contains(p.type)) {
      return false;
    }
    if (startDate != null && p.creationTimestamp.toInt() * 1000 < startDate!.millisecondsSinceEpoch) {
      return false;
    }
    if (endDate != null && p.creationTimestamp.toInt() * 1000 > endDate!.millisecondsSinceEpoch) {
      return false;
    }
    return true;
  }

  factory PaymentFilter.fromJson(Map<String, dynamic> json) {
    var paymentType = (json["paymentType"] ?? <int>[]) as List<dynamic>;
    return PaymentFilter(
      paymentType
          .map((e) {
            return PaymentType.values[e];
          })
          .cast<PaymentType>()
          .toList(),
      startDate: json["startDate"] != null
          ? DateTime.parse(json["startDate"] as String)
          : null,
      endDate: json["endDate"] != null
          ? DateTime.parse(json["endDate"] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "paymentType": paymentType.map((e) => e.index).toList(),
      "startDate": startDate?.toIso8601String(),
      "endDate": endDate?.toIso8601String()
    };
  }
}

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