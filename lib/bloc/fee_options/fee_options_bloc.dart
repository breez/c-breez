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

  Future<List<FeeOption>> _constructFeeOptionList({
    required String toAddress,
    required RecommendedFees recommendedFees,
  }) async {
    final List<FeeOption> feeOptions = [
      FeeOption(
        processingSpeed: ProcessingSpeed.economy,
        waitingTime: const Duration(minutes: 60),
        fee: await _calculateTransactionFee(
          toAddress: toAddress,
          satPerVbyte: recommendedFees.hourFee,
        ),
        feeVByte: recommendedFees.hourFee,
      ),
      FeeOption(
        processingSpeed: ProcessingSpeed.regular,
        waitingTime: const Duration(minutes: 30),
        fee: await _calculateTransactionFee(
          toAddress: toAddress,
          satPerVbyte: recommendedFees.halfHourFee,
        ),
        feeVByte: recommendedFees.halfHourFee,
      ),
      FeeOption(
        processingSpeed: ProcessingSpeed.priority,
        waitingTime: const Duration(minutes: 10),
        fee: await _calculateTransactionFee(
          toAddress: toAddress,
          satPerVbyte: recommendedFees.fastestFee,
        ),
        feeVByte: recommendedFees.fastestFee,
      ),
    ];
    emit(state.copyWith(feeOptions: feeOptions));
    return feeOptions;
  }

  Future<int> _calculateTransactionFee({
    required toAddress,
    required int satPerVbyte,
  }) async {
    final req = PrepareSweepRequest(
      toAddress: toAddress,
      satPerVbyte: satPerVbyte,
    );
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
}
