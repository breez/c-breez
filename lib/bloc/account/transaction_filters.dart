import 'package:breez_sdk/bridge_generated.dart';
import 'package:flutter/foundation.dart';

class TransactionFilters implements Exception {
  final PaymentTypeFilter? filter;
  final int? fromTimestamp;
  final int? toTimestamp;

  TransactionFilters({
    this.filter = PaymentTypeFilter.All,
    this.fromTimestamp,
    this.toTimestamp,
  });

  TransactionFilters.initial() : this();

  TransactionFilters copyWith({
    PaymentTypeFilter? filter,
    int? fromTimestamp,
    int? toTimestamp,
  }) {
    return TransactionFilters(
      filter: filter ?? this.filter,
      fromTimestamp: fromTimestamp ?? this.fromTimestamp,
      toTimestamp: toTimestamp ?? this.toTimestamp,
    );
  }

  factory TransactionFilters.fromJson(Map<String, dynamic> json) {
    return TransactionFilters(
      filter: PaymentTypeFilter.values.firstWhere(
          (n) => n.name == json["filter"],
          orElse: () => PaymentTypeFilter.All),
      fromTimestamp: json["fromTimestamp"],
      toTimestamp: json["toTimestamp"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "filter": describeEnum(filter!),
      "fromTimestamp": fromTimestamp,
      "toTimestamp": toTimestamp,
    };
  }
}
