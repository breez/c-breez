import 'dart:convert';
import 'dart:typed_data';

import 'package:breez_sdk/breez_bridge.dart';
import 'package:breez_sdk/bridge_generated.dart' as sdk;
import 'package:c_breez/services/injector.dart';
import 'package:fimber/fimber.dart';
import 'package:path_provider/path_provider.dart';

import 'app_config.dart';

final _log = FimberLog("Config");

class Config {
  static Config? _instance;

  final sdk.Config sdkConfig;
  final String defaultMempoolUrl;
  final Uint8List? glCert;
  final Uint8List? glKey;

  Config._(this.sdkConfig, this.defaultMempoolUrl, this.glCert, this.glKey);

  static Future<Config> instance({
    ServiceInjector? serviceInjector,
  }) async {
    _log.v("Getting Config instance");
    if (_instance == null) {
      _log.v("Creating Config instance");
      final injector = serviceInjector ?? ServiceInjector();
      final breezLib = injector.breezLib;
      final breezConfig = await _getBundledConfig();
      final defaultConf = await _getDefaultConf(breezLib);
      final defaultMempoolUrl = defaultConf.mempoolspaceUrl;
      final sdkConfig = await getSDKConfig(injector, defaultConf, breezConfig);
      _instance = Config._(
        sdkConfig,
        defaultMempoolUrl,
        breezConfig.glCertificate == glCertificatePlaceholder
            ? null
            : base64.decode(breezConfig.glCertificate),
        breezConfig.glKey == glKeyPlaceholder ? null : base64.decode(breezConfig.glKey),
      );
    }
    return _instance!;
  }

  static Future<AppConfig> _getBundledConfig() async {
    _log.v("Getting bundled config");
    return AppConfig();
  }

  static Future<sdk.Config> _getDefaultConf(
    BreezBridge breezLib, {
    sdk.EnvironmentType environmentType = sdk.EnvironmentType.Production,
  }) async {
    _log.v("Getting default SDK config for environment: $environmentType");
    return await breezLib.defaultConfig(environmentType);
  }

  static Future<sdk.Config> getSDKConfig(
    ServiceInjector serviceInjector,
    sdk.Config defaultConf,
    AppConfig breezConfig,
  ) async {
    _log.v("Getting SDK config");
    return defaultConf.copyWith(
      maxfeePercent: await _configuredMaxFeePercent(serviceInjector, defaultConf),
      workingDir: await _workingDir(),
      mempoolspaceUrl: await _mempoolSpaceUrl(serviceInjector, defaultConf),
      apiKey: breezConfig.apiKey,
    );
  }

  static Future<double> _configuredMaxFeePercent(
    ServiceInjector serviceInjector,
    sdk.Config defaultConf,
  ) async {
    final preferences = serviceInjector.preferences;
    final configuredMaxFeeEnabled = await preferences.getPaymentOptionsOverrideFeeEnabled();
    if (configuredMaxFeeEnabled) {
      final configuredMaxFeePercent = await preferences.getPaymentOptionsProportionalFee();
      _log.v("Using maxfeePercent from preferences: $configuredMaxFeePercent");
      return configuredMaxFeePercent;
    }
    return defaultConf.maxfeePercent;
  }

  static Future<String> _mempoolSpaceUrl(
    ServiceInjector serviceInjector,
    sdk.Config defaultConf,
  ) async {
    final preferences = serviceInjector.preferences;

    final url = await preferences.getMempoolSpaceUrl();
    if (url != null) {
      _log.v("Using mempoolspace url from preferences: $url");
      return url;
    } else {
      final defaultUrl = defaultConf.mempoolspaceUrl;
      _log.v("No mempoolspace url in preferences, using default: $defaultUrl");
      return defaultUrl;
    }
  }

  static Future<String> _workingDir() async {
    final workingDir = await getApplicationDocumentsDirectory();
    final path = workingDir.path;
    _log.v("Using workingDir: $path");
    return path;
  }
}
