import 'dart:async';

import 'package:breez_sdk/breez_sdk.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/refund/refund_state.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger("RefundBloc");

class RefundBloc extends Cubit<RefundState> {
  final BreezSDK _breezSDK;

  RefundBloc(this._breezSDK) : super(RefundState.initial()) {
    _initializeRefundBloc();
  }

  void _initializeRefundBloc() {
    _breezSDK.nodeStateStream.where((nodeState) => nodeState != null).listen(
      (nodeState) async {
        listRefundables();
      },
    );
  }

  // fetch the refundable swaps list from the sdk.
  void listRefundables() async {
    emit(state.copyWith(refundables: await _breezSDK.listRefundables()));
  }

  /// Prepares a refund transaction for a failed/expired swap.
  ///
  /// Can optionally be used before refund to know how much fees will be paid
  /// to perform the refund.
  Future<int> prepareRefund({
    required PrepareRefundRequest req,
  }) async {
    _log.info("Refunding swap ${req.swapAddress} to ${req.toAddress} with fee ${req.satPerVbyte}");
    try {
      final resp = await _breezSDK.prepareRefund(req: req);
      _log.info("Refund txId: ${resp.refundTxWeight}, ${resp.refundTxFeeSat}");
      return resp.refundTxFeeSat;
    } catch (e) {
      _log.severe("Failed to refund swap", e);
      rethrow;
    }
  }

  /// Broadcast a refund transaction for a failed/expired swap
  Future<String> refund({
    required RefundRequest req,
  }) async {
    _log.info("Refunding swap ${req.swapAddress} to ${req.toAddress} with fee ${req.satPerVbyte}");
    try {
      final refundResponse = await _breezSDK.refund(req: req);
      _log.info("Refund txId: ${refundResponse.refundTxId}");
      emit(RefundState(refundTxId: refundResponse.refundTxId));
      return refundResponse.refundTxId;
    } catch (e) {
      _log.severe("Failed to refund swap", e);
      emit(RefundState(error: extractExceptionMessage(e, getSystemAppLocalizations())));
      rethrow;
    }
  }
}
