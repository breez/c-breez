import 'package:breez_sdk/bridge_generated.dart' as sdk;
import 'package:c_breez/services/injector.dart';
import 'package:flutter/foundation.dart';
import 'package:ini/ini.dart' as ini;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class Config {
  static Config? _instance;

  final sdk.Config sdkConfig;
  final FirebaseOptions firebaseOptions;

  Config._(this.sdkConfig, this.firebaseOptions);

  static Future<Config> instance() async {
    if (_instance == null) {
      final injector = ServiceInjector();
      final breezLib = injector.breezLib;
      String configString = await rootBundle.loadString('conf/breez.conf');
      ini.Config breezConfig = ini.Config.fromString(configString);
      final defaultConf = await breezLib.defaultConfig(sdk.EnvironmentType.Production);
      final sdkConfig = await _getSDKConfig(defaultConf, breezConfig);      
      final firebaseOptions = _getFirebaseOptions(breezConfig);
      _instance = Config._(sdkConfig, firebaseOptions);
    }
    return _instance!;
  }

  static Future<sdk.Config> _getSDKConfig(sdk.Config defaultConf, ini.Config breezConfig) async {    
    final configuredPaymentTimeout = breezConfig.get("Application Options", "paymentTimeoutSec");
    sdk.Config config = sdk.Config(
      breezserver: breezConfig.get("Application Options", "breezserver") ?? defaultConf.breezserver,
      mempoolspaceUrl: await ServiceInjector()
          .preferences
          .getMempoolSpaceUrl()
          .then((url) => url ?? breezConfig.get("Application Options", "mempoolspaceurl") ?? defaultConf.mempoolspaceUrl),
      workingDir: (await getApplicationDocumentsDirectory()).path,
      network: sdk.Network.values
          .firstWhere((n) => n.name.toLowerCase() == (breezConfig.get("Application Options", "network")), orElse: () => defaultConf.network),
      paymentTimeoutSec: configuredPaymentTimeout != null ? int.parse(configuredPaymentTimeout) : defaultConf.paymentTimeoutSec,
      defaultLspId: breezConfig.get("Application Options", "defaultLspId") ?? defaultConf.defaultLspId,
      apiKey: breezConfig.get("Application Options", "apiKey") ?? defaultConf.apiKey,
    );
    return config;
  }

  static FirebaseOptions _getFirebaseOptions(ini.Config breezConfig) {
    final ios = defaultTargetPlatform == TargetPlatform.iOS;
    final configOptions = ios ? "Firebase IOS" : "Firebase Android";
    return FirebaseOptions(
      apiKey: breezConfig.get(configOptions, "apiKey")!,
      appId: breezConfig.get(configOptions, "appId")!,
      messagingSenderId: breezConfig.get(configOptions, "messagingSenderId")!,
      projectId: breezConfig.get(configOptions, "projectId")!,
      authDomain: breezConfig.get(configOptions, "authDomain"),
      databaseURL: breezConfig.get(configOptions, "databaseURL"),
      storageBucket: breezConfig.get(configOptions, "storageBucket"),
      measurementId: breezConfig.get(configOptions, "measurementId"),

      // ios specific
      trackingId: breezConfig.get(configOptions, "trackingId"),
      deepLinkURLScheme: breezConfig.get(configOptions, "deepLinkURLScheme"),
      androidClientId: breezConfig.get(configOptions, "androidClientId"),
      iosClientId: breezConfig.get(configOptions, "iosClientId"),
      iosBundleId: breezConfig.get(configOptions, "iosBundleId"),
      appGroupId: breezConfig.get(configOptions, "appGroupId"),
    );
  }
}
