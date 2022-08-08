// ignore_for_file: avoid_print

import 'dart:async';

import 'package:breez_sdk/sdk.dart';
import 'package:c_breez/services/breez_server/server.dart';
import 'package:c_breez/services/device.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/services/keychain.dart';
import 'package:c_breez/services/notifications.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/src/mixin/handler_mixin.dart';

class KeychainMoc extends Mock implements KeyChain {
  final _storage = <String, String>{};
  @override
  Future<String> read(String key) {
    return Future.value(_storage[key]);
  }

  @override
  Future write(String key, String value) {
    _storage[key] = value;
    print("keychain: $value");
    return Future.value(null);
  }

  @override
  Future delete(String key) {
    _storage.remove(key);
    return Future.value(null);
  }

  @override
  Future clear() {
    _storage.clear();
    return Future.value(null);
  }
}

class SharedPreferencesMock extends Mock implements SharedPreferences {
  final Map<String, bool> _cache = {};

  @override
  bool getBool(String key) {
    return _cache[key]!;
  }

  @override
  Future<bool> setBool(String key, bool value) {
    _cache[key] = value;
    return Future<bool>.value(value);
  }
}

class BreezServerMock extends Mock implements BreezServer {
  @override
  Future<String> registerDevice(String token, String nodeid) {
    return Future<String>.value("1234");
  }
}

class NotificationsMock extends Mock implements Notifications {
  @override
  Future<String> getToken() {
    return Future<String>.value("dummy token");
  }

  @override
  Stream<Map<String, dynamic>> get notifications =>
      BehaviorSubject<Map<String, dynamic>>().stream;
}

class DeviceMock extends Mock implements Device {}

class FirebaseNotificationsMock extends Mock implements FirebaseNotifications {
  @override
  Future<String> getToken() => Future.value('a token');
}

class InjectorMock extends Mock implements ServiceInjector {
  MockClientHandler? mockHandler;
  LightningNode? _lightningService;

  @override
  Future<LightningNode> get lightningServices async {
    if (_lightningService != null) {
      return Future.value(_lightningService);
    }

    return _lightningService ??= LightningNode(lspService, Storage.createDefault());
  }

  @override
  Future<SharedPreferences> get sharedPreferences async {
    return SharedPreferencesMock();
  }

  @override
  Device get device => DeviceMock();

  @override
  Notifications get notifications => FirebaseNotificationsMock();

  @override
  KeyChain get keychain => KeychainMoc();

  @override
  Storage get sdkStorage {
    return Storage.createInMemory();
  }

  @override
  Client get client {
    final handler = mockHandler ?? (request) => Future.value(Response('', 200));
    return MockClient(handler);
  }
}

void sqfliteFfiInitAsMockMethodCallHandler() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final binding = TestDefaultBinaryMessengerBinding.instance!;
  binding.defaultBinaryMessenger.setMockMethodCallHandler(
    const MethodChannel('com.tekartik.sqflite'),
    (methodCall) async {
      try {
        return await FfiMethodCall(
          methodCall.method,
          methodCall.arguments,
        ).handleInIsolate();
      } on SqfliteFfiException catch (e) {
        throw PlatformException(
          code: e.code,
          message: e.message,
          details: e.details,
        );
      }
    },
  );
}
