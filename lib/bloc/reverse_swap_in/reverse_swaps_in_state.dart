import 'package:breez_sdk/bridge_generated.dart';

class ReverseSwapsInState {
  final List<ReverseSwapInfo> reverseSwapsInProgress;
  final bool isLoading;
  final String? error;

  ReverseSwapsInState({
    this.reverseSwapsInProgress = const [],
    this.isLoading = false,
    this.error,
  });

  ReverseSwapsInState.initial() : this();

  ReverseSwapsInState copyWith({
    List<ReverseSwapInfo>? reverseSwapsInProgress,
    bool? isLoading,
    String? error,
  }) =>
      ReverseSwapsInState(
        reverseSwapsInProgress: reverseSwapsInProgress ?? this.reverseSwapsInProgress,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
      );
}
