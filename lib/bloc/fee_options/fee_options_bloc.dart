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

  Future<List<FeeOption>> _constructFeeOptionList(
      {required String toAddress, required RecommendedFees recommendedFees, String? swapAddress}) async {
    final List<FeeOption> feeOptions = [
      FeeOption(
        processingSpeed: ProcessingSpeed.economy,
        waitingTime: const Duration(minutes: 60),
        fee: swapAddress == null
            ? await _calculateSweepTransactionFee(toAddress: toAddress, satPerVbyte: recommendedFees.hourFee)
            : await _calculateRefundTransactionFee(
                satPerVbyte: recommendedFees.hourFee, toAddress: toAddress, swapAddress: swapAddress),
        feeVByte: recommendedFees.hourFee,
      ),
      FeeOption(
        processingSpeed: ProcessingSpeed.regular,
        waitingTime: const Duration(minutes: 30),
        fee: swapAddress == null
            ? await _calculateSweepTransactionFee(
                toAddress: toAddress, satPerVbyte: recommendedFees.halfHourFee)
            : await _calculateRefundTransactionFee(
                satPerVbyte: recommendedFees.halfHourFee, toAddress: toAddress, swapAddress: swapAddress),
        feeVByte: recommendedFees.halfHourFee,
      ),
      FeeOption(
        processingSpeed: ProcessingSpeed.priority,
        waitingTime: const Duration(minutes: 10),
        fee: swapAddress == null
            ? await _calculateSweepTransactionFee(
                toAddress: toAddress, satPerVbyte: recommendedFees.fastestFee)
            : await _calculateRefundTransactionFee(
                satPerVbyte: recommendedFees.fastestFee, toAddress: toAddress, swapAddress: swapAddress),
        feeVByte: recommendedFees.fastestFee,
      ),
    ];
    emit(state.copyWith(feeOptions: feeOptions));
    return feeOptions;
  }

  Future<int> _calculateSweepTransactionFee({required String toAddress, required int satPerVbyte}) async {
    final response = await _breezSDK.prepareSweep(
        req: PrepareSweepRequest(toAddress: toAddress, satPerVbyte: satPerVbyte));
    return response.sweepTxFeeSat;
  }

  Future<int> _calculateRefundTransactionFee(
      {required toAddress, required int satPerVbyte, required String swapAddress}) async {
    final response = await _breezSDK.prepareRefund(
      req: PrepareRefundRequest(
        swapAddress: swapAddress,
        toAddress: toAddress,
        satPerVbyte: satPerVbyte,
      ),
    );
    return response.refundTxFeeSat;
  }
}
