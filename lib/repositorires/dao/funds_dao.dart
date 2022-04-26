import 'package:drift/drift.dart';
import './db.dart';
part 'funds_dao.g.dart';

// the _TodosDaoMixin will be created by drift. It contains all the necessary
// fields for the tables. The <MyDatabase> type annotation is the database class
// that should use this dao.
@DriftAccessor(tables: [OffChainFunds, OnChainFunds])
class FundsDao extends DatabaseAccessor<AppDatabase> with _$FundsDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  FundsDao(AppDatabase db) : super(db);

  Future setOffchainFunds(List<OffChainFund> offchainFundsEntries) async {
    return transaction(() async {
      await offChainFunds.deleteWhere((c) => Constant(true));
      await batch((batch) {
        return batch.insertAll(offChainFunds, offchainFundsEntries);
      });
    });
  }

  Stream<List<OffChainFund>> watchOffchainFunds() {
    return select(offChainFunds).watch();
  }

  Future setOnchainFunds(List<OnChainFund> onchainFundsEntries) async {
    return transaction(() async {
      await onChainFunds.deleteWhere((c) => Constant(true));
      await batch((batch) {
        return batch.insertAll(onChainFunds, onchainFundsEntries);
      });
    });
  }

  Stream<List<OnChainFund>> watchOnchainFunds() {
    return select(onChainFunds).watch();
  }
}
