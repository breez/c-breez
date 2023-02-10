import 'package:breez_sdk/bridge_generated.dart';
import 'package:flutter/foundation.dart';

class PaymentFilters implements Exception {
  final PaymentTypeFilter filter;
  final int? fromTimestamp;
  final int? toTimestamp;

  PaymentFilters({
    this.filter = PaymentTypeFilter.All,
    this.fromTimestamp,
    this.toTimestamp,
  });

  PaymentFilters.initial() : this();

  PaymentFilters copyWith({
    PaymentTypeFilter? filter,
    int? fromTimestamp,
    int? toTimestamp,
  }) {
    return PaymentFilters(
      filter: filter ?? this.filter,
      fromTimestamp: fromTimestamp,
      toTimestamp: toTimestamp,
    );
  }

  factory PaymentFilters.fromJson(Map<String, dynamic> json) {
    return PaymentFilters(
      filter: PaymentTypeFilter.values
          .firstWhere((n) => n.name == json["filter"], orElse: () => PaymentTypeFilter.All),
      fromTimestamp: json["fromTimestamp"],
      toTimestamp: json["toTimestamp"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "filter": describeEnum(filter),
      "fromTimestamp": fromTimestamp,
      "toTimestamp": toTimestamp,
    };
  }
}
