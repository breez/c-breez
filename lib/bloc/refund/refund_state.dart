import 'package:breez_sdk/bridge_generated.dart';

class RefundState {
  final List<SwapInfo>? refundables;

  RefundState({this.refundables});

  RefundState.initial() : this();

  RefundState copyWith({
    List<SwapInfo>? refundables,
  }) {
    return RefundState(
      refundables: refundables ?? this.refundables,
    );
  }
}
