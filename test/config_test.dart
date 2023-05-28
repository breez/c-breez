import 'package:breez_sdk/bridge_generated.dart' as sdk;
import 'package:c_breez/app_config.dart';
import 'package:c_breez/config.dart';
import 'package:c_breez/services/injector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'mock/injector_mock.dart';
import 'unit_logger.dart';
import 'utils/fake_path_provider_platform.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final platform = FakePathProviderPlatform();
  late InjectorMock injector;
  late AppConfig breezConfig;
  setUpLogger();

  group('singleton', () {
    setUp(() async {
      injector = InjectorMock();
      ServiceInjector.configure(injector);
      await platform.setUp();
      PathProviderPlatform.instance = platform;
    });

    tearDown(() async {
      await platform.tearDown();
    });

    test('instance should create a new instance', () async {
      final config = await Config.instance();
      expect(config, isNotNull);
    });

    test('instance should return the same instance', () async {
      final config1 = await Config.instance();
      final config2 = await Config.instance();
      expect(config1, config2);
    });

    test('service injector should be optional', () async {
      final config = await Config.instance(serviceInjector: injector);
      expect(config, isNotNull);
    });
  });

  group('config properties', () {
    setUp(() async {
      injector = InjectorMock();
      breezConfig = AppConfig();
      ServiceInjector.configure(injector);
      await platform.setUp();
      PathProviderPlatform.instance = platform;
    });

    tearDown(() async {
      await platform.tearDown();
    });

    test('max fee percent override on preferences should use the configured value', () async {
      final defaultConf = _defaultConf();
      const maxFee = 3.4;
      injector.preferencesMock.paymentOptionsOverrideFeeEnabled = true;
      injector.preferencesMock.paymentOptionsProportionalFee = maxFee;
      final config = await Config.getSDKConfig(injector, defaultConf, breezConfig);
      expect(config.maxfeePercent, maxFee);
    });

    test('mempool space url set in preferences should return it', () async {
      final defaultConf = _defaultConf();
      const mempoolSpaceUrl = "a different mempool space url";
      injector.preferencesMock.mempoolSpaceUrl = mempoolSpaceUrl;
      final config = await Config.getSDKConfig(injector, defaultConf, breezConfig);
      expect(config.mempoolspaceUrl, mempoolSpaceUrl);
    });

    test('mempool space url not set in preferences with no default should use the sdk default', () async {
      final defaultConf = _defaultConf();
      injector.preferencesMock.mempoolSpaceUrl = null;
      final config = await Config.getSDKConfig(injector, defaultConf, breezConfig);
      expect(config.mempoolspaceUrl, defaultConf.mempoolspaceUrl);
    });

    test('working dir should use application documents directory', () async {
      final defaultConf = _defaultConf();
      final config = await Config.getSDKConfig(injector, defaultConf, breezConfig);
      expect(config.workingDir, await platform.getApplicationDocumentsPath());
    });

    test('no network configured in app config should use the default', () async {
      final defaultConf = _defaultConf();
      final config = await Config.getSDKConfig(injector, defaultConf, breezConfig);
      expect(config.network, defaultConf.network);
    });

    test('no payment timeout configured in app config should use the default', () async {
      final defaultConf = _defaultConf();
      final config = await Config.getSDKConfig(injector, defaultConf, breezConfig);
      expect(config.paymentTimeoutSec, defaultConf.paymentTimeoutSec);
    });

    test('no default lsp id configured in app config should use the default', () async {
      final defaultConf = _defaultConf();
      final config = await Config.getSDKConfig(injector, defaultConf, breezConfig);
      expect(config.defaultLspId, defaultConf.defaultLspId);
    });
    test('valid api key configured in app config should use the configured value', () async {
      final defaultConf = _defaultConf();
      const apiKey = "<api-key>";
      final config = await Config.getSDKConfig(injector, defaultConf, breezConfig);
      expect(config.apiKey, apiKey);
    });
  });
}

sdk.Config _defaultConf() => const sdk.Config(
      maxfeePercent: 7.8,
      breezserver: "a breez server",
      mempoolspaceUrl: "a mempool space url",
      workingDir: "a working dir",
      network: sdk.Network.Bitcoin,
      paymentTimeoutSec: 123,
      defaultLspId: "a default lsp id",
      apiKey: "an api key",
    );
