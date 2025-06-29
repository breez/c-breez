import 'dart:typed_data';

import 'package:c_breez/models/models.dart';

class RedeemOnchainFundsState {
  final List<RedeemOnchainFeeOption> feeOptions;
  final Uint8List? txId;
  final String? error;

  RedeemOnchainFundsState({this.feeOptions = const [], this.txId, this.error = ""});

  RedeemOnchainFundsState.initial() : this();

  RedeemOnchainFundsState copyWith({
    List<RedeemOnchainFeeOption>? feeOptions,
    Uint8List? txId,
    String? error,
  }) => RedeemOnchainFundsState(
    feeOptions: feeOptions ?? this.feeOptions,
    txId: txId ?? this.txId,
    error: error ?? this.error,
  );
}
