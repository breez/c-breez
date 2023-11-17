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
        swapAddress: swapAddress,
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
    String? swapAddress,
  }) async {
    final List<FeeOption> feeOptions = [
      FeeOption(
        processingSpeed: ProcessingSpeed.economy,
        waitingTime: const Duration(minutes: 60),
        fee: await _calculateTransactionFee(
            toAddress: toAddress, satPerVbyte: recommendedFees.hourFee, swapAddress: swapAddress),
        feeVByte: recommendedFees.hourFee,
      ),
      FeeOption(
        processingSpeed: ProcessingSpeed.regular,
        waitingTime: const Duration(minutes: 30),
        fee: await _calculateTransactionFee(
            toAddress: toAddress, satPerVbyte: recommendedFees.halfHourFee, swapAddress: swapAddress),
        feeVByte: recommendedFees.halfHourFee,
      ),
      FeeOption(
        processingSpeed: ProcessingSpeed.priority,
        waitingTime: const Duration(minutes: 10),
        fee: await _calculateTransactionFee(
            toAddress: toAddress, satPerVbyte: recommendedFees.fastestFee, swapAddress: swapAddress),
        feeVByte: recommendedFees.fastestFee,
      ),
    ];
    emit(state.copyWith(feeOptions: feeOptions));
    return feeOptions;
  }

  Future<int> _calculateTransactionFee({
    required toAddress,
    required int satPerVbyte,
    String? swapAddress,
  }) async {
    // When the swap address is present we proceed with calculating a prepare refund request.
    if (swapAddress != null) {
      final req = PrepareRefundRequest(
        swapAddress: swapAddress,
        toAddress: toAddress,
        satPerVbyte: satPerVbyte,
      );
      final response = await _breezSDK.prepareRefund(req: req);
      return response.refundTxFeeSat;
    }
    final req = PrepareSweepRequest(
      toAddress: toAddress,
      satPerVbyte: satPerVbyte,
    );
    final response = await _breezSDK.prepareSweep(req: req);
    return response.sweepTxFeeSat;
  }
}
