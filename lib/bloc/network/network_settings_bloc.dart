import 'dart:convert';

import 'package:c_breez/bloc/network/network_settings_state.dart';
import 'package:c_breez/config.dart' as lib;
import 'package:c_breez/config.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/utils/blockchain_explorer_utils.dart';
import 'package:c_breez/utils/preferences.dart';
import 'package:http/http.dart' as http;
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';

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
    hydrate();
    _fetchMempoolSettings().then((_) => _log.info("Initial mempool settings read"));
  }

  Future<bool> setMempoolUrl(String mempoolUrl) async {
    _log.info("Changing mempool url to: $mempoolUrl");
    Uri? uri;
    try {
      if (mempoolUrl.startsWith(RegExp(r'\d'))) {
        _log.info("Mempool url starts with a digit, adding https://");
        uri = Uri.parse("https://$mempoolUrl");
      } else {
        uri = Uri.parse(mempoolUrl);
      }
    } catch (e) {
      _log.warning("Invalid mempool url: $mempoolUrl");
      return false;
    }
    if (!uri.hasScheme) {
      _log.info("Mempool url scheme is missing, adding https://");
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
    if (!await _testUriSupportsMempoolApi(uri)) {
      _log.warning("Mempool url is not reachable: $mempoolUrl");
      return false;
    }
    final port = uri.hasPort ? ":${uri.port}" : "";
    await _preferences.setMempoolSpaceUrl("${uri.scheme}://${uri.host}$port");
    await _fetchMempoolSettings();
    return true;
  }

  Future<void> resetMempoolSpaceSettings() async {
    _log.info("Resetting mempool url to default");
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
    _log.info("Fetching mempool settings");
    final mempoolUrl = await _preferences.getMempoolSpaceUrl();
    final mempoolDefaultUrl = _config.defaultMempoolUrl;
    _log.info("Mempool url fetched: $mempoolUrl, default: $mempoolDefaultUrl");
    emit(state.copyWith(
      mempoolUrl: mempoolUrl ?? mempoolDefaultUrl,
    ));
  }

  Future<String> get mempoolInstance async {
    String? mempoolInstance = await ServiceInjector().preferences.getMempoolSpaceUrl();
    if (mempoolInstance == null) {
      final config = await Config.instance();
      mempoolInstance = config.defaultMempoolUrl;
    }
    return mempoolInstance;
  }

  Future<bool> _testUriSupportsMempoolApi(Uri uri) async {
    // We need to make sure that the mempool rest api is supported
    // as the sdk depends on it.
    final mempoolUri =
        Uri.tryParse(BlockChainExplorerUtils().formatRecommendedFeesUrl(mempoolInstance: uri.toString()));
    if (mempoolUri == null) return false;
    try {
      final response = await _httpClient.get(mempoolUri);
      if (response.statusCode != 200) {
        return false;
      }
      final Map<String, dynamic> body = jsonDecode(response.body);
      return body.containsKey("fastestFee");
    } catch (e) {
      _log.warning("Failed to test mempool url: $uri", e);
      return false;
    }
  }
}
