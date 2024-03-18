import 'package:breez_sdk/sdk.dart';

class RevSwapsInProgressState {
  final List<ReverseSwapInfo> reverseSwapsInProgress;
  final bool isLoading;
  final String? error;

  RevSwapsInProgressState({
    this.reverseSwapsInProgress = const [],
    this.isLoading = false,
    this.error = "",
  });

  RevSwapsInProgressState.initial() : this();

  RevSwapsInProgressState copyWith({
    List<ReverseSwapInfo>? reverseSwapsInProgress,
    bool? isLoading,
    String? error,
  }) =>
      RevSwapsInProgressState(
        reverseSwapsInProgress: reverseSwapsInProgress ?? this.reverseSwapsInProgress,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
      );
}
