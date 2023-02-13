import 'package:breez_sdk/bridge_generated.dart' as sdk;
import 'package:c_breez/services/injector.dart';
import 'package:flutter/services.dart';
import 'package:ini/ini.dart' as ini;
import 'package:path_provider/path_provider.dart';

class Config {
  static Config? _instance;

  final sdk.Config sdkConfig;

  Config._(this.sdkConfig);

  static Future<Config> instance() async {
    if (_instance == null) {
      final injector = ServiceInjector();
      final breezLib = injector.breezLib;
      String configString = await rootBundle.loadString('conf/breez.conf');
      ini.Config breezConfig = ini.Config.fromString(configString);
      final defaultConf = await breezLib.defaultConfig(sdk.EnvironmentType.Production);
      final sdkConfig = await _getSDKConfig(defaultConf, breezConfig);
      _instance = Config._(sdkConfig);
    }
    return _instance!;
  }

  static Future<sdk.Config> _getSDKConfig(sdk.Config defaultConf, ini.Config breezConfig) async {
    final configuredPaymentTimeout = breezConfig.get("Application Options", "paymentTimeoutSec");
    final configuredMaxFeeSat = breezConfig.get("Application Options", "maxfeesat");
    final configuredMaxFeePercent = breezConfig.get("Application Options", "maxfeepercent");

    sdk.Config config = sdk.Config(
      maxfeeSat: configuredMaxFeeSat != null ? int.parse(configuredMaxFeeSat) : defaultConf.maxfeeSat,
      maxfeepercent:
          configuredMaxFeePercent != null ? double.parse(configuredMaxFeePercent) : defaultConf.maxfeepercent,
      breezserver: breezConfig.get("Application Options", "breezserver") ?? defaultConf.breezserver,
      mempoolspaceUrl: await ServiceInjector().preferences.getMempoolSpaceUrl().then((url) {
        if (url != null) {
          return url;
        } else {
          final fallbackUrl =
              breezConfig.get("Application Options", "mempoolspaceurl") ?? defaultConf.mempoolspaceUrl;
          ServiceInjector().preferences.setMempoolSpaceUrl(fallbackUrl);
          return fallbackUrl;
        }
      }),
      workingDir: (await getApplicationDocumentsDirectory()).path,
      network: sdk.Network.values.firstWhere(
          (n) => n.name.toLowerCase() == (breezConfig.get("Application Options", "network")),
          orElse: () => defaultConf.network),
      paymentTimeoutSec: configuredPaymentTimeout != null
          ? int.parse(configuredPaymentTimeout)
          : defaultConf.paymentTimeoutSec,
      defaultLspId: breezConfig.get("Application Options", "defaultLspId") ?? defaultConf.defaultLspId,
      apiKey: breezConfig.get("Application Options", "apiKey") ?? defaultConf.apiKey,
    );
    return config;
  }
}
