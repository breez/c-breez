import 'package:c_breez/bloc/fee_options/fee_option.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';

class RedeemOnchainFundsState {
  final List<FeeOption> feeOptions;
  final Uint8List? txId;
  final String? error;

  RedeemOnchainFundsState({this.feeOptions = const [], this.txId, this.error = ""});

  RedeemOnchainFundsState.initial() : this();

  RedeemOnchainFundsState copyWith({
    List<FeeOption>? feeOptions,
    Uint8List? txId,
    String? error,
  }) =>
      RedeemOnchainFundsState(
        feeOptions: feeOptions ?? this.feeOptions,
        txId: txId ?? this.txId,
        error: error ?? this.error,
      );
}
