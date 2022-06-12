import 'package:c_breez/repositories/dao/db.dart';

abstract class AppStorage {
  // lightning
  
  Future setNodeState(NodeState nodeSate);
  Stream<NodeState?> watchNodeState();

  addOutgoingPayments(List<OutgoingLightningPayment> payments);
  Stream<List<OutgoingLightningPayment>> watchOutgoingPayments();
  Future<List<OutgoingLightningPayment>> listOutgoingPayments();

  Future addIncomingPayments(List<Invoice> settledInvoices);
  Stream<List<Invoice>> watchIncomingPayments();
  Future<List<Invoice>> listIncomingPayments();

  Future setPeers(List<PeerWithChannels> peers);
  Stream<List<PeerWithChannels>> watchPeers();
  
  // settings
  Future<int> updateSettings(String key, String value);
  Future<Setting> readSettings(String key);
  Stream<Setting?> watchSetting(String key);
  Future<List<Setting>> readAllSettings();
}
