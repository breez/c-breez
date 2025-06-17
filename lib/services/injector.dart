import 'dart:async';

import 'package:breez_sdk/breez_sdk.dart';
import 'package:c_breez/bloc/account/credentials_manager.dart';
import 'package:c_breez/services/services.dart';
import 'package:c_breez/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceInjector {
  static final _singleton = ServiceInjector._internal();
  static ServiceInjector? _injector;

  FirebaseNotificationsClient? _notifications;

  BreezSDK? _breezSDK;
  LightningLinksService? _lightningLinksService;

  DeviceClient? _deviceClient;
  Future<SharedPreferences>? _sharedPreferences = SharedPreferences.getInstance();
  KeyChain? _keychain;
  CredentialsManager? _credentialsManager;
  BreezPreferences? _breezPreferences;
  BreezLogger? _breezLogger;

  factory ServiceInjector() => _injector ?? _singleton;

  ServiceInjector._internal();

  static void configure(ServiceInjector injector) => _injector = injector;

  NotificationsClient get notifications => _notifications ??= FirebaseNotificationsClient();

  DeviceClient get deviceClient => _deviceClient ??= DeviceClient();

  LightningLinksService get lightningLinks => _lightningLinksService ??= LightningLinksService();

  Future<SharedPreferences> get sharedPreferences => _sharedPreferences ??= SharedPreferences.getInstance();

  KeyChain get keychain => _keychain ??= KeyChain();

  CredentialsManager get credentialsManager => _credentialsManager ??= CredentialsManager(keyChain: keychain);

  BreezPreferences get breezPreferences => _breezPreferences ??= const BreezPreferences();

  BreezLogger get breezLogger => _breezLogger ??= BreezLogger();

  BreezSDK get breezSDK => _breezSDK ??= BreezSDK();
}
