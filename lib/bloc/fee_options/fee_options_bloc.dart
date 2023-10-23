import 'dart:async';

import 'package:breez_sdk/breez_sdk.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/fee_options/fee_option.dart';
import 'package:c_breez/bloc/fee_options/fee_options_state.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger("FeeOptionsBloc");

class FeeOptionsBloc extends Cubit<FeeOptionsState> {
  final BreezSDK _breezLib;

  FeeOptionsBloc(this._breezLib) : super(FeeOptionsState.initial());

  /// Lookup the most recent reverse swap pair info using the Boltz API
  Future<ReverseSwapPairInfo> fetchReverseSwapFees({int? sendAmountSat}) async {
    try {
      _log.info("Estimate reverse swap fees for: $sendAmountSat");
      final req = ReverseSwapFeesRequest(sendAmountSat: sendAmountSat);
      ReverseSwapPairInfo reverseSwapPairInfo = await _breezLib.fetchReverseSwapFees(req: req);
      _log.info("Total estimated fees for reverse swap: ${reverseSwapPairInfo.totalEstimatedFees}");
      emit(state.copyWith(reverseSwapPairInfo: reverseSwapPairInfo, error: ""));
      return reverseSwapPairInfo;
    } catch (e) {
      _log.severe("fetchReverseSwapFees error", e);
      emit(FeeOptionsState(error: extractExceptionMessage(e, getSystemAppLocalizations())));
      rethrow;
    }
  }

  /// Fetches the current recommended fees
  Future<List<FeeOption>> fetchFeeOptions(String address) async {
    RecommendedFees recommendedFees;
    try {
      recommendedFees = await _breezLib.recommendedFees();
      _log.info(
        "fetchFeeOptions recommendedFees:\nfastestFee: ${recommendedFees.fastestFee},"
        "\nhalfHourFee: ${recommendedFees.halfHourFee},\nhourFee: ${recommendedFees.hourFee}.",
      );
      return await _constructFeeOptionList(address, recommendedFees);
    } catch (e) {
      _log.severe("fetchFeeOptions error", e);
      emit(FeeOptionsState(error: extractExceptionMessage(e, getSystemAppLocalizations())));
      rethrow;
    }
  }

  Future<int> _retrieveUTXOS() async {
    final nodeState = await _breezLib.nodeInfo();
    if (nodeState == null) {
      _log.severe("_retrieveUTXOS Failed to get node state");
      throw Exception(getSystemAppLocalizations().node_state_error);
    }
    final utxos = nodeState.utxos.length;
    _log.info("_retrieveUTXOS utxos: $utxos");
    return utxos;
  }

  Future<List<FeeOption>> _constructFeeOptionList(
    String address,
    RecommendedFees recommendedFees,
  ) async {
    final List<FeeOption> feeOptions = [
      FeeOption(
        processingSpeed: ProcessingSpeed.economy,
        waitingTime: const Duration(minutes: 60),
        fee: await _calculateTransactionFee(address, recommendedFees.hourFee),
        feeVByte: recommendedFees.hourFee,
      ),
      FeeOption(
        processingSpeed: ProcessingSpeed.regular,
        waitingTime: const Duration(minutes: 30),
        fee: await _calculateTransactionFee(address, recommendedFees.halfHourFee),
        feeVByte: recommendedFees.halfHourFee,
      ),
      FeeOption(
        processingSpeed: ProcessingSpeed.priority,
        waitingTime: const Duration(minutes: 10),
        fee: await _calculateTransactionFee(address, recommendedFees.fastestFee),
        feeVByte: recommendedFees.fastestFee,
      ),
    ];
    emit(state.copyWith(feeOptions: feeOptions));
    return feeOptions;
  }

  Future<int> _calculateTransactionFee(String address, int satsPerVbyte) async {
    final response = await _breezLib.prepareSweep(
      address: address,
      satsPerVbyte: satsPerVbyte,
    );
    return response.sweepTxFeeSat;
  }
}
