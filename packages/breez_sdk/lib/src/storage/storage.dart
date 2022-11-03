import 'package:breez_sdk/src/chain_service/chain_service_mempool_space_settings.dart';
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
  Future<NodeState?> getNodeState();
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

  Future<List<Utxo>> listUtxos();
  Future updateUtxos(List<Utxo> updatedUtxos);

  Future addSwap(Swap s);
  Future<Swap> updateSwap(String bitcoinAddress, {String? payreq, int? confirmedSats, int? paidSats, String? error});
  Future<List<Swap>> listSwaps();

  Future<ChainServiceMempoolSpaceSettings> getMempoolSpaceSettings();
  Future<int> setMempoolSpaceSettings(String scheme, String host, String? port);
  Future<void> resetMempoolSpaceSettings();
}
