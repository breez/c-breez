import 'dart:async';

import 'package:breez_sdk/breez_bridge.dart';
import 'package:c_breez/bloc/refund/refund_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RefundBloc extends Cubit<RefundState> {
  final BreezBridge _breezLib;

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
  }) async =>
      await _breezLib.refund(
        swapAddress: swapAddress,
        toAddress: toAddress,
        satPerVbyte: satPerVbyte,
      );
}
