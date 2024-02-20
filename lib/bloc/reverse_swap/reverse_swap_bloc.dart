import 'dart:async';

import 'package:breez_sdk/breez_sdk.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/fee_options/fee_option.dart';
import 'package:c_breez/bloc/reverse_swap/reverse_swap_state.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger("ReverseSwapBloc");

class ReverseSwapBloc extends Cubit<ReverseSwapState> {
  final BreezSDK _breezSDK;
  final waitingTime = [60, 30, 10];

  ReverseSwapBloc(this._breezSDK) : super(ReverseSwapState.initial());

  Future<ReverseSwapInfo> sendOnchain({
    required int amountSat,
    required String onchainRecipientAddress,
    required String pairHash,
    required int satPerVbyte,
  }) async {
    try {
      _log.info(
        "Reverse Swap of $amountSat sats to address $onchainRecipientAddress using $satPerVbyte sats/vByte as"
        " fee rate w/ pairHash: $pairHash",
      );
      final req = SendOnchainRequest(
        amountSat: amountSat,
        onchainRecipientAddress: onchainRecipientAddress,
        pairHash: pairHash,
        satPerVbyte: satPerVbyte,
      );
      final reverseSwapReponse = await _breezSDK.sendOnchain(req: req);
      final reverseSwapInfo = reverseSwapReponse.reverseSwapInfo;
      _log.info(
        "Reverse Swap Info for id: ${reverseSwapInfo.id}, ${reverseSwapInfo.onchainAmountSat} sats to address"
        " ${reverseSwapInfo.claimPubkey} w/ status: ${reverseSwapInfo.status}",
      );
      emit(ReverseSwapState(reverseSwapInfo: reverseSwapInfo));
      return reverseSwapInfo;
    } catch (e) {
      _log.severe("sendOnchain error", e);
      emit(ReverseSwapState(error: extractExceptionMessage(e, getSystemAppLocalizations())));
      rethrow;
    }
  }

  /// Fetches the current recommended fees
  Future<List<ReverseSwapFeeOption>> fetchReverseSwapFeeOptions({required int sendAmountSat}) async {
    RecommendedFees recommendedFees;
    try {
      recommendedFees = await _breezSDK.recommendedFees();
      _log.info(
        "fetchReverseSwapFeeOptions recommendedFees:\nfastestFee: ${recommendedFees.fastestFee},"
        "\nhalfHourFee: ${recommendedFees.halfHourFee},\nhourFee: ${recommendedFees.hourFee}.",
      );
      return await _constructFeeOptionList(
        sendAmountSat: sendAmountSat,
        recommendedFees: recommendedFees,
      );
    } catch (e) {
      _log.severe("fetchFeeOptions error", e);
      emit(ReverseSwapState(error: extractExceptionMessage(e, getSystemAppLocalizations())));
      rethrow;
    }
  }

  Future<List<ReverseSwapFeeOption>> _constructFeeOptionList({
    required int sendAmountSat,
    required RecommendedFees recommendedFees,
  }) async {
    final recommendedFeeList = [
      recommendedFees.hourFee,
      recommendedFees.halfHourFee,
      recommendedFees.fastestFee,
    ];
    final feeOptions = await Future.wait(
      List.generate(3, (index) async {
        final recommendedFee = recommendedFeeList.elementAt(index);
        final fee = await fetchReverseSwapOptions(sendAmountSat: sendAmountSat, claimTxFeerate: recommendedFee);

        return ReverseSwapFeeOption(
          processingSpeed: ProcessingSpeed.values.elementAt(index),
          waitingTime: Duration(minutes: waitingTime.elementAt(index)),
          satPerVbyte: recommendedFee,
          pairInfo: fee.pairInfo,
        );
      }),
    );

    emit(state.copyWith(feeOptions: feeOptions));
    return feeOptions;
  }

  /// Lookup the most recent reverse swap pair info using the Boltz API
  Future<ReverseSwapOptions> fetchReverseSwapOptions({int? sendAmountSat, int? claimTxFeerate}) async {
    try {
      _log.info("Estimate reverse swap fees for: $sendAmountSat");
      final req = ReverseSwapFeesRequest(sendAmountSat: sendAmountSat, claimTxFeerate: claimTxFeerate);
      ReverseSwapPairInfo reverseSwapPairInfo = await _breezSDK.fetchReverseSwapFees(req: req);
      _log.info("Total estimated fees for reverse swap: ${reverseSwapPairInfo.totalEstimatedFees}");
      final maxAmountResponse = await _breezSDK.maxReverseSwapAmount();
      return ReverseSwapOptions(pairInfo: reverseSwapPairInfo, maxAmountSat: maxAmountResponse.totalSat);
    } catch (e) {
      _log.severe("fetchReverseSwapOptions error", e);
      rethrow;
    }
  }
}
