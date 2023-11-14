import 'dart:async';

import 'package:breez_sdk/breez_sdk.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/reverse_swap/reverse_swap_state.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger("ReverseSwapBloc");

class ReverseSwapBloc extends Cubit<ReverseSwapState> {
  final BreezSDK _breezLib;

  ReverseSwapBloc(this._breezLib) : super(ReverseSwapState.initial());

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
      final reverseSwapReponse = await _breezLib.sendOnchain(req: req);
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

  /// Lookup the most recent reverse swap pair info using the Boltz API
  Future<ReverseSwapOptions> fetchReverseSwapOptions({int? sendAmountSat}) async {
    try {
      _log.info("Estimate reverse swap fees for: $sendAmountSat");
      final req = ReverseSwapFeesRequest(sendAmountSat: sendAmountSat);
      ReverseSwapPairInfo reverseSwapPairInfo = await _breezLib.fetchReverseSwapFees(req: req);
      _log.info("Total estimated fees for reverse swap: ${reverseSwapPairInfo.totalEstimatedFees}");
      final maxAmountResponse = await _breezLib.maxReverseSwapAmount();
      return ReverseSwapOptions(pairInfo: reverseSwapPairInfo, maxAmountSat: maxAmountResponse.totalSat);
    } catch (e) {
      _log.severe("fetchReverseSwapOptions error", e);
      rethrow;
    }
  }
}
