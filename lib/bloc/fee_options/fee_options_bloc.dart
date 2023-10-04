import 'dart:async';

import 'package:breez_sdk/breez_sdk.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/fee_options/fee_option.dart';
import 'package:c_breez/bloc/fee_options/fee_options_state.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:fimber/fimber.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

final _log = FimberLog("FeeOptionsBloc");

class FeeOptionsBloc extends Cubit<FeeOptionsState> {
  final BreezSDK _breezLib;

  FeeOptionsBloc(this._breezLib) : super(FeeOptionsState.initial());

  /// Lookup the most recent reverse swap pair info using the Boltz API
  Future<ReverseSwapPairInfo> fetchReverseSwapFees({int? sendAmountSat}) async {
    try {
      _log.v("Estimate reverse swap fees for: $sendAmountSat");
      final req = ReverseSwapFeesRequest(sendAmountSat: sendAmountSat);
      ReverseSwapPairInfo reverseSwapPairInfo = await _breezLib.fetchReverseSwapFees(req: req);
      _log.v("Total estimated fees for reverse swap: ${reverseSwapPairInfo.totalEstimatedFees}");
      emit(state.copyWith(reverseSwapPairInfo: reverseSwapPairInfo, error: ""));
      return reverseSwapPairInfo;
    } catch (e) {
      _log.e("fetchReverseSwapFees error", ex: e);
      emit(FeeOptionsState(error: extractExceptionMessage(e, getSystemAppLocalizations())));
      rethrow;
    }
  }

  /// Fetches the current recommended fees
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
      emit(FeeOptionsState(error: extractExceptionMessage(e, getSystemAppLocalizations())));
      rethrow;
    }
  }

  Future<int> _retrieveUTXOS() async {
    final nodeState = await _breezLib.nodeInfo();
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
        feeVByte: recommendedFees.hourFee,
      ),
      FeeOption(
        processingSpeed: ProcessingSpeed.regular,
        waitingTime: const Duration(minutes: 30),
        fee: _calculateTransactionFee(utxos, recommendedFees.halfHourFee),
        feeVByte: recommendedFees.halfHourFee,
      ),
      FeeOption(
        processingSpeed: ProcessingSpeed.priority,
        waitingTime: const Duration(minutes: 10),
        fee: _calculateTransactionFee(utxos, recommendedFees.fastestFee),
        feeVByte: recommendedFees.fastestFee,
      ),
    ];
    emit(state.copyWith(feeOptions: feeOptions));
    return feeOptions;
  }

  int _calculateTransactionFee(int inputs, int feeRateSatsPerVbyte) {
    // based on https://bitcoin.stackexchange.com/a/3011
    final transactionSize = (inputs * 148) + (2 * 34) + 10;
    return transactionSize * feeRateSatsPerVbyte;
  }
}
