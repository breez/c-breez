import 'dart:async';

import 'package:breez_sdk/breez_bridge.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/sweep/sweep_state.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:fimber/fimber.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

final _log = FimberLog("SweepBloc");

class SweepBloc extends Cubit<SweepState> {
  final BreezSDK _breezLib;

  SweepBloc(this._breezLib) : super(SweepState.initial());

  Future<SweepResponse> sweep({
    required String toAddress,
    required int feeRateSatsPerVbyte,
  }) async {
    try {
      _log.v("Sweep to address $toAddress using $feeRateSatsPerVbyte fee vByte");
      final request = SweepRequest(toAddress: toAddress, feeRateSatsPerVbyte: feeRateSatsPerVbyte);
      final sweepRes = await _breezLib.sweep(request: request);
      emit(SweepState(sweepTxId: sweepRes.txid));
      return sweepRes;
    } catch (e) {
      _log.e("sweep error", ex: e);
      emit(SweepState(error: extractExceptionMessage(e, getSystemAppLocalizations())));
      rethrow;
    }
  }
}