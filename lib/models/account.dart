import 'package:fixnum/fixnum.dart';
import 'package:hex/hex.dart';

class Invoice {
  final String bolt11;
  final String description;
  final Int64 amount;
  final Int64 expiry;
  final Int64 lspFee;

  Invoice(
      {required this.bolt11,
      this.description = "",
      required this.amount,
      required this.expiry,
      this.lspFee = Int64.ZERO});

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

  PaymentFilterModel(this.paymentType, this.startDate, this.endDate,
      {this.initial = false});

  PaymentFilterModel.initial()
      : this([
          PaymentType.SENT,
          PaymentType.RECEIVED,
        ], null, null, initial: true);

  PaymentFilterModel copyWith(
      {List<PaymentType>? filter, DateTime? startDate, DateTime? endDate}) {
    return PaymentFilterModel(filter ?? paymentType,
        startDate ?? this.startDate, endDate ?? this.endDate);
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
        json["startDate"],
        json["endDate"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "paymentType": paymentType.map((e) => e.index).toList(),
      "startDate": startDate,
      "endDate": endDate
    };
  }
}

//enum PaymentType { DEPOSIT, WITHDRAWAL, SENT, RECEIVED, CLOSED_CHANNEL }
enum PaymentType { SENT, RECEIVED }

class PaymentInfo {
  final PaymentType type;
  final Int64 amountMsat;
  final Int64 fee;
  final Int64 creationTimestamp;
  final bool keySend;
  final String paymentHash;
  final String? preimage;
  final String destination;
  final bool pending;
  final Int64? pendingExpirationTimestamp;
  final String description;
  final String longTitle;
  final String shortTitle;
  final String? imageURL;

  PaymentInfo(
      {required this.type,
      required this.amountMsat,
      required this.fee,
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
      this.imageURL});

  Int64 get amountSat => amountMsat ~/ 1000;
}
