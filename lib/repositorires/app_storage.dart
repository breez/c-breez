import 'package:c_breez/repositorires/dao/db.dart';

abstract class AppStorage {
  // lightning
  Future setNodeInfo(NodeInfo nodeInfo);
  Stream<NodeInfo?> watchNodeInfo();

  addOutgoingPayments(List<OutgoingLightningPayment> payments);
  Stream<List<OutgoingLightningPayment>> watchOutgoingPayments();
  Future<List<OutgoingLightningPayment>> listOutgoingPayments();

  Future addIncomingPayments(List<Invoice> settledInvoices);
  Stream<List<Invoice>> watchIncomingPayments();
  Future<List<Invoice>> listIncomingPayments();

  Future setPeers(List<PeerWithChannels> peers);
  Stream<List<PeerWithChannels>> watchPeers();

  Future setOffchainFunds(List<OffChainFund> offchainFundsEntries);
  Stream<List<OffChainFund>> watchOffchainFunds();

  Future setOnchainFunds(List<OnChainFund> onchainFundsEntries);
  Stream<List<OnChainFund>> watchOnchainFunds();

  // settings
  Future<int> updateSettings(String key, String value);
  Future<Setting> readSettings(String key);
  Stream<Setting?> watchSetting(String key);
  Future<List<Setting>> readAllSettings();
}
