import 'package:drift/drift.dart';
import './db.dart';
part 'payments_dao.g.dart';

@DriftAccessor(tables: [OutgoingLightningPayments, Invoices])
class PaymentsDao extends DatabaseAccessor<AppDatabase> with _$PaymentsDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  PaymentsDao(AppDatabase db) : super(db);

  Future addIncomingPayments(List<Invoice> settledInvoices) async {
    var query = select(invoices)
      ..orderBy([(p) => OrderingTerm(expression: p.paymentTime)])
      ..limit(1);
    var lastInvoice = await query.getSingleOrNull();
    var lastDate = lastInvoice?.paymentTime ?? 0;
    var res = await batch((batch) => batch.insertAll(invoices, settledInvoices.where((i) => i.paymentTime > lastDate).toList()));
    return res;
  }

  Stream<List<Invoice>> watchIncomingPayments() {
    return (select(invoices)
          ..where((invoice) => invoice.receivedMsat.isBiggerThan(Constant(0)))
          ..orderBy([(p) => OrderingTerm(expression: p.paymentTime)]))
        .watch();
  }

  addOutgoingPayments(List<OutgoingLightningPayment> payments) async {
    var query = select(outgoingLightningPayments)
      ..orderBy([(p) => OrderingTerm(expression: p.createdAt)])
      ..limit(1);
    var lastPayment = await query.getSingleOrNull();
    var lastPaymentDate = lastPayment?.createdAt?? 0;
    return batch((batch) => batch.insertAll(outgoingLightningPayments, payments.where((i) => i.createdAt > lastPaymentDate)));
  }

  Stream<List<OutgoingLightningPayment>> watchOutgoingPayments() {
    return (select(outgoingLightningPayments)..orderBy([(p) => OrderingTerm(expression: p.createdAt)])).watch();
  }
}
