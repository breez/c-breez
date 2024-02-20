import 'dart:async';

import 'package:breez_sdk/breez_sdk.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/fee_options/fee_option.dart';
import 'package:c_breez/bloc/redeem_onchain_funds/redeem_onchain_funds_state.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger("RedeemOnchainFundsBloc");

class RedeemOnchainFundsBloc extends Cubit<RedeemOnchainFundsState> {
  final BreezSDK _breezSDK;
  final waitingTime = [60, 30, 10];

  RedeemOnchainFundsBloc(this._breezSDK) : super(RedeemOnchainFundsState.initial());

  Future<RedeemOnchainFundsResponse> redeemOnchainFunds({
    required String toAddress,
    required int satPerVbyte,
  }) async {
    try {
      _log.info("Redeem onchain funds to address $toAddress using $satPerVbyte fee vByte");
      final req = RedeemOnchainFundsRequest(
        toAddress: toAddress,
        satPerVbyte: satPerVbyte,
      );
      final redeemOnchainRes = await _breezSDK.redeemOnchainFunds(req: req);
      emit(RedeemOnchainFundsState(txId: redeemOnchainRes.txid));
      return redeemOnchainRes;
    } catch (e) {
      _log.severe("redeem onchain funds error", e);
      emit(RedeemOnchainFundsState(error: extractExceptionMessage(e, getSystemAppLocalizations())));
      rethrow;
    }
  }

  /// Fetches the current recommended fees
  Future<List<RedeemOnchainFeeOption>> fetchRedeemOnchainFeeOptions({required String toAddress}) async {
    RecommendedFees recommendedFees;
    try {
      recommendedFees = await _breezSDK.recommendedFees();
      _log.info(
        "fetchFeeOptions recommendedFees:\nfastestFee: ${recommendedFees.fastestFee},"
        "\nhalfHourFee: ${recommendedFees.halfHourFee},\nhourFee: ${recommendedFees.hourFee}.",
      );
      return await _constructFeeOptionList(
        toAddress: toAddress,
        recommendedFees: recommendedFees,
      );
    } catch (e) {
      _log.severe("fetchFeeOptions error", e);
      emit(RedeemOnchainFundsState(error: extractExceptionMessage(e, getSystemAppLocalizations())));
      rethrow;
    }
  }

  Future<List<RedeemOnchainFeeOption>> _constructFeeOptionList({
    required String toAddress,
    required RecommendedFees recommendedFees,
  }) async {
    final recommendedFeeList = [
      recommendedFees.hourFee,
      recommendedFees.halfHourFee,
      recommendedFees.fastestFee,
    ];
    final feeOptions = await Future.wait(
      List.generate(3, (index) async {
        final recommendedFee = recommendedFeeList.elementAt(index);
        final req = PrepareRedeemOnchainFundsRequest(
          toAddress: toAddress,
          satPerVbyte: recommendedFee,
        );
        final txFeeSat = await prepareRedeemOnchainFunds(req);

        return RedeemOnchainFeeOption(
          processingSpeed: ProcessingSpeed.values.elementAt(index),
          waitingTime: Duration(minutes: waitingTime.elementAt(index)),
          txFeeSat: txFeeSat,
          satPerVbyte: recommendedFee,
        );
      }),
    );

    emit(state.copyWith(feeOptions: feeOptions));
    return feeOptions;
  }

  Future<int> prepareRedeemOnchainFunds(PrepareRedeemOnchainFundsRequest req) async {
    _log.info("Prepare redeem onchain funds to ${req.toAddress} with fee ${req.satPerVbyte}");
    try {
      final resp = await _breezSDK.prepareRedeemOnchainFunds(req: req);
      _log.info("Refund txFee: ${resp.txFeeSat}, with tx weight ${resp.txWeight}");
      return resp.txFeeSat;
    } catch (e) {
      _log.severe("Failed to refund swap", e);
      rethrow;
    }
  }
}
