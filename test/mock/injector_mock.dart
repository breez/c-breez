import 'package:breez_sdk/breez_bridge.dart';
import 'package:c_breez/services/breez_server.dart';
import 'package:c_breez/services/device.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/services/keychain.dart';
import 'package:c_breez/services/notifications.dart';
import 'package:c_breez/utils/preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'breez_bridge_mock.dart';
import 'breez_server_mock.dart';
import 'device_mock.dart';
import 'firebase_notifications_mock.dart';
import 'key_chain_mock.dart';
import 'preferences_mock.dart';
import 'shared_preferences_mock.dart';

class InjectorMock extends Mock implements ServiceInjector {
  MockClientHandler? mockHandler;

  @override
  Future<SharedPreferences> get sharedPreferences async {
    return SharedPreferencesMock();
  }

  @override
  Device get device => DeviceMock();

  @override
  Notifications get notifications => FirebaseNotificationsMock();

  KeyChain mockKeyChain = KeyChainMock();

  @override
  KeyChain get keychain => mockKeyChain;

  @override
  Client get client {
    final handler = mockHandler ?? (request) => Future.value(Response('', 200));
    return MockClient(handler);
  }

  @override
  BreezServer get breezServer => BreezServerMock();

  @override
  BreezBridge get breezLib => BreezBridgeMock();

  @override
  Preferences get preferences => PreferencesMock();
}
