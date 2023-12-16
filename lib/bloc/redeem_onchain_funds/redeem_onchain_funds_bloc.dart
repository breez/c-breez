import 'dart:async';

import 'package:breez_sdk/breez_sdk.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/redeem_onchain_funds/redeem_onchain_funds_state.dart';
import 'package:c_breez/utils/exceptions.dart';
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
}
