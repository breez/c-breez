import 'dart:convert';

import 'package:c_breez/bloc/network/network_settings_bloc.dart';
import 'package:c_breez/bloc/network/network_settings_state.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/utils/blockchain_explorer_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../../mock/http_client_mock.dart';
import '../../mock/injector_mock.dart';
import '../../mock/lib_config_mock.dart';
import '../../unit_logger.dart';
import '../../utils/fake_path_provider_platform.dart';
import '../../utils/hydrated_bloc_storage.dart';

String get _recomendedMockFeesResponse {
  final Map<String, dynamic> recomendedFees = {
    "fastestFee": 1,
    "halfHourFee": 1,
    "hourFee": 1,
    "economyFee": 1,
    "minimumFee": 1,
  };
  return jsonEncode(recomendedFees);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final platform = FakePathProviderPlatform();
  final hydratedBlocStorage = HydratedBlocStorage();
  late InjectorMock injector;
  late HttpClientMock httpClient;
  late LibConfigMock libConfig;
  setUpLogger();

  group('mempool space', () {
    setUp(() async {
      injector = InjectorMock();
      ServiceInjector.configure(injector);
      await platform.setUp();
      PathProviderPlatform.instance = platform;
      await hydratedBlocStorage.setUpHydratedBloc();
      httpClient = HttpClientMock();
      libConfig = LibConfigMock();
    });

    tearDown(() async {
      await platform.tearDown();
      await hydratedBlocStorage.tearDownHydratedBloc();
    });

    NetworkSettingsBloc make() =>
        NetworkSettingsBloc(injector.preferences, libConfig, httpClient: httpClient);

    test('initial setup should emit url from preferences', () async {
      const url = "a mempool url";
      injector.preferencesMock.mempoolSpaceUrl = url;
      final bloc = make();
      expectLater(bloc.stream, emitsInOrder([NetworkSettingsState(mempoolUrl: url)]));
    });

    test('initial setup should emit fallback url if no url in preferences', () async {
      const url = "https://mempool.space";
      injector.preferencesMock.mempoolSpaceUrl = null;
      final bloc = make();
      expectLater(bloc.stream, emitsInOrder([NetworkSettingsState(mempoolUrl: url)]));
    });

    test('reset mempool space settings should clean preferences', () async {
      final bloc = make();
      bloc.resetMempoolSpaceSettings();
      expect(injector.preferencesMock.resetMempoolSpaceUrlCalled, 1);
    });

    test('set mempool space url with a valid url should set on the preferences', () async {
      const url = "https://mempool.space";

      httpClient.getAnswer[url] = http.Response("{}", 200);
      final bloc = make();

      httpClient.getAnswer[BlockChainExplorerUtils().formatRecommendedFeesUrl(mempoolInstance: url)] =
          http.Response(_recomendedMockFeesResponse, 200);
      final result = await bloc.setMempoolUrl(url);
      expect(result, true);
      expect(injector.preferencesMock.setMempoolSpaceUrlUrl, url);
    });

    test('set mempool space url with a valid url missing scheme should set on the preferences', () async {
      const url = "mempool.space";

      final bloc = make();
      httpClient
              .getAnswer["https://${BlockChainExplorerUtils().formatRecommendedFeesUrl(mempoolInstance: url)}"] =
          http.Response(_recomendedMockFeesResponse, 200);
      final result = await bloc.setMempoolUrl(url);
      expect(result, true);
      expect(injector.preferencesMock.setMempoolSpaceUrlUrl, "https://$url");
    });

    test('set mempool space url with an invalid url should not set on the preferences', () async {
      const url = "invalid url";
      final bloc = make();
      final result = await bloc.setMempoolUrl(url);
      expect(result, false);
      expect(injector.preferencesMock.setMempoolSpaceUrlUrl, null);
    });

    test('set mempool space url with an ip should should set on the preferences', () async {
      const url = "https://192.168.15.2";
      final bloc = make();
      httpClient.getAnswer[BlockChainExplorerUtils().formatRecommendedFeesUrl(mempoolInstance: url)] =
          http.Response(_recomendedMockFeesResponse, 200);
      final result = await bloc.setMempoolUrl(url);
      expect(result, true);
      expect(injector.preferencesMock.setMempoolSpaceUrlUrl, url);
    });

    test('set mempool space url with an ip and port should should set on the preferences', () async {
      const url = "https://192.168.15.2:3006";
      final bloc = make();
      httpClient.getAnswer[BlockChainExplorerUtils().formatRecommendedFeesUrl(mempoolInstance: url)] =
          http.Response(_recomendedMockFeesResponse, 200);
      final result = await bloc.setMempoolUrl(url);
      expect(result, true);
      expect(injector.preferencesMock.setMempoolSpaceUrlUrl, url);
    });

    test('set mempool space url with an ip missing scheme should should set on the preferences', () async {
      const url = "192.168.15.2";
      final bloc = make();
      httpClient
              .getAnswer["https://${BlockChainExplorerUtils().formatRecommendedFeesUrl(mempoolInstance: url)}"] =
          http.Response(_recomendedMockFeesResponse, 200);
      final result = await bloc.setMempoolUrl(url);
      expect(result, true);
      expect(injector.preferencesMock.setMempoolSpaceUrlUrl, "https://$url");
    });
  });
}
