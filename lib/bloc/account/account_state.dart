import 'dart:convert';

import 'package:c_breez/bloc/account/payment_filters.dart';
import 'package:c_breez/models/payment_minutiae.dart';
import 'package:flutter/foundation.dart';

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
      verificationStatus: verificationStatus ?? this.verificationStatus,
    );
  }

  int get reserveAmountSat => balanceSat - maxAllowedToPaySat;

  bool get isFeesApplicable => maxAllowedToReceiveSat > maxInboundLiquiditySat;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;

    final AccountState otherState = other as AccountState;

    return id == otherState.id &&
        initial == otherState.initial &&
        blockheight == otherState.blockheight &&
        balanceSat == otherState.balanceSat &&
        walletBalanceSat == otherState.walletBalanceSat &&
        maxAllowedToPaySat == otherState.maxAllowedToPaySat &&
        maxAllowedToReceiveSat == otherState.maxAllowedToReceiveSat &&
        maxPaymentAmountSat == otherState.maxPaymentAmountSat &&
        maxChanReserveSat == otherState.maxChanReserveSat &&
        listEquals(connectedPeers, otherState.connectedPeers) &&
        maxInboundLiquiditySat == otherState.maxInboundLiquiditySat &&
        listEquals(payments, otherState.payments) &&
        paymentFilters == otherState.paymentFilters &&
        verificationStatus == otherState.verificationStatus;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      initial,
      blockheight,
      balanceSat,
      walletBalanceSat,
      maxAllowedToPaySat,
      maxAllowedToReceiveSat,
      maxPaymentAmountSat,
      maxChanReserveSat,
      Object.hashAll(connectedPeers),
      maxInboundLiquiditySat,
      Object.hashAll(payments),
      paymentFilters,
      verificationStatus,
    );
  }

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
      verificationStatus: json["verificationStatus"] != null
          ? VerificationStatus.values[json["verificationStatus"]]
          : VerificationStatus.UNVERIFIED,
    );
  }

  @override
  String toString() => jsonEncode(toJson());
}
