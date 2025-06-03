import 'dart:convert';

import 'package:c_breez/bloc/account/payment_filters.dart';
import 'package:c_breez/models/payment_minutiae.dart';

const initialInboundCapacity = 4000000;

enum ConnectionStatus { CONNECTING, CONNECTED, DISCONNECTED }

enum VerificationStatus { UNVERIFIED, VERIFIED }

class AccountState {
  final String? id;
  final bool initial;
  final int blockheight;
  final int balanceSat;
  final int walletBalanceSat;
  final int maxAllowedToPaySat;
  final int maxAllowedToReceiveSat;
  final int maxPaymentAmountSat;
  final int maxChanReserveSat;
  final List<String> connectedPeers;
  final int maxInboundLiquiditySat;
  final List<PaymentMinutiae> payments;
  final PaymentFilters paymentFilters;
  final ConnectionStatus? connectionStatus;
  final VerificationStatus? verificationStatus;

  const AccountState({
    required this.id,
    required this.initial,
    required this.blockheight,
    required this.balanceSat,
    required this.walletBalanceSat,
    required this.maxAllowedToPaySat,
    required this.maxAllowedToReceiveSat,
    required this.maxPaymentAmountSat,
    required this.maxChanReserveSat,
    required this.connectedPeers,
    required this.maxInboundLiquiditySat,
    required this.payments,
    required this.paymentFilters,
    required this.connectionStatus,
    this.verificationStatus = VerificationStatus.UNVERIFIED,
  });

  AccountState.initial()
    : this(
        id: null,
        initial: true,
        blockheight: 0,
        maxAllowedToPaySat: 0,
        maxAllowedToReceiveSat: 0,
        maxPaymentAmountSat: 0,
        maxChanReserveSat: 0,
        connectedPeers: List.empty(),
        maxInboundLiquiditySat: 0,
        balanceSat: 0,
        walletBalanceSat: 0,
        payments: [],
        paymentFilters: PaymentFilters.initial(),
        connectionStatus: null,
        verificationStatus: VerificationStatus.UNVERIFIED,
      );

  AccountState copyWith({
    String? id,
    bool? initial,
    int? blockheight,
    int? balanceSat,
    int? walletBalanceSat,
    int? maxAllowedToPaySat,
    int? maxAllowedToReceiveSat,
    int? maxPaymentAmountSat,
    int? maxChanReserveSat,
    List<String>? connectedPeers,
    int? maxInboundLiquiditySat,
    List<PaymentMinutiae>? payments,
    PaymentFilters? paymentFilters,
    ConnectionStatus? connectionStatus,
    VerificationStatus? verificationStatus,
  }) {
    return AccountState(
      id: id ?? this.id,
      initial: initial ?? this.initial,
      balanceSat: balanceSat ?? this.balanceSat,
      walletBalanceSat: walletBalanceSat ?? this.walletBalanceSat,
      maxAllowedToPaySat: maxAllowedToPaySat ?? this.maxAllowedToPaySat,
      maxAllowedToReceiveSat: maxAllowedToReceiveSat ?? this.maxAllowedToReceiveSat,
      maxPaymentAmountSat: maxPaymentAmountSat ?? this.maxPaymentAmountSat,
      blockheight: blockheight ?? this.blockheight,
      maxChanReserveSat: maxChanReserveSat ?? this.maxChanReserveSat,
      connectedPeers: connectedPeers ?? this.connectedPeers,
      maxInboundLiquiditySat: maxInboundLiquiditySat ?? this.maxInboundLiquiditySat,
      payments: payments ?? this.payments,
      paymentFilters: paymentFilters ?? this.paymentFilters,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      verificationStatus: verificationStatus ?? this.verificationStatus,
    );
  }

  int get reserveAmountSat => balanceSat - maxAllowedToPaySat;

  bool get isFeesApplicable => maxAllowedToReceiveSat > maxInboundLiquiditySat;

  // TODO: Add payments toJson
  Map<String, dynamic>? toJson() {
    return {
      "id": id,
      "initial": initial,
      "blockheight": blockheight,
      "balanceSat": balanceSat,
      "walletBalanceSat": walletBalanceSat,
      "maxAllowedToPaySat": maxAllowedToPaySat,
      "maxAllowedToReceiveSat": maxAllowedToReceiveSat,
      "maxPaymentAmountSat": maxPaymentAmountSat,
      "maxChanReserveSat": maxChanReserveSat,
      "maxInboundLiquiditySat": maxInboundLiquiditySat,
      "paymentFilters": paymentFilters.toJson(),
      "connectionStatus": connectionStatus?.index,
      "verificationStatus": verificationStatus?.index,
    };
  }

  // TODO: Generate payments fromJson
  factory AccountState.fromJson(Map<String, dynamic> json) {
    return AccountState(
      id: json["id"],
      initial: json["initial"],
      blockheight: json["blockheight"],
      balanceSat: json["balanceSat"],
      walletBalanceSat: json["walletBalanceSat"],
      maxAllowedToPaySat: json["maxAllowedToPaySat"],
      maxAllowedToReceiveSat: json["maxAllowedToReceiveSat"],
      maxPaymentAmountSat: json["maxPaymentAmountSat"],
      maxChanReserveSat: json["maxChanReserveSat"],
      connectedPeers: <String>[],
      maxInboundLiquiditySat: json["maxInboundLiquiditySat"] ?? 0,
      payments: [],
      paymentFilters: PaymentFilters.fromJson(json["paymentFilters"]),
      connectionStatus: json["connectionStatus"] != null
          ? ConnectionStatus.values[json["connectionStatus"]]
          : ConnectionStatus.CONNECTING,
      verificationStatus: json["verificationStatus"] != null
          ? VerificationStatus.values[json["verificationStatus"]]
          : VerificationStatus.UNVERIFIED,
    );
  }

  @override
  String toString() => jsonEncode(toJson());
}
