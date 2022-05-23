//import 'package:c_breez/models/currency.dart';
import 'dart:typed_data';

import 'package:c_breez/services/lightning/models.dart';
import 'package:fixnum/fixnum.dart';
import 'package:lightning_toolkit/signer.dart';

abstract class LightningService {
  Future<List<int>> register(Uint8List seed,
      {String network = "bitcoin", String email});

  Future<List<int>> recover(Uint8List seed);
  
  Signer initWithCredentials(List<int> credentials);

  Signer getSigner();

  Future<List<FileData>> exportKeys();

  Future startNode();

  Future waitReady();

  Stream<IncomingLightningPayment> incomingPaymentsStream();

  Future<Withdrawal> sweepAllCoinsTransactions(String address);

  Future publishTransaction(List<int> tx);

  Future<NodeInfo> getNodeInfo();

  Future<ListFunds> listFunds();

  Future<List<Peer>> listPeers();

  Future connectPeer(String nodeID, String address);

  Future<OutgoingLightningPayment> sendSpontaneousPayment(
      String destNode, Int64 amount, String description,
      {Int64 feeLimitMsat = Int64.ZERO, Map<Int64, String> tlv});

  Future sendPaymentForRequest(
      String blankInvoicePaymentRequest,
      {Int64 amount});

  Future<List<OutgoingLightningPayment>> getPayments();

  Future<List<Invoice>> getInvoices();

  Future<Invoice> addInvoice(Int64 amount, {String description, Int64 expiry});

  Future<String> newAddress(String breezID);

  Future<Int64> getDefaultOnChainFeeRate();
}
