import 'package:breez_sdk/breez_bridge.dart';
import 'package:breez_sdk/sdk.dart';
import 'package:c_breez/services/breez_server.dart';
import 'package:c_breez/services/device.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/services/keychain.dart';
import 'package:c_breez/services/lightning_links.dart';
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
import 'input_parser_mock.dart';
import 'key_chain_mock.dart';
import 'lightning_links_service_mock.dart';
import 'preferences_mock.dart';
import 'shared_preferences_mock.dart';

class InjectorMock extends Mock implements ServiceInjector {
  final sharedPreferencesMock = SharedPreferencesMock();

  @override
  Future<SharedPreferences> get sharedPreferences async => sharedPreferencesMock;

  final deviceMock = DeviceMock();

  @override
  Device get device => deviceMock;

  final firebaseNotificationsMock = FirebaseNotificationsMock();

  @override
  Notifications get notifications => firebaseNotificationsMock;

  final keyChainMock = KeyChainMock();

  @override
  KeyChain get keychain => keyChainMock;

  MockClientHandler? mockHandler;

  @override
  Client get client {
    final handler = mockHandler ?? (request) => Future.value(Response('', 200));
    return MockClient(handler);
  }

  final breezServerMock = BreezServerMock();

  @override
  BreezServer get breezServer => breezServerMock;

  final breezLibMock = BreezBridgeMock();

  @override
  BreezBridge get breezLib => breezLibMock;

  final preferencesMock = PreferencesMock();

  @override
  Preferences get preferences => preferencesMock;

  final lightningLinksMock = LightningLinksServiceMock();

  @override
  LightningLinksService get lightningLinks => lightningLinksMock;

  final inputParserMock = InputParserMock();

  @override
  InputParser get inputParser => inputParserMock;
}
