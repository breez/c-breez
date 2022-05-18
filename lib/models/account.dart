import 'package:c_breez/models/payment_type.dart';
import 'package:hex/hex.dart';

class Invoice {
  final String bolt11;
  final String paymentHash;
  final String description;
  final int amount;
  final int expiry;
  final int lspFee;

  Invoice(
      {required this.bolt11,
      required this.paymentHash,
      this.description = "",
      required this.amount,
      required this.expiry,
      this.lspFee = 0});

  String get payeeName => "";
  String get payerName => "";
  String get payerImageURL => "";
  String get payeeImageURL => "";
}

class Withdrawal {
  final String txid;
  final String tx;

  Withdrawal(this.txid, this.tx);

  List<int> get txBytes => HEX.decode(tx);
}

class PaymentFilterModel {
  final List<PaymentType> paymentType;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool initial;

  PaymentFilterModel(
    this.paymentType, {
    this.startDate,
    this.endDate,
    this.initial = false,
  });

  PaymentFilterModel.initial()
      : this(
          [
            PaymentType.sent,
            PaymentType.received,
          ],
          initial: true,
        );

  PaymentFilterModel copyWith({
    List<PaymentType>? filter,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return PaymentFilterModel(
      filter ?? paymentType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  factory PaymentFilterModel.fromJson(Map<String, dynamic> json) {
    var paymentType = (json["paymentType"] ?? <int>[]) as List<dynamic>;
    return PaymentFilterModel(
      paymentType
          .map((e) {
            return PaymentType.values[e];
          })
          .cast<PaymentType>()
          .toList(),
      startDate: json["startDate"],
      endDate: json["endDate"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "paymentType": paymentType.map((e) => e.index).toList(),
      "startDate": startDate,
      "endDate": endDate
    };
  }
}
