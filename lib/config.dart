import 'package:breez_sdk/bridge_generated.dart' as sdk;
import 'package:c_breez/services/injector.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/services.dart';
import 'package:ini/ini.dart' as ini;
import 'package:path_provider/path_provider.dart';

const String _configName = "Application Options";

final _log = FimberLog("Config");

class Config {
  static Config? _instance;

  final sdk.Config sdkConfig;

  Config._(this.sdkConfig);

  static Future<Config> instance({
    ServiceInjector? serviceInjector,
  }) async {
    _log.v("Getting Config instance");
    if (_instance == null) {
      _log.v("Creating Config instance");
      final injector = serviceInjector ?? ServiceInjector();
      final breezLib = injector.breezLib;
      String configString = await rootBundle.loadString('conf/breez.conf');
      ini.Config breezConfig = ini.Config.fromString(configString);
      final defaultConf = await breezLib.defaultConfig(sdk.EnvironmentType.Production);
      final sdkConfig = await getSDKConfig(injector, defaultConf, breezConfig);
      _instance = Config._(sdkConfig);
    }
    return _instance!;
  }

  static Future<sdk.Config> getSDKConfig(
    ServiceInjector serviceInjector,
    sdk.Config defaultConf,
    ini.Config breezConfig,
  ) async {
    _log.v("Getting SDK config");
    return sdk.Config(
      maxfeeSat: _maxFeeSat(defaultConf, breezConfig),
      maxfeepercent: _configuredMaxFeePercent(defaultConf, breezConfig),
      breezserver: _breezServer(breezConfig, defaultConf),
      mempoolspaceUrl: await _mempoolSpaceUrl(serviceInjector, breezConfig, defaultConf),
      workingDir: await _workingDir(),
      network: _networkName(breezConfig, defaultConf),
      paymentTimeoutSec: _paymentTimeoutSec(breezConfig, defaultConf),
      defaultLspId: _defaultLspId(breezConfig, defaultConf),
      apiKey: _apiKey(breezConfig, defaultConf),
    );
  }

  static int? _maxFeeSat(sdk.Config defaultConf, ini.Config breezConfig) {
    final configuredMaxFeeSat = breezConfig.get(_configName, "maxfeesat");
    if (configuredMaxFeeSat == null) {
      _log.v("No maxfeesat configured in breez.conf, using default: ${defaultConf.maxfeeSat}");
      return defaultConf.maxfeeSat;
    }
    try {
      _log.v("Using maxfeesat from breez.conf: $configuredMaxFeeSat");
      return int.parse(configuredMaxFeeSat);
    } catch (e) {
      _log.w("Failed to parse maxfeesat from breez.conf: $configuredMaxFeeSat", ex: e);
      return defaultConf.maxfeeSat;
    }
  }

  static double _configuredMaxFeePercent(sdk.Config defaultConf, ini.Config breezConfig) {
    final configuredMaxFeePercent = breezConfig.get(_configName, "maxfeepercent");
    if (configuredMaxFeePercent == null) {
      _log.v("No maxfeepercent configured in breez.conf, using default: ${defaultConf.maxfeepercent}");
      return defaultConf.maxfeepercent;
    }
    try {
      _log.v("Using maxfeepercent from breez.conf: $configuredMaxFeePercent");
      return double.parse(configuredMaxFeePercent);
    } catch (e) {
      _log.w("Failed to parse maxfeepercent from breez.conf: $configuredMaxFeePercent", ex: e);
      return defaultConf.maxfeepercent;
    }
  }

  static String _breezServer(ini.Config breezConfig, sdk.Config defaultConf) {
    final configuredBreezServer = breezConfig.get(_configName, "breezserver");
    if (configuredBreezServer == null) {
      _log.v("No breezserver configured in breez.conf, using default: ${defaultConf.breezserver}");
      return defaultConf.breezserver;
    }
    _log.v("Using breezserver from breez.conf: $configuredBreezServer");
    return configuredBreezServer;
  }

  static Future<String> _mempoolSpaceUrl(
    ServiceInjector serviceInjector,
    ini.Config breezConfig,
    sdk.Config defaultConf,
  ) async {
    final preferences = serviceInjector.preferences;

    var fallbackUrl = breezConfig.get(_configName, "mempoolspaceurl");
    if (fallbackUrl != null) {
      _log.v("Using fallback mempoolspace url from breez conf: $fallbackUrl");
    } else {
      fallbackUrl = defaultConf.mempoolspaceUrl;
      _log.v("Using fallback mempoolspace url from default conf: $fallbackUrl");
    }
    await preferences.setMempoolSpaceFallbackUrl(fallbackUrl);

    final url = await preferences.getMempoolSpaceUrl();
    if (url != null) {
      _log.v("Using mempoolspace url from preferences: $url");
      return url;
    } else {
      _log.v("No mempoolspace url in preferences, using fallback: $fallbackUrl");
      return fallbackUrl;
    }
  }

  static Future<String> _workingDir() async {
    final workingDir = await getApplicationDocumentsDirectory();
    final path = workingDir.path;
    _log.v("Using workingDir: $path");
    return path;
  }

  static sdk.Network _networkName(ini.Config breezConfig, sdk.Config defaultConf) {
    final configuredNetwork = breezConfig.get(_configName, "network")?.toLowerCase();
    if (configuredNetwork == null) {
      _log.v("No network configured in breez.conf, using default: ${defaultConf.network}");
      return defaultConf.network;
    }
    _log.v("Using network from breez.conf: $configuredNetwork");
    return sdk.Network.values.firstWhere(
      (network) => network.name.toLowerCase() == configuredNetwork,
      orElse: () {
        _log.w("Failed to parse from breez.conf: $configuredNetwork, using default: ${defaultConf.network}");
        return defaultConf.network;
      },
    );
  }

  static int _paymentTimeoutSec(ini.Config breezConfig, sdk.Config defaultConf) {
    final configuredPaymentTimeout = breezConfig.get(_configName, "paymentTimeoutSec");
    if (configuredPaymentTimeout == null) {
      _log.v("No paymentTimeoutSec configured in breez.conf using default: ${defaultConf.paymentTimeoutSec}");
      return defaultConf.paymentTimeoutSec;
    }
    try {
      _log.v("Using paymentTimeoutSec from breez.conf: $configuredPaymentTimeout");
      return int.parse(configuredPaymentTimeout);
    } catch (e) {
      _log.w("Failed to parse paymentTimeoutSec from breez.conf: $configuredPaymentTimeout", ex: e);
      return defaultConf.paymentTimeoutSec;
    }
  }

  static String? _defaultLspId(ini.Config breezConfig, sdk.Config defaultConf) {
    final configuredDefaultLspId = breezConfig.get(_configName, "defaultLspId");
    if (configuredDefaultLspId == null) {
      _log.v("No defaultLspId configured in breez.conf, using default: ${defaultConf.defaultLspId}");
      return defaultConf.defaultLspId;
    }
    _log.v("Using defaultLspId from breez.conf: $configuredDefaultLspId");
    return configuredDefaultLspId;
  }

  static String? _apiKey(ini.Config breezConfig, sdk.Config defaultConf) {
    final configuredApiKey = breezConfig.get(_configName, "apiKey");
    if (configuredApiKey == null) {
      _log.v("No apiKey configured in breez.conf, using default: ${defaultConf.apiKey}");
      return defaultConf.apiKey;
    }
    _log.v("Using apiKey from breez.conf: $configuredApiKey");
    return configuredApiKey;
  }
}
