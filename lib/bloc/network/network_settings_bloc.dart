import 'package:c_breez/bloc/network/network_settings_state.dart';
import 'package:c_breez/utils/preferences.dart';
import 'package:fimber/fimber.dart';
import 'package:http/http.dart' as http;
import 'package:hydrated_bloc/hydrated_bloc.dart';

class NetworkSettingsBloc extends Cubit<NetworkSettingsState>
    with HydratedMixin {
  final Preferences _preferences;
  final _log = FimberLog("NetworkSettingsBloc");

  NetworkSettingsBloc(
    this._preferences,
  ) : super(NetworkSettingsState.initial()) {
    _updateMempoolSettings().then((_) => _log.v("Inial mempool settings read"));
  }

  Future<bool> setMempoolUrl(String mempoolUrl) async {
    _log.v("Changing mempool url to: $mempoolUrl");
    var uri = Uri.parse(mempoolUrl);
    if (!uri.hasScheme) {
      _log.v("Mempool url scheme is missing, adding https://");
      uri = Uri.parse("https://$mempoolUrl");
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
    await _updateMempoolSettings();
    return true;
  }

  Future<void> resetMempoolSpaceSettings() async {
    await _preferences.resetMempoolSpaceUrl();
    await _updateMempoolSettings();
  }

  @override
  NetworkSettingsState fromJson(Map<String, dynamic> json) {
    return NetworkSettingsState.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(NetworkSettingsState state) {
    return state.toJson();
  }

  Future<void> _updateMempoolSettings() async {
    final mempoolUrl = await _preferences.getMempoolSpaceUrl();
    emit(state.copyWith(
      mempoolUrl: mempoolUrl,
    ));
  }

  // ignore: unused_element
  Future<bool> _testUri(Uri uri) async {
    try {
      final response = await http.get(uri);
      return response.statusCode < 400;
    } catch (e) {
      _log.w("Failed to test mempool url: $uri", ex: e);
      return false;
    }
  }
}
