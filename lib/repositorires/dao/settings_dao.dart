import 'package:drift/drift.dart';
import './db.dart';
part 'settings_dao.g.dart';


@DriftAccessor(tables: [Settings])
class SettingsDao extends DatabaseAccessor<AppDatabase> with _$SettingsDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  SettingsDao(AppDatabase db) : super(db);

  Future<int> updateSettings(String key, String value) {
    return settings.insertOnConflictUpdate(SettingsCompanion.insert(key: key, value: value));
  }

  Stream<Setting?> watchSetting(String key) {
     return (select(settings)..where((s) => s.key.equals(key))).watch().map((rows){
       for (var s in rows) {
         if (s.key == key) {
           return s;
         }
       }
       return null;
     });
   }

  Future<Setting> readSettings(String key) {
    return (select(settings)..where((s) => s.key.equals(key))).getSingle();
  }

  Future<List<Setting>> readAllSettings() {
    return select(settings).get();
  }
}