import 'package:breez_sdk/bridge_generated.dart';

class RefundState {
  final List<SwapInfo>? refundables;
  final String? refundTxId;
  final String? error;

  RefundState({this.refundables, this.refundTxId, this.error = ""});

  RefundState.initial() : this();

  RefundState copyWith({
    List<SwapInfo>? refundables,
    String? refundTxId,
    String? error,
  }) {
    return RefundState(
        refundables: refundables ?? this.refundables,
        refundTxId: refundTxId ?? this.refundTxId,
        error: error ?? this.error);
  }
}
