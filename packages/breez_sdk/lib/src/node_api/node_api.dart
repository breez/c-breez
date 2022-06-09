import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import '../../src/signer.dart';

import 'models.dart';

abstract class NodeAPI {  
  Future<List<int>> register(Uint8List seed, Signer signer,
      {String network = "bitcoin", String email});

  Future<List<int>> recover(Uint8List seed, Signer signer);
  
  void initWithCredentials(List<int> credentials, Signer signer);  

  Future<List<FileData>> exportKeys();

  Stream<IncomingLightningPayment> incomingPaymentsStream();

  Future<Withdrawal> sweepAllCoinsTransactions(String address);

  Future<NodeInfo> getNodeInfo();

  Future<ListFunds> listFunds();

  Future<List<Peer>> listPeers();

  Future connectPeer(String nodeID, String address);

  Future<OutgoingLightningPayment> sendSpontaneousPayment(
      String destNode, Int64 amount, String description,
      {Int64 feeLimitMsat = Int64.ZERO, Map<Int64, String> tlv});

  Future sendPaymentForRequest(
      String blankInvoicePaymentRequest,
      {Int64? amount});

  Future<List<OutgoingLightningPayment>> getPayments();

  Future<List<Invoice>> getInvoices();

  Future<Invoice> addInvoice(Int64 amount, {String? description, Int64? expiry});

  Future<Int64> getDefaultOnChainFeeRate();

  Future publishTransaction(List<int> tx);
}
