import 'dart:async';

import 'package:breez_sdk/breez_bridge.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/reverse_swap/reverse_swap_state.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:fimber/fimber.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

final _log = FimberLog("ReverseSwapBloc");

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
      emit(ReverseSwapState(reverseSwapInfo: reverseSwapInfo));
      return reverseSwapInfo;
    } catch (e) {
      _log.e("sendOnchain error", ex: e);
      emit(ReverseSwapState(error: extractExceptionMessage(e, getSystemAppLocalizations())));
      rethrow;
    }
  }
}
