import 'package:fixnum/fixnum.dart';

enum NodeStatus { connecting, connected, disconnecting, disconnected }

class NodeState {
  final String id;
  final Int64 blockheight;
  final Int64 channelsBalanceMsats;
  final Int64 onchainBalanceMsats;
  final NodeStatus status;
  final Int64 maxAllowedToPayMsats;
  final Int64 maxAllowedToReceiveMsats;
  final Int64 maxPaymentAmountMsats;
  final Int64 maxChanReserveMsats;
  final List<String> connectedPeers;
  final Int64 maxInboundLiquidityMsats;
  final Int64 onChainFeeRate;

  NodeState(
      {required this.id,
      required this.blockheight,
      required this.channelsBalanceMsats,
      required this.onchainBalanceMsats,
      required this.status,
      required this.maxAllowedToPayMsats,
      required this.maxAllowedToReceiveMsats,
      required this.maxPaymentAmountMsats,
      required this.maxChanReserveMsats,
      required this.connectedPeers,
      required this.maxInboundLiquidityMsats,
      required this.onChainFeeRate});
}

enum PaymentType {
  sent,
  received,
}

extension IncomePaymentType on PaymentType {
  bool get isIncome => this == PaymentType.received;
}

class PaymentInfo {
  final PaymentType type;
  final Int64 amountMsat;
  final Int64 feeMsat;
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

  Int64 get amountSat => amountMsat ~/ 1000;
  Int64 get feeSat => feeMsat ~/ 1000;
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
      startDate: json["startDate"],
      endDate: json["endDate"],
    );
  }

  Map<String, dynamic> toJson() {
    return {"paymentType": paymentType.map((e) => e.index).toList(), "startDate": startDate, "endDate": endDate};
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