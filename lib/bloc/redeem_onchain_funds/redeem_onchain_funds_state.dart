import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';

class RedeemOnchainFundsState {
  final Uint8List? txId;
  final String? error;

  RedeemOnchainFundsState({this.txId, this.error = ""});

  RedeemOnchainFundsState.initial() : this();

  RedeemOnchainFundsState copyWith({
    Uint8List? txId,
    String? error,
  }) =>
      RedeemOnchainFundsState(
        txId: txId ?? this.txId,
        error: error ?? this.error,
      );
}
