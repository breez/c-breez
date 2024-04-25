import 'package:breez_sdk/sdk.dart';
import 'package:c_breez/models/fee_options/fee_option.dart';

class ReverseSwapState {
  final List<ReverseSwapFeeOption> feeOptions;
  final ReverseSwapInfo? reverseSwapInfo;
  final String? error;

  ReverseSwapState({this.feeOptions = const [], this.reverseSwapInfo, this.error = ""});

  ReverseSwapState.initial() : this();

  ReverseSwapState copyWith({
    List<ReverseSwapFeeOption>? feeOptions,
    ReverseSwapInfo? reverseSwapInfo,
    String? error,
  }) =>
      ReverseSwapState(
        feeOptions: feeOptions ?? this.feeOptions,
        reverseSwapInfo: reverseSwapInfo ?? this.reverseSwapInfo,
        error: error ?? this.error,
      );
}
