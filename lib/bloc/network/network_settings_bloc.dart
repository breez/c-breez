import 'package:breez_sdk/breez_bridge.dart';
import 'package:c_breez/bloc/network/network_settings_state.dart';
import 'package:c_breez/config.dart';
import 'package:c_breez/utils/preferences.dart';
import 'package:fimber/fimber.dart';
import 'package:http/http.dart' as http;
import 'package:hydrated_bloc/hydrated_bloc.dart';

class NetworkSettingsBloc extends Cubit<NetworkSettingsState> with HydratedMixin {
  final Preferences _preferences;
  final http.Client _httpClient;
  final BreezBridge _breezLib;
  final _log = FimberLog("NetworkSettingsBloc");

  NetworkSettingsBloc(
    this._preferences,
    this._breezLib, {
    http.Client? httpClient,
  })  : _httpClient = httpClient ?? http.Client(),
        super(NetworkSettingsState.initial()) {
    _fetchMempoolSettings().then((_) => _log.v("Inial mempool settings read"));
  }

  Future<bool> setMempoolUrl(String mempoolUrl) async {
    _log.v("Changing mempool url to: $mempoolUrl");
    Uri? uri;
    try {
      if (mempoolUrl.startsWith(RegExp(r'\d'))) {
        _log.v("Mempool url starts with a digit, adding https://");
        uri = Uri.parse("https://$mempoolUrl");
      } else {
        uri = Uri.parse(mempoolUrl);
      }
    } catch (e) {
      _log.w("Invalid mempool url: $mempoolUrl");
      return false;
    }
    if (!uri.hasScheme) {
      _log.v("Mempool url scheme is missing, adding https://");
      try {
        uri = Uri.parse("https://$mempoolUrl");
      } catch (e) {
        _log.w("Invalid mempool url: $mempoolUrl");
        return false;
      }
    }
    if (!uri.hasScheme || !uri.hasAuthority) {
      _log.w("Invalid mempool url: $mempoolUrl");
      return false;
    }
    if (!await _testUri(uri)) {
      _log.w("Mempool url is not reachable: $mempoolUrl");
      return false;
    }
    final port = uri.hasPort ? ":${uri.port}" : "";
    await _preferences.setMempoolSpaceUrl("${uri.scheme}://${uri.host}$port");
    await _fetchMempoolSettings();
    return true;
  }

  Future<void> resetMempoolSpaceSettings() async {
    _log.v("Resetting mempool url to default");
    await _preferences.resetMempoolSpaceUrl();
    await _fetchMempoolSettings();
  }

  @override
  NetworkSettingsState fromJson(Map<String, dynamic> json) {
    return NetworkSettingsState.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(NetworkSettingsState state) {
    return state.toJson();
  }

  Future<void> _fetchMempoolSettings() async {
    _log.v("Fetching mempool settings");
    final mempoolUrl = await _preferences.getMempoolSpaceUrl();
    final mempoolFallbackUrl = await Config.getMempoolSpaceDefaultUrl(_breezLib);
    _log.v("Mempool url fetched: $mempoolUrl, fallback: $mempoolFallbackUrl");
    emit(state.copyWith(
      mempoolUrl: mempoolUrl ?? mempoolFallbackUrl,
    ));
  }

  Future<bool> _testUri(Uri uri) async {
    try {
      final response = await _httpClient.get(uri);
      return response.statusCode < 400;
    } catch (e) {
      _log.w("Failed to test mempool url: $uri", ex: e);
      return false;
    }
  }
}
