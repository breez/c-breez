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
      String configString = await rootBundle.loadString('conf/breez.conf');
      ini.Config breezConfig = ini.Config.fromString(configString);
      final sdkConfig = await _getSDKConfig(breezConfig);
      final firebaseOptions = _getFirebaseOptions(breezConfig);
      _instance = Config._(sdkConfig, firebaseOptions);
    }
    return _instance!;
  }

  static Future<sdk.Config> _getSDKConfig(ini.Config breezConfig) async {
    sdk.Config config = sdk.Config(
      breezserver: breezConfig.get("Application Options", "breezserver") ?? "",
      mempoolspaceUrl: await ServiceInjector()
          .preferences
          .getMempoolSpaceUrl()
          .then((url) => url ?? breezConfig.get("Application Options", "mempoolspaceurl") ?? ""),
      workingDir: (await getApplicationDocumentsDirectory()).path,
      network: sdk.Network.values
          .firstWhere((n) => n.name.toLowerCase() == (breezConfig.get("Application Options", "network") ?? "bitcoin")),
      paymentTimeoutSec: int.parse(breezConfig.get("Application Options", "paymentTimeoutSec") ?? "30"),
      defaultLspId: breezConfig.get("Application Options", "defaultLspId"),
      apiKey: breezConfig.get("Application Options", "apiKey"),
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
