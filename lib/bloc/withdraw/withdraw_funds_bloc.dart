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
  final BreezSDK _breezLib;

  WithdrawFundsBloc(
    this._breezLib,
  ) : super(WithdrawFundsState.initial());

  /* Reverse Swap */

  Future<ReverseSwapInfo> sendOnchain({
    required int amountSat,
    required String onchainRecipientAddress,
    required String pairHash,
    required int satPerVbyte,
  }) async {
    try {
      _log.v(
        "Reverse Swap of $amountSat sats to address $onchainRecipientAddress using $satPerVbyte sats/vByte as"
        " fee rate w/ pairHash: $pairHash",
      );
      final reverseSwapInfo = await _breezLib.sendOnchain(
        amountSat: amountSat,
        onchainRecipientAddress: onchainRecipientAddress,
        pairHash: pairHash,
        satPerVbyte: satPerVbyte,
      );
      _log.v(
        "Reverse Swap Info for id: ${reverseSwapInfo.id}, ${reverseSwapInfo.onchainAmountSat} sats to address"
        " ${reverseSwapInfo.claimPubkey} w/ status: ${reverseSwapInfo.status}",
      );
      emit(state.copyWith(reverseSwapErrorMessage: ""));
      return reverseSwapInfo;
    } catch (e) {
      _log.e("sendOnchain error", ex: e);
      final reverseSwapErrorMessage = extractExceptionMessage(e, getSystemAppLocalizations());
      emit(state.copyWith(reverseSwapErrorMessage: reverseSwapErrorMessage));
      rethrow;
    }
  }

  Future<ReverseSwapPairInfo> fetchReverseSwapFees({int? amountSat}) async {
    try {
      _log.v("Estimate reverse swap fees for: $amountSat");
      ReverseSwapPairInfo reverseSwapPairInfo =
          await _breezLib.fetchReverseSwapFees(sendAmountSat: amountSat);
      _log.v("Total estimated fees for reverse swap: ${reverseSwapPairInfo.totalEstimatedFees}");
      emit(state.copyWith(reverseSwapErrorMessage: ""));
      return reverseSwapPairInfo;
    } catch (e) {
      _log.e("fetchReverseSwapFees error", ex: e);
      final reverseSwapErrorMessage = extractExceptionMessage(e, getSystemAppLocalizations());
      emit(state.copyWith(reverseSwapErrorMessage: reverseSwapErrorMessage));
      rethrow;
    }
  }

  /* Sweep */

  Future sweep({
    required String toAddress,
    required int feeRateSatsPerVbyte,
  }) async {
    try {
      _log.v("Sweep to address $toAddress using $feeRateSatsPerVbyte fee vByte");
      await _breezLib.sweep(
        toAddress: toAddress,
        feeRateSatsPerVbyte: feeRateSatsPerVbyte,
      );
      emit(state.copyWith(sweepErrorMessage: ""));
    } catch (e) {
      _log.e("sweep error", ex: e);
      final sweepErrorMessage = extractExceptionMessage(e, getSystemAppLocalizations());
      emit(state.copyWith(sweepErrorMessage: sweepErrorMessage));
      rethrow;
    }
  }

  /* Recommended Fees */

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
      final feeErrorMessage = extractExceptionMessage(e, getSystemAppLocalizations());
      emit(state.copyWith(feeErrorMessage: feeErrorMessage));
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
    emit(state.copyWith(feeOptions: feeOptions, feeErrorMessage: ""));
    return feeOptions;
  }

  int _calculateTransactionFee(int inputs, int feeRateSatsPerVbyte) {
    // based on https://bitcoin.stackexchange.com/a/3011
    final transactionSize = (inputs * 148) + (2 * 34) + 10;
    return transactionSize * feeRateSatsPerVbyte;
  }
}
