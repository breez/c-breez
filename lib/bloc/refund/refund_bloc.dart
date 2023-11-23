import 'dart:async';

import 'package:breez_sdk/breez_sdk.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/fee_options/fee_option.dart';
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

  // Fetch the refundable swaps list from the sdk.
  void listRefundables() async {
    emit(state.copyWith(refundables: await _breezSDK.listRefundables()));
  }

  /// Broadcast a refund transaction for a failed/expired swap.
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

  /// Fetches the current recommended fees for a refund transaction.
  Future<List<FeeOption>> fetchRefundFeeOptions(
      {required String toAddress, required String swapAddress}) async {
    RecommendedFees recommendedFees;
    try {
      recommendedFees = await _breezSDK.recommendedFees();
      _log.info(
        "fetchFeeOptions recommendedFees:\nfastestFee: ${recommendedFees.fastestFee},"
        "\nhalfHourFee: ${recommendedFees.halfHourFee},\nhourFee: ${recommendedFees.hourFee}.",
      );
      return await _constructFeeOptionList(
        swapAddress: swapAddress,
        toAddress: toAddress,
        recommendedFees: recommendedFees,
      );
    } catch (e) {
      _log.severe("fetchFeeOptions error", e);

      rethrow;
    }
  }

  Future<List<FeeOption>> _constructFeeOptionList({
    required String toAddress,
    required RecommendedFees recommendedFees,
    required String swapAddress,
  }) async {
    List<FeeOption> feeOptions = [];
    Set<int> waitingTimeSet = Set.unmodifiable({60, 30, 10});
    final Set<int> recommendedFeeSet = {
      recommendedFees.hourFee,
      recommendedFees.halfHourFee,
      recommendedFees.fastestFee,
    };
    for (var i = 0; i < 3; i++) {
      final recommendedFee = recommendedFeeSet.elementAt(i);
      final req = PrepareRefundRequest(
        swapAddress: swapAddress,
        toAddress: toAddress,
        satPerVbyte: recommendedFee,
      );
      final fee = await prepareRefund(req);
      feeOptions.add(
        FeeOption(
          processingSpeed: ProcessingSpeed.values.elementAt(i),
          waitingTime: Duration(minutes: waitingTimeSet.elementAt(i)),
          fee: fee,
          feeVByte: recommendedFeeSet.elementAt(i),
        ),
      );
    }
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
