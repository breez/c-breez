import 'dart:async';

import 'package:breez_sdk/breez_sdk.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/refund/refund_state.dart';
import 'package:c_breez/models/fee_options/fee_option.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger("RefundBloc");

class RefundBloc extends Cubit<RefundState> {
  final BreezSDK _breezSDK;

  RefundBloc(this._breezSDK) : super(RefundState.initial()) {
    _initializeRefundBloc();
    _listenSwapEvents();
  }

  void _initializeRefundBloc() {
    late final StreamSubscription streamSubscription;
    streamSubscription = _breezSDK.nodeStateStream.where((nodeState) => nodeState != null).listen(
      (nodeState) async {
        listRefundables();
        streamSubscription.cancel();
      },
    );
  }

  // Fetch the refundable swaps list from the sdk.
  void listRefundables() async {
    try {
      _log.info('Refreshing refundables');
      var refundables = await _breezSDK.listRefundables();
      _log.info('Refundables: $refundables');
      emit(state.copyWith(refundables: refundables));
    } catch (e) {
      _log.severe('Failed to list refundables: $e');
      emit(state.copyWith(refundables: null, error: extractExceptionMessage(e, getSystemAppLocalizations())));
      rethrow;
    }
  }

  _listenSwapEvents() {
    _breezSDK.swapEventsStream.listen((event) {
      if (event is BreezEvent_SwapUpdated) {
        _log.info('Got SwapUpdate event: $event');
        var swapInfo = event.details;
        if (swapInfo.status == SwapStatus.Refundable || swapInfo.status == SwapStatus.Completed) {
          listRefundables();
        }
      }
    }, onError: (e) {
      _log.severe('Failed to listen swapEventsStream: $e');
      emit(state.copyWith(error: extractExceptionMessage(e, getSystemAppLocalizations())));
    });
  }

  /// Broadcast a refund transaction for a failed/expired swap.
  Future<String> refund({
    required RefundRequest req,
  }) async {
    _log.info("Refunding swap ${req.swapAddress} to ${req.toAddress} with fee ${req.satPerVbyte}");
    try {
      final refundResponse = await _breezSDK.refund(req: req);
      _log.info("Refund txId: ${refundResponse.refundTxId}");
      emit(state.copyWith(refundTxId: refundResponse.refundTxId));
      return refundResponse.refundTxId;
    } catch (e) {
      _log.severe("Failed to refund swap", e);
      emit(state.copyWith(error: extractExceptionMessage(e, getSystemAppLocalizations())));
      rethrow;
    }
  }

  /// Fetches the current recommended fees for a refund transaction.
  Future<List<RefundFeeOption>> fetchRefundFeeOptions({
    required String toAddress,
    required String swapAddress,
  }) async {
    RecommendedFees recommendedFees;
    try {
      recommendedFees = await _breezSDK.recommendedFees();
      _log.info(
        "fetchRefundFeeOptions recommendedFees:\nfastestFee: ${recommendedFees.fastestFee},"
        "\nhalfHourFee: ${recommendedFees.halfHourFee},\nhourFee: ${recommendedFees.hourFee}.",
      );
      return await _constructFeeOptionList(
        swapAddress: swapAddress,
        toAddress: toAddress,
        recommendedFees: recommendedFees,
      );
    } catch (e) {
      _log.severe("fetchRefundFeeOptions error", e);
      emit(state.copyWith(error: extractExceptionMessage(e, getSystemAppLocalizations())));
      rethrow;
    }
  }

  Future<List<RefundFeeOption>> _constructFeeOptionList({
    required String toAddress,
    required RecommendedFees recommendedFees,
    required String swapAddress,
  }) async {
    final recommendedFeeList = [
      recommendedFees.hourFee,
      recommendedFees.halfHourFee,
      recommendedFees.fastestFee,
    ];
    final feeOptions = await Future.wait(
      List.generate(3, (index) async {
        final recommendedFee = recommendedFeeList.elementAt(index);
        final req = PrepareRefundRequest(
          swapAddress: swapAddress,
          toAddress: toAddress,
          satPerVbyte: recommendedFee,
        );
        final fee = await prepareRefund(req);

        return RefundFeeOption(
          processingSpeed: ProcessingSpeed.values.elementAt(index),
          txFeeSat: fee,
          satPerVbyte: recommendedFee,
        );
      }),
    );

    return feeOptions;
  }

  Future<int> prepareRefund(PrepareRefundRequest req) async {
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
}
