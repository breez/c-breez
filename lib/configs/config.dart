import 'package:breez_sdk/breez_sdk.dart';
import 'package:breez_sdk/sdk.dart' as sdk;
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_group_directory/flutter_app_group_directory.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

import 'app_config.dart';

final Logger _logger = Logger("Config");

class Config {
  static Config? _instance;

  final sdk.Config sdkConfig;
  final sdk.NodeConfig nodeConfig;
  final String? defaultMempoolUrl;

  Config._({required this.sdkConfig, required this.nodeConfig, this.defaultMempoolUrl});

  static Future<Config> instance({ServiceInjector? serviceInjector}) async {
    _logger.info("Getting Config instance");
    if (_instance == null) {
      _logger.info("Creating Config instance");
      final injector = serviceInjector ?? ServiceInjector();
      final breezSDK = injector.breezSDK;
      final breezConfig = await _getBundledConfig();
      final defaultConf = await _getDefaultConf(breezSDK, breezConfig.apiKey, breezConfig.nodeConfig);
      final defaultMempoolUrl = defaultConf.mempoolspaceUrl ?? NetworkConstants.defaultBitcoinMempoolInstance;
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
    _logger.info("Getting bundled config");
    return AppConfig();
  }

  static Future<sdk.Config> _getDefaultConf(
    BreezSDK breezSDK,
    String apiKey,
    sdk.NodeConfig nodeConfig, {
    sdk.EnvironmentType environmentType = sdk.EnvironmentType.Production,
  }) async {
    _logger.info("Getting default SDK config for environment: $environmentType");
    return await breezSDK.defaultConfig(envType: environmentType, apiKey: apiKey, nodeConfig: nodeConfig);
  }

  static Future<sdk.Config> getSDKConfig(
    ServiceInjector serviceInjector,
    sdk.Config defaultConf,
    AppConfig breezConfig,
  ) async {
    _logger.info("Getting SDK config");
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
    final BreezPreferences breezPreferences = serviceInjector.breezPreferences;
    final configuredMaxFeePercent = await breezPreferences.getPaymentOptionsProportionalFee();
    _logger.info("Using maxfeePercent from preferences: $configuredMaxFeePercent");
    return configuredMaxFeePercent;
  }

  static Future<BigInt> _configuredExempMsatFee(
    ServiceInjector serviceInjector,
    sdk.Config defaultConf,
  ) async {
    final BreezPreferences breezPreferences = serviceInjector.breezPreferences;
    final configuredExemptFee = await breezPreferences.getPaymentOptionsExemptFee();
    _logger.info("Using exemptMsatFee from preferences: $configuredExemptFee");
    return BigInt.from(configuredExemptFee);
  }

  static Future<String?> _mempoolSpaceUrl(ServiceInjector serviceInjector, sdk.Config defaultConf) async {
    final BreezPreferences breezPreferences = serviceInjector.breezPreferences;

    final url = await breezPreferences.getMempoolSpaceUrl();
    if (url != null) {
      _logger.info("Using mempoolspace url from preferences: $url");
      return url;
    } else {
      final defaultUrl = defaultConf.mempoolspaceUrl;
      _logger.info("No mempoolspace url in preferences, using default: $defaultUrl");
      return defaultUrl;
    }
  }

  static Future<String> _workingDir() async {
    String path = "";
    if (defaultTargetPlatform == TargetPlatform.android) {
      final workingDir = await getApplicationDocumentsDirectory();
      path = workingDir.path;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      final String appGroupDirectory =  "group.${const String.fromEnvironment("APP_ID_PREFIX")}.com.cBreez.client";
      final sharedDirectory = await FlutterAppGroupDirectory.getAppGroupDirectory(appGroupDirectory);
      if (sharedDirectory == null) {
        throw Exception("Could not get shared directory");
      }
      path = sharedDirectory.path;
    }
    _logger.info("Using workingDir: $path");
    return path;
  }
}
