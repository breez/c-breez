import 'package:breez_sdk/sdk.dart';
import 'package:flutter/foundation.dart';

class PaymentFilters implements Exception {
  final List<PaymentTypeFilter>? filters;
  final int? fromTimestamp;
  final int? toTimestamp;

  PaymentFilters({this.filters = PaymentTypeFilter.values, this.fromTimestamp, this.toTimestamp});

  PaymentFilters.initial() : this();

  PaymentFilters copyWith({List<PaymentTypeFilter>? filters, int? fromTimestamp, int? toTimestamp}) {
    return PaymentFilters(
      filters: filters ?? this.filters,
      fromTimestamp: fromTimestamp,
      toTimestamp: toTimestamp,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;

    final PaymentFilters otherFilters = other as PaymentFilters;

    return listEquals(filters, otherFilters.filters) &&
        fromTimestamp == otherFilters.fromTimestamp &&
        toTimestamp == otherFilters.toTimestamp;
  }

  @override
  int get hashCode {
    return Object.hash(Object.hashAll(filters ?? []), fromTimestamp, toTimestamp);
  }

  factory PaymentFilters.fromJson(Map<String, dynamic> json) {
    return PaymentFilters(
      filters: PaymentTypeFilter.values,
      fromTimestamp: json["fromTimestamp"],
      toTimestamp: json["toTimestamp"],
    );
  }

  Map<String, dynamic> toJson() {
    return {"filters": filters.toString(), "fromTimestamp": fromTimestamp, "toTimestamp": toTimestamp};
  }
}
