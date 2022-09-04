import 'package:drift/drift.dart';
import './db.dart';
part 'utxos_dao.g.dart';

@DriftAccessor(tables: [Utxos])
class UtxosDao extends DatabaseAccessor<AppDatabase> with _$UtxosDaoMixin {  
  UtxosDao(AppDatabase db) : super(db);

  Future updateUtxos(List<Utxo> updatedUtxos) async {
    await (delete(utxos)..where((t) => t.txid.isIn(updatedUtxos.map((e) => e.txid)))).go();
    await batch((batch) {
      batch.insertAll(utxos, updatedUtxos, mode: InsertMode.insertOrIgnore);
    });    
  }

  Future<List<Utxo>> listUtxos() {
    return select(utxos).get();
  }
}
