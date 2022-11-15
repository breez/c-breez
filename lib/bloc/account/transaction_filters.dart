import 'package:breez_sdk/bridge_generated.dart';

class TransactionFilters implements Exception {
  final PaymentTypeFilter? filter;
  final int? fromTimestamp;
  final int? toTimestamp;

  TransactionFilters(
      {this.filter = PaymentTypeFilter.All,
      this.fromTimestamp,
      this.toTimestamp});

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
}
