import 'dart:async';

import 'package:breez_sdk/breez_bridge.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/reverse_swap_in/reverse_swaps_in_state.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReverseSwapsInBloc extends Cubit<ReverseSwapsInState> {
  final _log = FimberLog("ReverseSwapsInBloc");
  final BreezSDK _breezLib;
  late Timer timer;

  ReverseSwapsInBloc(this._breezLib) : super(ReverseSwapsInState(isLoading: true)) {
    pollReverseSwapsInProgress();
  }

  pollReverseSwapsInProgress() {
    _log.i("reverse swaps in progress polling started");
    emit(ReverseSwapsInState(isLoading: true));
    timer = Timer.periodic(const Duration(seconds: 5), _refreshInProgressReverseSwaps);
    _refreshInProgressReverseSwaps(timer);
  }

  void _refreshInProgressReverseSwaps(Timer timer) async {
    final texts = getSystemAppLocalizations();
    try {
      final reverseSwapsInProgress = await _breezLib.inProgressReverseSwaps();
      emit(state.copyWith(reverseSwapsInProgress: reverseSwapsInProgress, isLoading: false, error: ""));
    } catch (e) {
      final errorMessage = extractExceptionMessage(e, texts);
      emit(state.copyWith(isLoading: false, error: errorMessage));
      timer.cancel();
      _log.i("reverse swaps in progress polling finished due to error");
    }
  }

  @override
  Future<void> close() {
    timer.cancel();
    _log.i("reverse swaps in progress polling finished");
    return super.close();
  }
}
