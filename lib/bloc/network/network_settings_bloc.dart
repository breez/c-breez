import 'package:c_breez/bloc/network/network_settings_state.dart';
import 'package:c_breez/config.dart' as lib;
import 'package:c_breez/utils/preferences.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;
import 'package:hydrated_bloc/hydrated_bloc.dart';

class NetworkSettingsBloc extends Cubit<NetworkSettingsState> with HydratedMixin {
  final Preferences _preferences;
  final http.Client _httpClient;
  final lib.Config _config;
  final _log = Logger("NetworkSettingsBloc");

  NetworkSettingsBloc(
    this._preferences,
    this._config, {
    http.Client? httpClient,
  })  : _httpClient = httpClient ?? http.Client(),
        super(NetworkSettingsState.initial()) {
    _fetchMempoolSettings().then((_) => _log.fine("Initial mempool settings read"));
  }

  Future<bool> setMempoolUrl(String mempoolUrl) async {
    _log.fine("Changing mempool url to: $mempoolUrl");
    Uri? uri;
    try {
      if (mempoolUrl.startsWith(RegExp(r'\d'))) {
        _log.fine("Mempool url starts with a digit, adding https://");
        uri = Uri.parse("https://$mempoolUrl");
      } else {
        uri = Uri.parse(mempoolUrl);
      }
    } catch (e) {
      _log.warning("Invalid mempool url: $mempoolUrl");
      return false;
    }
    if (!uri.hasScheme) {
      _log.fine("Mempool url scheme is missing, adding https://");
      try {
        uri = Uri.parse("https://$mempoolUrl");
      } catch (e) {
        _log.warning("Invalid mempool url: $mempoolUrl");
        return false;
      }
    }
    if (!uri.hasScheme || !uri.hasAuthority) {
      _log.warning("Invalid mempool url: $mempoolUrl");
      return false;
    }
    if (!await _testUri(uri)) {
      _log.warning("Mempool url is not reachable: $mempoolUrl");
      return false;
    }
    final port = uri.hasPort ? ":${uri.port}" : "";
    await _preferences.setMempoolSpaceUrl("${uri.scheme}://${uri.host}$port");
    await _fetchMempoolSettings();
    return true;
  }

  Future<void> resetMempoolSpaceSettings() async {
    _log.fine("Resetting mempool url to default");
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
    _log.fine("Fetching mempool settings");
    final mempoolUrl = await _preferences.getMempoolSpaceUrl();
    final mempoolDefaultUrl = _config.defaultMempoolUrl;
    _log.fine("Mempool url fetched: $mempoolUrl, default: $mempoolDefaultUrl");
    emit(state.copyWith(
      mempoolUrl: mempoolUrl ?? mempoolDefaultUrl,
    ));
  }

  Future<bool> _testUri(Uri uri) async {
    try {
      final response = await _httpClient.get(uri);
      return response.statusCode < 400;
    } catch (e) {
      _log.warning("Failed to test mempool url: $uri", e);
      return false;
    }
  }
}
