import 'package:drift/drift.dart';
import './db.dart';
part 'swaps_dao.g.dart';

@DriftAccessor(tables: [Swaps])
class SwapsDao extends DatabaseAccessor<AppDatabase> with _$SwapsDaoMixin {
  SwapsDao(AppDatabase db) : super(db);

  Future<Swap> updateSwap(String bitcoinAddress, {String? payreq, int? confirmedSats, int? paidSats, String? error}) async {
    await transaction(() async {
      await (swaps.update()..where((tbl) => tbl.bitcoinAddress.equals(bitcoinAddress))).write(SwapsCompanion(
        paymentRequest: Value.ofNullable(payreq),
        confirmedSats: Value.ofNullable(confirmedSats),
        paidSats: Value.ofNullable(paidSats),
        errorMessage: Value.ofNullable(error),
      ));        
    });
    return await (select(swaps)..where((tbl) => tbl.bitcoinAddress.equals(bitcoinAddress))).getSingle();
  }

  Future<List<Swap>> listSwaps() {
    return select(swaps).get();
  }
}
