import 'dart:async';

import 'package:breez_sdk/breez_sdk.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/swap_in_progress/swap_in_progress_state.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger("SwapInProgressBloc");

class SwapInProgressBloc extends Cubit<SwapInProgressState> {
  final BreezSDK _breezSDK;

  SwapInProgressBloc(this._breezSDK) : super(SwapInProgressState(null, null, isLoading: true)) {
    pollSwapAddress();
  }

  late Timer timer;

  pollSwapAddress() {
    _log.info("swap in address polling started");
    emit(SwapInProgressState(null, null, isLoading: true));
    timer = Timer.periodic(const Duration(seconds: 5), _refreshAddresses);
    _refreshAddresses(timer);
  }

  void _refreshAddresses(Timer timer) async {
    final currentState = state;
    final texts = getSystemAppLocalizations();
    try {
      final swapInProgress = (await _breezSDK.inProgressSwap());
      SwapInfo? swapUnused = currentState.unused;
      if (swapInProgress != null) {
        swapUnused = null;
      } else {
        swapUnused = (await _breezSDK.receiveOnchain(req: const ReceiveOnchainRequest()));
      }
      _log.info("swapInProgress: $swapInProgress, swapUnused: $swapUnused");
      if (!isClosed) {
        emit(SwapInProgressState(swapInProgress, swapUnused));
      }
    } catch (e) {
      final errorMessage = extractExceptionMessage(e, texts);
      timer.cancel();
      if (!isClosed) {
        emit(SwapInProgressState(null, null, error: errorMessage));
      }
      _log.info("swap in address polling finished due to error");
      rethrow;
    }
  }

  @override
  Future<void> close() {
    timer.cancel();
    _log.info("swap in address polling finished");
    return super.close();
  }
}
