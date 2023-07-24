import 'dart:async';

import 'package:breez_sdk/breez_bridge.dart';
import 'package:c_breez/bloc/refund/refund_state.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _log = FimberLog("RefundBloc");

class RefundBloc extends Cubit<RefundState> {
  final BreezSDK _breezLib;

  RefundBloc(this._breezLib) : super(RefundState.initial()) {
    _initializeRefundBloc();
  }

  void _initializeRefundBloc() {
    _breezLib.nodeStateStream.where((nodeState) => nodeState != null).listen(
      (nodeState) async {
        listRefundables();
      },
    );
  }

  // fetch the refundable swaps list from the sdk.
  void listRefundables() async {
    emit(state.copyWith(refundables: await _breezLib.listRefundables()));
  }

  Future<String> refund({
    required String swapAddress,
    required String toAddress,
    required int satPerVbyte,
  }) async {
    _log.v("Refunding swap $swapAddress to $toAddress with fee $satPerVbyte");
    try {
      final txId = await _breezLib.refund(
        swapAddress: swapAddress,
        toAddress: toAddress,
        satPerVbyte: satPerVbyte,
      );
      _log.v("Refund txId: $txId");
      return txId;
    } catch (e) {
      _log.e("Failed to refund swap", ex: e);
      rethrow;
    }
  }
}
