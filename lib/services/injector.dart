import 'dart:async';

import 'package:c_breez/repositorires/app_storage.dart';
import 'package:c_breez/repositorires/dao/db.dart';
import 'package:c_breez/services/breez_server/server.dart';
import 'package:c_breez/services/deep_links.dart';
import 'package:c_breez/services/device.dart';
import 'package:c_breez/services/lightning_links.dart';
import 'package:c_breez/services/local_auth_service.dart';
import 'package:c_breez/services/notifications.dart';
import 'package:c_breez/services/lightning/greenlight/service.dart';
import 'package:c_breez/services/lightning/interface.dart';
import 'package:c_breez/services/keychain.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'background_task.dart';

class ServiceInjector {
  static final _singleton = ServiceInjector._internal();
  static ServiceInjector? _injector;

  BreezServer? _breezServer;
  FirebaseNotifications? _notifications;
  LightningService? _lightningService;
  DeepLinksService? _deepLinksService;
  LightningLinksService? _lightningLinksService;
  Device? _device;
  Future<SharedPreferences>? _sharedPreferences =
      SharedPreferences.getInstance();
  BackgroundTaskService? _backgroundTaskService;
  LocalAuthenticationService? _localAuthService;
  AppStorage? _appStorage;
  KeyChain? _keychain;
  Client? _client;

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

  LightningService get breezBridge {
    return _lightningService ??= GreenlightService();
  }

  Device get device {
    return _device ??= Device();
  }

  DeepLinksService get deepLinks => _deepLinksService ??= DeepLinksService();

  LightningLinksService get lightningLinks =>
      _lightningLinksService ??= LightningLinksService();

  Future<SharedPreferences> get sharedPreferences =>
      _sharedPreferences ??= SharedPreferences.getInstance();

  BackgroundTaskService get backgroundTaskService {
    return _backgroundTaskService ??= BackgroundTaskService();
  }

  LocalAuthenticationService get localAuthService {
    return _localAuthService ??= LocalAuthenticationService();
  }

  Client get client {
    return _client ??= Client();
  }

  AppStorage get appStorage {
    return _appStorage ??= AppDatabase();
  }

  KeyChain get keychain {
    return _keychain ??= KeyChain();
  }
}
