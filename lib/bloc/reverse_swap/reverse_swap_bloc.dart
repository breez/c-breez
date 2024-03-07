import 'dart:async';

import 'package:breez_sdk/breez_sdk.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/reverse_swap/reverse_swap_state.dart';
import 'package:c_breez/models/fee_options/fee_option.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger("ReverseSwapBloc");

class ReverseSwapBloc extends Cubit<ReverseSwapState> {
  final BreezSDK _breezSDK;

  ReverseSwapBloc(this._breezSDK) : super(ReverseSwapState.initial());

  Future<ReverseSwapInfo> payOnchain({
    required String recipientAddress,
    required PrepareOnchainPaymentResponse prepareRes,
  }) async {
    try {
      _log.info(
        "Creating a reverse swap of ${prepareRes.senderAmountSat} sats "
        "expected to be received ${prepareRes.recipientAmountSat} on address $recipientAddress"
        "w/ pairHash: ${prepareRes.feesHash}",
      );

      final req = PayOnchainRequest(
        recipientAddress: recipientAddress,
        prepareRes: prepareRes,
      );

      final revSwapResp = await _breezSDK.payOnchain(req: req);
      final revSwapInfo = revSwapResp.reverseSwapInfo;
      _log.info(
        "Reverse Swap Info for id: ${revSwapInfo.id}, ${revSwapInfo.onchainAmountSat} sats to address "
        "${revSwapInfo.claimPubkey} w/ status: ${revSwapInfo.status}",
      );
      emit(ReverseSwapState(reverseSwapInfo: revSwapInfo));
      return revSwapInfo;
    } catch (e) {
      _log.severe("sendOnchain error", e);
      emit(ReverseSwapState(error: extractExceptionMessage(e, getSystemAppLocalizations())));
      rethrow;
    }
  }

  /// Fetches the current recommended fees
  Future<List<ReverseSwapFeeOption>> fetchReverseSwapFeeOptions({
    required int amountSat,
    required SwapAmountType amountType,
  }) async {
    RecommendedFees recommendedFees;
    try {
      recommendedFees = await _breezSDK.recommendedFees();
      _log.info(
        "fetchReverseSwapFeeOptions recommendedFees:\nfastestFee: ${recommendedFees.fastestFee},"
        "\nhalfHourFee: ${recommendedFees.halfHourFee},\nhourFee: ${recommendedFees.hourFee}.",
      );
      return await _constructFeeOptionList(
        amountSat: amountSat,
        amountType: amountType,
        recommendedFees: recommendedFees,
      );
    } catch (e) {
      _log.severe("fetchFeeOptions error", e);
      emit(ReverseSwapState(error: extractExceptionMessage(e, getSystemAppLocalizations())));
      rethrow;
    }
  }

  Future<List<ReverseSwapFeeOption>> _constructFeeOptionList({
    required int amountSat,
    required SwapAmountType amountType,
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
        final swapOption = await prepareOnchainPayment(
          amountSat: amountSat,
          amountType: amountType,
          claimTxFeerate: recommendedFee,
        );

        return ReverseSwapFeeOption(
          txFeeSat: swapOption.feesClaim,
          processingSpeed: ProcessingSpeed.values.elementAt(index),
          satPerVbyte: recommendedFee,
          pairInfo: swapOption,
        );
      }),
    );

    emit(state.copyWith(feeOptions: feeOptions));
    return feeOptions;
  }

  /// Lookup the most recent reverse swap pair info using the Boltz API
  Future<PrepareOnchainPaymentResponse> prepareOnchainPayment({
    required int amountSat,
    required SwapAmountType amountType,
    required int claimTxFeerate,
  }) async {
    try {
      _log.info(
        "Estimate reverse swap fees for $amountSat sats to be ${amountType == SwapAmountType.Receive ? "received on the" : "sent to the"} destination address",
      );
      final req = PrepareOnchainPaymentRequest(
        amountSat: amountSat,
        amountType: amountType,
        claimTxFeerate: claimTxFeerate,
      );
      PrepareOnchainPaymentResponse revSwapPairInfo = await _breezSDK.prepareOnchainPayment(req: req);
      _log.info("Total estimated fees for reverse swap: ${revSwapPairInfo.totalFees}");
      return revSwapPairInfo;
    } catch (e) {
      _log.severe("prepareOnchainPayment error", e);
      rethrow;
    }
  }

  Future<ReverseSwapPolicy> onchainPaymentLimits() async {
    try {
      OnchainPaymentLimitsResponse paymentLimits = await _breezSDK.onchainPaymentLimits();
      _log.info(
        "Current maximum ${paymentLimits.maxSat} and "
        "minimum ${paymentLimits.minSat} payment limits for onchain payments",
      );
      final maxAmountResponse = await _breezSDK.maxReverseSwapAmount();
      return ReverseSwapPolicy(paymentLimits: paymentLimits, maxAmountSat: maxAmountResponse.totalSat);
    } catch (e) {
      _log.severe("fetchOnchainPaymentLimits error", e);
      rethrow;
    }
  }
}
