import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';

class SweepState {
  final Uint8List? sweepTxId;
  final String? error;

  SweepState({this.sweepTxId, this.error = ""});

  SweepState.initial() : this();

  SweepState copyWith({
    Uint8List? sweepTxId,
    String? error,
  }) =>
      SweepState(
        sweepTxId: sweepTxId ?? this.sweepTxId,
        error: error ?? this.error,
      );
}
