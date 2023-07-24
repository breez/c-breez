import 'dart:async';

import 'package:breez_sdk/breez_bridge.dart';
import 'package:c_breez/services/breez_server.dart';
import 'package:c_breez/services/deep_links.dart';
import 'package:c_breez/services/device.dart';
import 'package:c_breez/services/keychain.dart';
import 'package:c_breez/services/lightning_links.dart';
import 'package:c_breez/services/notifications.dart';
import 'package:c_breez/utils/preferences.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'background_task.dart';

class ServiceInjector {
  static final _singleton = ServiceInjector._internal();
  static ServiceInjector? _injector;

  BreezServer? _breezServer;
  FirebaseNotifications? _notifications;
  DeepLinksService? _deepLinksService;

  // breez sdk
  BreezSDK? _breezSDK;
  LightningLinksService? _lightningLinksService;

  Device? _device;
  Future<SharedPreferences>? _sharedPreferences = SharedPreferences.getInstance();
  BackgroundTaskService? _backgroundTaskService;
  KeyChain? _keychain;
  Client? _client;
  Preferences? _preferences;

  factory ServiceInjector() {
    return _injector ?? _singleton;
  }

  ServiceInjector._internal();

  static void configure(ServiceInjector injector) {
    _injector = injector;
  }

  Notifications get notifications {
    return _notifications ??= FirebaseNotifications();
  }

  BreezServer get breezServer {
    return _breezServer ??= BreezServer();
  }

  BreezSDK get breezSDK => _breezSDK ??= BreezSDK();

  Device get device {
    return _device ??= Device();
  }

  DeepLinksService get deepLinks => _deepLinksService ??= DeepLinksService();

  LightningLinksService get lightningLinks => _lightningLinksService ??= LightningLinksService();

  Future<SharedPreferences> get sharedPreferences => _sharedPreferences ??= SharedPreferences.getInstance();

  BackgroundTaskService get backgroundTaskService {
    return _backgroundTaskService ??= BackgroundTaskService();
  }

  Client get client {
    return _client ??= Client();
  }

  KeyChain get keychain {
    return _keychain ??= KeyChain();
  }

  Preferences get preferences {
    return _preferences ??= Preferences();
  }
}
