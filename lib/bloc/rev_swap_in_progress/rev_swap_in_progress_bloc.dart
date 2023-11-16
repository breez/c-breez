import 'dart:async';

import 'package:breez_sdk/breez_sdk.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/rev_swap_in_progress/rev_swap_in_progress_state.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger("RevSwapsInProgressBloc");

class RevSwapsInProgressBloc extends Cubit<RevSwapsInProgressState> {
  final BreezSDK _breezSDK;

  RevSwapsInProgressBloc(this._breezSDK) : super(RevSwapsInProgressState(isLoading: true)) {
    pollReverseSwapsInProgress();
  }

  late Timer timer;

  pollReverseSwapsInProgress() {
    _log.info("reverse swaps in progress polling started");
    emit(RevSwapsInProgressState(isLoading: true));
    timer = Timer.periodic(const Duration(seconds: 5), _refreshInProgressReverseSwaps);
    _refreshInProgressReverseSwaps(timer);
  }

  void _refreshInProgressReverseSwaps(Timer timer) async {
    final texts = getSystemAppLocalizations();
    try {
      final reverseSwapsInProgress = await _breezSDK.inProgressReverseSwaps();
      for (var revSwapInfo in reverseSwapsInProgress) {
        _log.info(
          "Reverse Swap ${revSwapInfo.id} to ${revSwapInfo.claimPubkey} for ${revSwapInfo.onchainAmountSat} sats status:${revSwapInfo.status.name}",
        );
      }
      if (!isClosed) {
        emit(RevSwapsInProgressState(reverseSwapsInProgress: reverseSwapsInProgress));
      }
    } catch (e) {
      final errorMessage = extractExceptionMessage(e, texts);
      if (!isClosed) {
        emit(RevSwapsInProgressState(error: errorMessage));
      }

      timer.cancel();
      _log.info("reverse swaps in progress polling finished due to error");
    }
  }

  @override
  Future<void> close() {
    timer.cancel();
    _log.info("reverse swaps in progress polling finished");
    return super.close();
  }
}
