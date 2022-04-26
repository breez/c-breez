import 'dart:convert';

import 'package:c_breez/repositorires/app_storage.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class SqliteHydrateStorage implements Storage {
  final AppStorage _storage;
  Map<String, dynamic> _allSettings = {};

  SqliteHydrateStorage(this._storage);

  Future readAll() {
    return _storage.readAllSettings().then((s) {
      _allSettings = <String, dynamic>{};
      for (var s in s) {
        _allSettings[s.key] = s.value;
      }
    });
  }

  @override
  dynamic read(String key) {
    var value = _allSettings[key];
    if (value == null) {
      return value;
    }
    var decoded = jsonDecode(value);
    return decoded;
  }

  @override
  Future<void> write(String key, dynamic value) async {
    var toWrite = jsonEncode(value);
    await _storage.updateSettings(key, toWrite).then((_) => readAll());
  }

  @override
  Future<void> delete(String key) async {
    return Future.value(null);
  }

  @override
  Future<void> clear() async {
    return Future.value(null);
  }
}
