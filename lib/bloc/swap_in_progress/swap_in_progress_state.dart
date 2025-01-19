import 'package:breez_sdk/sdk.dart';

class SwapInProgressState {
  final SwapInfo? inProgress;
  final SwapInfo? unused;
  final bool isLoading;
  final String? error;

  SwapInProgressState({this.inProgress, this.unused, this.isLoading = false, this.error});

  SwapInProgressState.initial() : this();

  SwapInProgressState copyWith({
    SwapInfo? inProgress,
    SwapInfo? unused,
    bool? isLoading,
    String? error,
  }) {
    return SwapInProgressState(
      inProgress: inProgress ?? this.inProgress,
      unused: unused ?? this.unused,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
