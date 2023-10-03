import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/bloc/fee_options/fee_option.dart';

class FeeOptionsState {
  final List<FeeOption> feeOptions;
  final ReverseSwapPairInfo? reverseSwapPairInfo;
  final String? error;

  FeeOptionsState({
    this.feeOptions = const [],
    this.reverseSwapPairInfo,
    this.error = "",
  });

  FeeOptionsState.initial() : this();

  FeeOptionsState copyWith({
    List<FeeOption>? feeOptions,
    ReverseSwapPairInfo? reverseSwapPairInfo,
    String? error,
  }) =>
      FeeOptionsState(
        feeOptions: feeOptions ?? this.feeOptions,
        reverseSwapPairInfo: reverseSwapPairInfo ?? this.reverseSwapPairInfo,
        error: error ?? this.error,
      );
}
