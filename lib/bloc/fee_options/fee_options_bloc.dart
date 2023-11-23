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
  final BreezSDK _breezSDK;

  FeeOptionsBloc(this._breezSDK) : super(FeeOptionsState.initial());

  /// Fetches the current recommended fees
  Future<List<FeeOption>> fetchFeeOptions({required String toAddress, String? swapAddress}) async {
    RecommendedFees recommendedFees;
    try {
      recommendedFees = await _breezSDK.recommendedFees();
      _log.info(
        "fetchFeeOptions recommendedFees:\nfastestFee: ${recommendedFees.fastestFee},"
        "\nhalfHourFee: ${recommendedFees.halfHourFee},\nhourFee: ${recommendedFees.hourFee}.",
      );
      return await _constructFeeOptionList(
        toAddress: toAddress,
        recommendedFees: recommendedFees,
      );
    } catch (e) {
      _log.severe("fetchFeeOptions error", e);
      emit(FeeOptionsState(error: extractExceptionMessage(e, getSystemAppLocalizations())));
      rethrow;
    }
  }

  Future<int> prepareSweep(PrepareSweepRequest req) async {
    _log.info("Sweep to ${req.toAddress} with fee ${req.satPerVbyte}");
    try {
      final resp = await _breezSDK.prepareSweep(req: req);
      _log.info("Refund txId: ${resp.sweepTxFeeSat}, with tx weight ${resp.sweepTxWeight}");
      return resp.sweepTxFeeSat;
    } catch (e) {
      _log.severe("Failed to refund swap", e);
      rethrow;
    }
  }

  Future<List<FeeOption>> _constructFeeOptionList({
    required String toAddress,
    required RecommendedFees recommendedFees,
  }) async {
    List<FeeOption> feeOptions = [];
    Set<int> waitingTimeSet = Set.unmodifiable({60, 30, 10});
    final Set<int> recommendedFeeSet = {
      recommendedFees.hourFee,
      recommendedFees.halfHourFee,
      recommendedFees.fastestFee,
    };
    for (var i = 0; i < 3; i++) {
      final recommendedFee = recommendedFeeSet.elementAt(i);
      final req = PrepareSweepRequest(
        toAddress: toAddress,
        satPerVbyte: recommendedFee,
      );
      final fee = await prepareSweep(req);
      feeOptions.add(
        FeeOption(
          processingSpeed: ProcessingSpeed.values.elementAt(i),
          waitingTime: Duration(minutes: waitingTimeSet.elementAt(i)),
          fee: fee,
          feeVByte: recommendedFeeSet.elementAt(i),
        ),
      );
    }

    emit(state.copyWith(feeOptions: feeOptions));
    return feeOptions;
  }
}
