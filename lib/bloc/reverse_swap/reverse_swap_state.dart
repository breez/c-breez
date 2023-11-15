import 'package:breez_sdk/bridge_generated.dart';

class ReverseSwapState {
  final ReverseSwapInfo? reverseSwapInfo;
  final String? error;

  ReverseSwapState({this.reverseSwapInfo, this.error = ""});

  ReverseSwapState.initial() : this();

  ReverseSwapState copyWith({
    ReverseSwapInfo? reverseSwapInfo,
    String? error,
  }) =>
      ReverseSwapState(
        reverseSwapInfo: reverseSwapInfo ?? this.reverseSwapInfo,
        error: error ?? this.error,
      );
}

class ReverseSwapOptions {
  final ReverseSwapPairInfo pairInfo;
  final int maxAmountSat;

  ReverseSwapOptions({required this.pairInfo, required this.maxAmountSat});
}
