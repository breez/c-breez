import 'dart:async';

import 'package:breez_sdk/breez_bridge.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/withdraw/withdraw_funds_state.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:fimber/fimber.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

final _log = FimberLog("WithdrawFundsBloc");

class WithdrawFundsBloc extends Cubit<WithdrawFundsState> {
  final BreezBridge _breezLib;

  WithdrawFundsBloc(
    this._breezLib,
  ) : super(WithdrawFundsState.initial());

  Future sweep({
    required String toAddress,
    required int feeRateSatsPerByte,
  }) async {
    await _breezLib.sweep(
      toAddress: toAddress,
      feeRateSatsPerByte: feeRateSatsPerByte,
    );
  }

  Future<List<FeeOption>> fetchFeeOptions() async {
    RecommendedFees recommendedFees;
    try {
      recommendedFees = await _breezLib.recommendedFees();
      _log.v(
        "fetchFeeOptions recommendedFees:\nfastestFee: ${recommendedFees.fastestFee},"
        "\nhalfHourFee: ${recommendedFees.halfHourFee},\nhourFee: ${recommendedFees.hourFee}.",
      );
      final utxos = await _retrieveUTXOS();
      return _constructFeeOptionList(utxos, recommendedFees);
    } catch (e) {
      _log.e("fetchFeeOptions error", ex: e);
      emit(WithdrawFundsState(errorMessage: extractExceptionMessage(e, getSystemAppLocalizations())));
      rethrow;
    }
  }

  Future<int> _retrieveUTXOS() async {
    final nodeState = await _breezLib.getNodeState();
    if (nodeState == null) {
      _log.e("_retrieveUTXOS Failed to get node state");
      throw Exception(getSystemAppLocalizations().node_state_error);
    }
    final utxos = nodeState.utxos.length;
    _log.v("_retrieveUTXOS utxos: $utxos");
    return utxos;
  }

  List<FeeOption> _constructFeeOptionList(int utxos, RecommendedFees recommendedFees) {
    final List<FeeOption> feeOptions = [
      FeeOption(
        processingSpeed: ProcessingSpeed.economy,
        waitingTime: const Duration(minutes: 60),
        fee: _calculateTransactionFee(utxos, recommendedFees.hourFee),
      ),
      FeeOption(
        processingSpeed: ProcessingSpeed.regular,
        waitingTime: const Duration(minutes: 30),
        fee: _calculateTransactionFee(utxos, recommendedFees.halfHourFee),
      ),
      FeeOption(
        processingSpeed: ProcessingSpeed.priority,
        waitingTime: const Duration(minutes: 10),
        fee: _calculateTransactionFee(utxos, recommendedFees.fastestFee),
      ),
    ];
    emit(WithdrawFundsState(feeOptions: feeOptions));
    return feeOptions;
  }

  int _calculateTransactionFee(int inputs, int feeRateSatsPerByte) {
    // based on https://bitcoin.stackexchange.com/a/3011
    final transactionSize = (inputs * 148) + (2 * 34) + 10;
    return transactionSize * feeRateSatsPerByte;
  }
}
