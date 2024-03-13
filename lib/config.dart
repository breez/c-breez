import 'package:breez_sdk/breez_sdk.dart';
import 'package:breez_sdk/bridge_generated.dart' as sdk;
import 'package:c_breez/services/injector.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:app_group_directory/app_group_directory.dart';
import 'package:path_provider/path_provider.dart';

import 'app_config.dart';

final _log = Logger("Config");

class Config {
  static Config? _instance;

  final sdk.Config sdkConfig;
  final sdk.NodeConfig nodeConfig;
  final String defaultMempoolUrl;

  Config._({
    required this.sdkConfig,
    required this.nodeConfig,
    required this.defaultMempoolUrl,
  });

  static Future<Config> instance({
    ServiceInjector? serviceInjector,
  }) async {
    _log.info("Getting Config instance");
    if (_instance == null) {
      _log.info("Creating Config instance");
      final injector = serviceInjector ?? ServiceInjector();
      final breezSDK = injector.breezSDK;
      final breezConfig = await _getBundledConfig();
      final defaultConf = await _getDefaultConf(breezSDK, breezConfig.apiKey, breezConfig.nodeConfig);
      final defaultMempoolUrl = defaultConf.mempoolspaceUrl;
      final sdkConfig = await getSDKConfig(injector, defaultConf, breezConfig);

      _instance = Config._(
        sdkConfig: sdkConfig,
        nodeConfig: breezConfig.nodeConfig,
        defaultMempoolUrl: defaultMempoolUrl,
      );
    }
    return _instance!;
  }

  static Future<AppConfig> _getBundledConfig() async {
    _log.info("Getting bundled config");
    return AppConfig();
  }

  static Future<sdk.Config> _getDefaultConf(
    BreezSDK breezSDK,
    String apiKey,
    sdk.NodeConfig nodeConfig, {
    sdk.EnvironmentType environmentType = sdk.EnvironmentType.Production,
  }) async {
    _log.info("Getting default SDK config for environment: $environmentType");
    return await breezSDK.defaultConfig(
      envType: environmentType,
      apiKey: apiKey,
      nodeConfig: nodeConfig,
    );
  }

  static Future<sdk.Config> getSDKConfig(
    ServiceInjector serviceInjector,
    sdk.Config defaultConf,
    AppConfig breezConfig,
  ) async {
    _log.info("Getting SDK config");
    return defaultConf.copyWith(
      maxfeePercent: await _configuredMaxFeePercent(serviceInjector, defaultConf),
      workingDir: await _workingDir(),
      mempoolspaceUrl: await _mempoolSpaceUrl(serviceInjector, defaultConf),
      exemptfeeMsat: await _configuredExempMsatFee(serviceInjector, defaultConf),
      apiKey: breezConfig.apiKey,
    );
  }

  static Future<double> _configuredMaxFeePercent(
    ServiceInjector serviceInjector,
    sdk.Config defaultConf,
  ) async {
    final preferences = serviceInjector.preferences;
    final configuredMaxFeePercent = await preferences.getPaymentOptionsProportionalFee();
    _log.info("Using maxfeePercent from preferences: $configuredMaxFeePercent");
    return configuredMaxFeePercent;
  }

  static Future<int> _configuredExempMsatFee(
    ServiceInjector serviceInjector,
    sdk.Config defaultConf,
  ) async {
    final preferences = serviceInjector.preferences;
    final configuredExemptFee = await preferences.getPaymentOptionsExemptFee();
    _log.info("Using exemptMsatFee from preferences: $configuredExemptFee");
    return configuredExemptFee;
  }

  static Future<String> _mempoolSpaceUrl(
    ServiceInjector serviceInjector,
    sdk.Config defaultConf,
  ) async {
    final preferences = serviceInjector.preferences;

    final url = await preferences.getMempoolSpaceUrl();
    if (url != null) {
      _log.info("Using mempoolspace url from preferences: $url");
      return url;
    } else {
      final defaultUrl = defaultConf.mempoolspaceUrl;
      _log.info("No mempoolspace url in preferences, using default: $defaultUrl");
      return defaultUrl;
    }
  }

  static Future<String> _workingDir() async {
    String path = "";
    if (defaultTargetPlatform == TargetPlatform.android) {
      final workingDir = await getApplicationDocumentsDirectory();
      path = workingDir.path;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      final sharedDirectory = await AppGroupDirectory.getAppGroupDirectory(
        "group.${const String.fromEnvironment("APP_ID_PREFIX")}.com.cBreez.client",
      );
      if (sharedDirectory == null) {
        throw Exception("Could not get shared directory");
      }
      path = sharedDirectory.path;
    }
    _log.info("Using workingDir: $path");
    return path;
  }
}
