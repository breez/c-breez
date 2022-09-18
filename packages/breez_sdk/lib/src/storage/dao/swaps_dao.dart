
import 'package:drift/drift.dart';
import './db.dart';
part 'swaps_dao.g.dart';

@DriftAccessor(tables: [Swaps])
class SwapsDao extends DatabaseAccessor<AppDatabase> with _$SwapsDaoMixin {
  SwapsDao(AppDatabase db) : super(db);

  Value<T> _valueOrAbsent<T>(T? t) {
    return t == null ? const Value.absent() : Value(t);
  }

  Future<Swap> updateSwap(String bitcoinAddress, {String? payreq, int? confirmedSats, int? paidSats, String? error}) async {
    await transaction(() async {
      await (swaps.update()..where((tbl) => tbl.bitcoinAddress.equals(bitcoinAddress))).write(SwapsCompanion(
        paymentRequest: _valueOrAbsent<String>(payreq),
        confirmedSats: _valueOrAbsent(confirmedSats),
        paidSats: _valueOrAbsent(paidSats),
        errorMessage: _valueOrAbsent(error),
      ));
    });
    return await (select(swaps)..where((tbl) => tbl.bitcoinAddress.equals(bitcoinAddress))).getSingle();
  }

  Future<List<Swap>> listSwaps() {
    return select(swaps).get();
  }

  Future addSwap(Swap s) {
    return swaps.insertOne(s);    
  }
}
