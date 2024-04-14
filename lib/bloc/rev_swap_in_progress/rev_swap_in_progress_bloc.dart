import 'dart:async';

import 'package:breez_sdk/breez_sdk.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/rev_swap_in_progress/rev_swap_in_progress_state.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger("RevSwapsInProgressBloc");

class RevSwapsInProgressBloc extends Cubit<RevSwapsInProgressState> {
  final BreezSDK _breezSDK;

  RevSwapsInProgressBloc(this._breezSDK) : super(RevSwapsInProgressState.initial()) {
    _log.info("Initializing RevSwapsInProgressBloc");
    pollReverseSwapsInProgress();
  }

  pollReverseSwapsInProgress() async {
    _log.info("Started polling for reverse swaps in progress.");
    await _refreshInProgressReverseSwaps(showLoader: true).whenComplete(() => _startPolling());
  }

  Timer? timer;

  void _startPolling() {
    timer = Timer.periodic(const Duration(seconds: 30), (_) => _refreshInProgressReverseSwaps());
  }

  Future<void> _refreshInProgressReverseSwaps({bool showLoader = false}) async {
    try {
      _log.info("Refreshing reverse swaps in progress.");
      _emitState(state.copyWith(isLoading: showLoader));
      final reverseSwapsInProgress = await _breezSDK.inProgressOnchainPayments();
      _logReverseSwapsInProgress(reverseSwapsInProgress);
      _emitState(state.copyWith(
        reverseSwapsInProgress: reverseSwapsInProgress,
        error: null,
      ));
    } catch (e) {
      final texts = getSystemAppLocalizations();
      final errorMessage = extractExceptionMessage(e, texts);
      _log.info("Failed to fetch reverse swaps in progress. $errorMessage");
      _stopPolling();
      _emitState(state.copyWith(error: errorMessage));
    } finally {
      _emitState(state.copyWith(isLoading: false));
    }
  }

  void _logReverseSwapsInProgress(List<ReverseSwapInfo> reverseSwapsInProgress) {
    for (var revSwapInfo in reverseSwapsInProgress) {
      _log.info(
        "Reverse Swap of id: ${revSwapInfo.id} to ${revSwapInfo.claimPubkey} for ${revSwapInfo.onchainAmountSat} sats. Current status:${revSwapInfo.status.name}",
      );
    }
  }

  void _stopPolling() {
    if (timer != null && timer!.isActive) {
      _log.info("Stop polling for reverse swaps in progress.");
      timer!.cancel();
    }
  }

  void _emitState(RevSwapsInProgressState state) {
    if (!isClosed) {
      emit(state);
    }
  }

  @override
  Future<void> close() {
    _stopPolling();
    _log.info("Finished polling for reverse swaps in progress.");
    return super.close();
  }
}
