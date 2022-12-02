import 'dart:async';

import 'package:c_breez/services/keychain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class KeyChainMock extends Mock implements KeyChain {
  final _storage = <String, String>{};

  @override
  Future<String> read(String key) {
    return Future.value(_storage[key]);
  }

  @override
  Future write(String key, String value) {
    _storage[key] = value;
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
