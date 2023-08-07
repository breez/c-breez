import 'dart:async';

import 'package:breez_sdk/breez_bridge.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/swap_in/swap_in_state.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SwapInBloc extends Cubit<SwapInState> {
  final _log = FimberLog("SwapInBloc");
  final BreezSDK _breezLib;
  late Timer timer;

  SwapInBloc(this._breezLib) : super(SwapInState(null, null, isLoading: true)) {
    pollSwapAddress();
  }

  pollSwapAddress() {
    _log.i("swap in address polling started");
    emit(SwapInState(null, null, isLoading: true));
    timer = Timer.periodic(const Duration(seconds: 5), refreshAddresses);
    refreshAddresses(timer);
  }

  @override
  Future<void> close() {
    timer.cancel();
    _log.i("swap in address polling finished");
    return super.close();
  }

  void refreshAddresses(Timer timer) async {
    final currentState = state;
    final texts = getSystemAppLocalizations();
    try {
      final swapInProgress = (await _breezLib.inProgressSwap());
      SwapInfo? swapUnused = currentState.unused;
      if (swapInProgress != null) {
        swapUnused = null;
      } else {
        swapUnused = (await _breezLib.receiveOnchain(reqData: const ReceiveOnchainRequest()));
      }
      emit(SwapInState(swapInProgress, swapUnused));
    } catch (e) {
      final errorMessage = extractExceptionMessage(e, texts);
      emit(SwapInState(null, null, error: errorMessage));
      timer.cancel();
      _log.i("swap in address polling finished due to error");
    }
  }
}
