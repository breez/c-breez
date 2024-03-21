import 'package:breez_sdk/bridge_generated.dart';

class RefundState {
  final List<SwapInfo>? refundables;
  final String? refundTxId;
  final String? refundablesError;
  final String? refundError;

  RefundState({
    this.refundables,
    this.refundTxId,
    this.refundablesError = "",
    this.refundError = "",
  });

  RefundState.initial() : this();

  RefundState copyWith({
    List<SwapInfo>? refundables,
    String? refundTxId,
    String? refundablesError,
    String? refundError,
  }) {
    return RefundState(
      refundables: refundables ?? this.refundables,
      refundTxId: refundTxId ?? this.refundTxId,
      refundablesError: refundablesError ?? this.refundablesError,
      refundError: refundError ?? this.refundError,
    );
  }
}
