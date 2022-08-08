import 'package:breez_sdk/src/storage/dao/db.dart';
import 'package:drift/native.dart';

abstract class Storage {

  static Storage createDefault() {
    return AppDatabase();
  }

  static Storage createInMemory() {
    return AppDatabase(executor: NativeDatabase.memory(logStatements: true));
  }

  // lightning
  
  Future setNodeState(NodeState nodeSate);
  Stream<NodeState?> watchNodeState();

  addOutgoingPayments(List<OutgoingLightningPayment> payments);
  Stream<List<OutgoingLightningPayment>> watchOutgoingPayments();
  Future<List<OutgoingLightningPayment>> listOutgoingPayments();

  Future addIncomingPayments(List<Invoice> settledInvoices);
  Stream<List<Invoice>> watchIncomingPayments();
  Future<List<Invoice>> listIncomingPayments();

  // settings
  Future<int> updateSettings(String key, String value);
  Future<Setting?> readSettings(String key);
  Stream<Setting?> watchSetting(String key);
  Future<List<Setting>> readAllSettings();
}
