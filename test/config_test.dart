import 'package:breez_sdk/bridge_generated.dart' as sdk;
import 'package:c_breez/config.dart';
import 'package:c_breez/services/injector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import 'mock/ini_config_mock.dart';
import 'mock/injector_mock.dart';
import 'unit_logger.dart';
import 'utils/fake_path_provider_platform.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final platform = FakePathProviderPlatform();
  late InjectorMock injector;
  late IniConfigMock breezConfig;
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
      breezConfig = IniConfigMock();
      ServiceInjector.configure(injector);
      await platform.setUp();
      PathProviderPlatform.instance = platform;
    });

    tearDown(() async {
      await platform.tearDown();
    });


    test('no max fee percent configured in breez.conf should use the default', () async {
      final defaultConf = _defaultConf();
      final config = await Config.getSDKConfig(injector, defaultConf, breezConfig);
      expect(config.maxfeePercent, defaultConf.maxfeePercent);
    });

    test('valid max fee percent configured in breez.conf should use the configured value', () async {
      final defaultConf = _defaultConf();
      const maxFeePercent = 1.2;
      breezConfig.answers[_configName] = {"maxfeepercent": "$maxFeePercent"};
      final config = await Config.getSDKConfig(injector, defaultConf, breezConfig);
      expect(config.maxfeePercent, maxFeePercent);
    });

    test('max fee percent override on preferences should use the configured value', () async {
      final defaultConf = _defaultConf();
      const maxFee = 3.4;
      injector.preferencesMock.paymentOptionsOverrideFeeEnabled = true;
      injector.preferencesMock.paymentOptionsProportionalFee = maxFee;
      final config = await Config.getSDKConfig(injector, defaultConf, breezConfig);
      expect(config.maxfeepercent, maxFee);
    });

    test('max fee percent override on preferences should use the configured value', () async {
      final defaultConf = _defaultConf();
      const maxFee = 3.4;
      injector.preferencesMock.paymentOptionsOverrideFeeEnabled = true;
      injector.preferencesMock.paymentOptionsProportionalFee = maxFee;
      final config = await Config.getSDKConfig(injector, defaultConf, breezConfig);
      expect(config.maxfeepercent, maxFee);
    });

    test('invalid max fee percent configured in breez.conf should use the default', () async {
      final defaultConf = _defaultConf();
      breezConfig.answers[_configName] = {"maxfeepercent": "invalid"};
      final config = await Config.getSDKConfig(injector, defaultConf, breezConfig);
      expect(config.maxfeePercent, defaultConf.maxfeePercent);
    });

    test('no breez server configured in breez.conf should use the default', () async {
      final defaultConf = _defaultConf();
      final config = await Config.getSDKConfig(injector, defaultConf, breezConfig);
      expect(config.breezserver, defaultConf.breezserver);
    });

    test('valid breez server configured in breez.conf should use the configured value', () async {
      final defaultConf = _defaultConf();
      const breezServer = "a different breez server";
      breezConfig.answers[_configName] = {"breezserver": breezServer};
      final config = await Config.getSDKConfig(injector, defaultConf, breezConfig);
      expect(config.breezserver, breezServer);
    });

    test('mempool space url set in preferences should return it', () async {
      final defaultConf = _defaultConf();
      const mempoolSpaceUrl = "a different mempool space url";
      injector.preferencesMock.mempoolSpaceUrl = mempoolSpaceUrl;
      final config = await Config.getSDKConfig(injector, defaultConf, breezConfig);
      expect(config.mempoolspaceUrl, mempoolSpaceUrl);
    });

    test('mempool space url not set in preferences with a default should use the default', () async {
      final defaultConf = _defaultConf();
      injector.preferencesMock.mempoolSpaceUrl = null;
      const defaultMempoolSpaceUrl = "a default mempool space url";
      breezConfig.answers[_configName] = {"mempoolspaceurl": defaultMempoolSpaceUrl};
      final config = await Config.getSDKConfig(injector, defaultConf, breezConfig);
      expect(config.mempoolspaceUrl, defaultMempoolSpaceUrl);
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

    test('no network configured in breez.conf should use the default', () async {
      final defaultConf = _defaultConf();
      final config = await Config.getSDKConfig(injector, defaultConf, breezConfig);
      expect(config.network, defaultConf.network);
    });

    test('valid network configured in breez.conf should use the configured value', () async {
      final defaultConf = _defaultConf();
      breezConfig.answers[_configName] = {"network": "testnet"};
      final config = await Config.getSDKConfig(injector, defaultConf, breezConfig);
      expect(config.network, sdk.Network.Testnet);
    });

    test('invalid network configured in breez.conf should use the default', () async {
      final defaultConf = _defaultConf();
      breezConfig.answers[_configName] = {"network": "invalid"};
      final config = await Config.getSDKConfig(injector, defaultConf, breezConfig);
      expect(config.network, defaultConf.network);
    });

    test('no payment timeout configured in breez.conf should use the default', () async {
      final defaultConf = _defaultConf();
      final config = await Config.getSDKConfig(injector, defaultConf, breezConfig);
      expect(config.paymentTimeoutSec, defaultConf.paymentTimeoutSec);
    });

    test('valid payment timeout configured in breez.conf should use the configured value', () async {
      final defaultConf = _defaultConf();
      const paymentTimeout = 456;
      breezConfig.answers[_configName] = {"paymentTimeoutSec": "$paymentTimeout"};
      final config = await Config.getSDKConfig(injector, defaultConf, breezConfig);
      expect(config.paymentTimeoutSec, paymentTimeout);
    });

    test('invalid payment timeout configured in breez.conf should use the default', () async {
      final defaultConf = _defaultConf();
      breezConfig.answers[_configName] = {"paymentTimeoutSec": "invalid"};
      final config = await Config.getSDKConfig(injector, defaultConf, breezConfig);
      expect(config.paymentTimeoutSec, defaultConf.paymentTimeoutSec);
    });

    test('no default lsp id configured in breez.conf should use the default', () async {
      final defaultConf = _defaultConf();
      final config = await Config.getSDKConfig(injector, defaultConf, breezConfig);
      expect(config.defaultLspId, defaultConf.defaultLspId);
    });

    test('valid default lsp id configured in breez.conf should use the configured value', () async {
      final defaultConf = _defaultConf();
      const defaultLspId = "a different default lsp id";
      breezConfig.answers[_configName] = {"defaultLspId": defaultLspId};
      final config = await Config.getSDKConfig(injector, defaultConf, breezConfig);
      expect(config.defaultLspId, defaultLspId);
    });

    test('no api key configured in breez.conf should use the default', () async {
      final defaultConf = _defaultConf();
      final config = await Config.getSDKConfig(injector, defaultConf, breezConfig);
      expect(config.apiKey, defaultConf.apiKey);
    });

    test('valid api key configured in breez.conf should use the configured value', () async {
      final defaultConf = _defaultConf();
      const apiKey = "a different valid api key";
      breezConfig.answers[_configName] = {"apiKey": apiKey};
      final config = await Config.getSDKConfig(injector, defaultConf, breezConfig);
      expect(config.apiKey, apiKey);
    });
  });
}

const String _configName = "Application Options";

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
