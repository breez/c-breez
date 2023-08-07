import 'package:breez_sdk/breez_bridge.dart';
import 'package:breez_sdk/bridge_generated.dart' as sdk;
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/buy_bitcoin/moonpay/moonpay_state.dart';
import 'package:c_breez/config.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:c_breez/utils/preferences.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _log = FimberLog("MoonPayBloc");

class MoonPayBloc extends Cubit<MoonPayState> {
  final BreezSDK _breezLib;
  final Preferences _preferences;

  MoonPayBloc(
    this._breezLib,
    this._preferences,
  ) : super(MoonPayState.initial());

  Future<void> fetchMoonpayUrl() async {
    try {
      _log.v("fetchMoonpayUrl");
      emit(MoonPayState.loading());
      final swapInProgress = (await _breezLib.inProgressSwap());

      if (swapInProgress != null) {
        _log.v("fetchMoonpayUrl swapInfo: $swapInProgress");
        emit(MoonPayState.swapInProgress(
            swapInProgress.bitcoinAddress, swapInProgress.status == sdk.SwapStatus.Expired));
        return;
      }

      sdk.BuyBitcoinRequest reqData = const sdk.BuyBitcoinRequest(provider: sdk.BuyBitcoinProvider.Moonpay);
      final buyBitcoinResponse = await _breezLib.buyBitcoin(reqData: reqData);
      _log.v("fetchMoonpayUrl url: ${buyBitcoinResponse.url}");
      if (buyBitcoinResponse.openingFeeParams != null) {
        emit(MoonPayState.urlReady(buyBitcoinResponse));
        return;
      }

      emit(MoonPayState.error(getSystemAppLocalizations().add_funds_moonpay_error_address));
    } catch (e) {
      _log.e("fetchMoonpayUrl error: $e");
      emit(MoonPayState.error(extractExceptionMessage(e, getSystemAppLocalizations())));
    }
  }

  void updateWebViewStatus(WebViewStatus status) {
    _log.v("updateWebViewStatus status: $status");
    final state = this.state;
    if (state is MoonPayStateUrlReady) {
      emit(state.copyWith(webViewStatus: status));
    } else {
      _log.e("updateWebViewStatus state is not MoonPayStateUrlReady");
    }
  }

  Future<String> makeExplorerUrl(String address) async {
    _log.v("openExplorer address: $address");
    final mempoolUrl = await _preferences.getMempoolSpaceUrl() ?? (await Config.instance()).defaultMempoolUrl;
    final url = "$mempoolUrl/address/$address";
    _log.v("openExplorer url: $url");
    return url;
  }

  void dispose() {
    _log.v("dispose");
    emit(MoonPayState.initial());
  }
}
