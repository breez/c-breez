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

  SwapInProgressBloc(this._breezSDK) : super(SwapInProgressState.initial()) {
    _log.info("Initializing SwapInProgressBloc");
    pollSwapInAddress();
  }

  pollSwapInAddress() async {
    _log.info("Started polling for swap in address.");
    await _refreshAddresses().whenComplete(() => _startPolling());
  }

  late Timer timer;

  void _startPolling() {
    timer = Timer.periodic(const Duration(seconds: 30), (_) async => _refreshAddresses);
  }

  Future<void> _refreshAddresses() async {
    try {
      _log.info("Refreshing swap in address.");
      _emitState(state.copyWith(isLoading: true));
      SwapInfo? inProgress = (await _breezSDK.inProgressSwap());
      // Reset unused if there's a swap in progress
      _emitState(state.copyWith(inProgress: inProgress, unused: inProgress != null ? null : state.unused));
      if (state.inProgress == null && state.unused == null) {
        _emitState(
          state.copyWith(
            unused: await _breezSDK.receiveOnchain(req: const ReceiveOnchainRequest()),
            error: null,
          ),
        );
      }
    } catch (e) {
      final texts = getSystemAppLocalizations();
      final errorMessage = extractExceptionMessage(e, texts);
      _log.info("Failed to refresh addresses. $errorMessage");
      _stopPolling();
      _emitState(state.copyWith(error: errorMessage));
    } finally {
      _emitState(state.copyWith(isLoading: false));
    }
  }

  void _stopPolling() {
    if (timer.isActive) {
      _log.info("Stop polling for swaps in address.");
      timer.cancel();
    }
  }

  void _emitState(SwapInProgressState state) {
    if (!isClosed) {
      emit(state);
    }
  }

  @override
  Future<void> close() {
    _stopPolling();
    _log.info("Finished polling for swap in address.");
    return super.close();
  }
}
