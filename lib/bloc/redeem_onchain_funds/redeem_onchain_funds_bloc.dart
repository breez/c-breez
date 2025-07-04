import 'dart:async';

import 'package:breez_sdk/breez_sdk.dart';
import 'package:breez_sdk/sdk.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/redeem_onchain_funds/redeem_onchain_funds_state.dart';
import 'package:c_breez/models/models.dart';
import 'package:c_breez/utils/utils.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger("RedeemOnchainFundsBloc");

class RedeemOnchainFundsBloc extends Cubit<RedeemOnchainFundsState> {
  final BreezSDK _breezSDK;

  RedeemOnchainFundsBloc(this._breezSDK) : super(RedeemOnchainFundsState.initial());

  Future<RedeemOnchainFundsResponse> redeemOnchainFunds({
    required String toAddress,
    required int satPerVbyte,
  }) async {
    try {
      _log.info("Redeem onchain funds to address $toAddress using $satPerVbyte fee vByte");
      final req = RedeemOnchainFundsRequest(toAddress: toAddress, satPerVbyte: satPerVbyte);
      final redeemOnchainRes = await _breezSDK.redeemOnchainFunds(req: req);
      emit(RedeemOnchainFundsState(txId: redeemOnchainRes.txid));
      return redeemOnchainRes;
    } catch (e) {
      _log.severe("redeem onchain funds error", e);
      emit(RedeemOnchainFundsState(error: ExceptionHandler.extractMessage(e, getSystemAppLocalizations())));
      rethrow;
    }
  }

  /// Fetches the current recommended fees
  Future<List<RedeemOnchainFeeOption>> fetchRedeemOnchainFeeOptions({required String toAddress}) async {
    RecommendedFees recommendedFees;
    try {
      recommendedFees = await _breezSDK.recommendedFees();
      _log.info(
        "fetchRedeemOnchainFeeOptions recommendedFees:\nfastestFee: ${recommendedFees.fastestFee},"
        "\nhalfHourFee: ${recommendedFees.halfHourFee},\nhourFee: ${recommendedFees.hourFee}.",
      );
      return await _constructFeeOptionList(toAddress: toAddress, recommendedFees: recommendedFees);
    } catch (e) {
      _log.severe("fetchRedeemOnchainFeeOptions error", e);
      emit(RedeemOnchainFundsState(error: ExceptionHandler.extractMessage(e, getSystemAppLocalizations())));
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
        final recommendedFee = recommendedFeeList.elementAt(index).toInt();
        final req = PrepareRedeemOnchainFundsRequest(toAddress: toAddress, satPerVbyte: recommendedFee);
        final txFeeSat = await prepareRedeemOnchainFunds(req);

        return RedeemOnchainFeeOption(
          processingSpeed: ProcessingSpeed.values.elementAt(index),
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
      _log.info("Redeem onchain funds txFee: ${resp.txFeeSat}, with tx weight ${resp.txWeight}");
      return resp.txFeeSat.toInt();
    } catch (e) {
      _log.severe("Failed to redeem onchain funds", e);
      rethrow;
    }
  }
}
