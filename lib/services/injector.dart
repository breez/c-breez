import 'dart:async';

import 'package:breez_sdk/sdk.dart' as breez_sdk;
import 'package:c_breez/services/breez_server/server.dart';
import 'package:c_breez/services/deep_links.dart';
import 'package:c_breez/services/device.dart';
import 'package:c_breez/services/keychain.dart';
import 'package:c_breez/services/lightning_links.dart';
import 'package:c_breez/services/notifications.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'background_task.dart';

class ServiceInjector {
  static final _singleton = ServiceInjector._internal();
  static ServiceInjector? _injector;

  BreezServer? _breezServer;
  FirebaseNotifications? _notifications;
  breez_sdk.LightningNode? _lightningService;
  DeepLinksService? _deepLinksService;

  // breez sdk
  LightningLinksService? _lightningLinksService;
  breez_sdk.LSPService? _lspService;
  breez_sdk.LNURLService? _lnurlService;
  breez_sdk.FiatService? _fiatService;

  Device? _device;
  Future<SharedPreferences>? _sharedPreferences =
      SharedPreferences.getInstance();
  BackgroundTaskService? _backgroundTaskService;
  breez_sdk.Storage? _appStorage;
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

  breez_sdk.LightningNode get lightningServices {
    if (_lightningService != null) {
      return _lightningService!;
    }

    return _lightningService ??= breez_sdk.LightningNode();
  }

  Device get device {
    return _device ??= Device();
  }

  DeepLinksService get deepLinks => _deepLinksService ??= DeepLinksService();

  LightningLinksService get lightningLinks =>
      _lightningLinksService ??= LightningLinksService();

  breez_sdk.LSPService get lspService =>
      _lspService ??= lightningServices.lspService;

  breez_sdk.LNURLService get lnurlService =>
      _lnurlService ??= lightningServices.lnurlService;

  breez_sdk.FiatService get fiatService =>
      _fiatService ??= lightningServices.fiatService;

  Future<SharedPreferences> get sharedPreferences =>
      _sharedPreferences ??= SharedPreferences.getInstance();

  BackgroundTaskService get backgroundTaskService {
    return _backgroundTaskService ??= BackgroundTaskService();
  }

  Client get client {
    return _client ??= Client();
  }

  breez_sdk.Storage get sdkStorage {
    return _appStorage ??= breez_sdk.Storage.createDefault();
  }

  KeyChain get keychain {
    return _keychain ??= KeyChain();
  }
}
