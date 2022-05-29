import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:c_breez/services/lightning/greenlight/incoming_requests.dart';
import 'package:greenlight/scheduler_credentials.dart';
import 'package:c_breez/services/lightning/models.dart';
import 'package:greenlight/generated/greenlight.pbgrpc.dart' as greenlight;
import 'package:greenlight/generated/scheduler.pbgrpc.dart' as scheduler;
import 'package:c_breez/services/lightning/interface.dart';
import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';
import 'package:hex/hex.dart';
import 'package:c_breez/logger.dart';
import 'package:lightning_toolkit/impl.dart';
import 'package:lightning_toolkit/signer.dart';

class GreenlightService implements LightningService {
  final String _signerStoragePath;
  NodeCredentials? _nodeCredentials;
  greenlight.NodeClient? _nodeClient;
  //scheduler.SchedulerClient? _schedulerClient;
  Signer? _signer;

  final _incomingPaymentsStream = StreamController<IncomingLightningPayment>.broadcast();
  final Completer _readyCompleter = Completer();

  GreenlightService(this._signerStoragePath);

  @override
  Signer initWithCredentials(List<int> credentials) {
    _nodeCredentials = NodeCredentials.fromBuffer(credentials);    
    _signer = Signer(Uint8List.fromList(_nodeCredentials!.secret!), _signerStoragePath);
    return _signer!;
  }

  @override
  Future<List<FileData>> exportKeys() {
    return Future.value([
      FileData("ca.pem", _nodeCredentials!.caCert.codeUnits),
      FileData("device.crt", _nodeCredentials!.deviceCert.codeUnits),
      FileData("device-key.pem", _nodeCredentials!.deviceKey.codeUnits),
      FileData("hsm_secret", _nodeCredentials!.secret!),
    ]);
  }

  scheduler.SchedulerClient _createSchedulerClient() {
    final NodeCredentials schedulerCredentials = NodeCredentials(caCert, nobodyCert, nobodyKey, null, null);
    var grpcChannel = _createNodeChannel(schedulerCredentials, "https://scheduler.gl.blckstrm.com:2601");
    return scheduler.SchedulerClient(grpcChannel);
  }

  @override
  Future startNode() async {    
    var res = await schedule();
    _readyCompleter.complete(true);
    log.info("node started! ${HEX.encode(res.nodeId)}");

    streamIncomingRequests(res.nodeId);
  }

  Future streamIncomingRequests(List<int> nodeID) async {
    while (true) {      
      log.info("streaming signer requests");
      var schedulerClient = _createSchedulerClient();
      var nodeInfo = await schedulerClient.getNodeInfo(scheduler.NodeInfoRequest()
        ..nodeId = nodeID
        ..wait = true);
      var nodeChannel = _createNodeChannel(_nodeCredentials!, nodeInfo.grpcUri);
      _nodeClient = greenlight.NodeClient(nodeChannel);

      try {
        _nodeClient!.streamLog(greenlight.StreamLogRequest()).listen((value) {
          log.info(value.line);
        });
        // stream incoming payments
        IncomingPaymentsLoop(_nodeClient!, _incomingPaymentsStream.sink).start();

        // stream signer and wait for it to shut down.
        await SignerLoop(_signer!, _nodeClient!).start();
      } catch (e) {
        log.severe("signer exited, waiting 5 seconds...: ${e.toString()}");
      }      
      await Future.delayed(const Duration(seconds: 5));      
    }
  }

  Future<scheduler.NodeInfoResponse> schedule() async {    
    var schedulerClient = _createSchedulerClient();
    var res = await schedulerClient.schedule(scheduler.ScheduleRequest(nodeId: _nodeCredentials!.nodeId));
    var nodeChannel = _createNodeChannel(_nodeCredentials!, res.grpcUri);
    _nodeClient = greenlight.NodeClient(nodeChannel);
    return res;
  }

  @override
  Future waitReady() {
    return _readyCompleter.future;
  }

  @override
  Stream<IncomingLightningPayment> incomingPaymentsStream() {
    return _incomingPaymentsStream.stream;
  }

  @override
  Future<List<int>> recover(Uint8List seed) async {
    final signer = Signer(seed, _signerStoragePath);
    final init = await signer.init();
    final nodePubkey = await signer.getNodePubkey();
    var schedulerClient = _createSchedulerClient();
    var challengeResponse = await schedulerClient.getChallenge(scheduler.ChallengeRequest(nodeId: nodePubkey, scope: scheduler.ChallengeScope.RECOVER));
    var sig = await signer.signMessage(message: Uint8List.fromList(challengeResponse.challenge));
    var recoverResponse = await schedulerClient.recover(scheduler.RecoveryRequest(challenge: challengeResponse.challenge, nodeId: nodePubkey, signature: sig));
    _nodeCredentials =
        NodeCredentials(caCert, recoverResponse.deviceCert, recoverResponse.deviceKey, nodePubkey, seed);
    var creds = _nodeCredentials!.writeBuffer();
    initWithCredentials(creds);
    return creds;
  }

  @override
  Future<List<int>> register(Uint8List seed, {String network = "bitcoin", String? email}) async {
    final signer = Signer(seed, _signerStoragePath);
    final init = await signer.init();
    final nodePubkey = await signer.getNodePubkey();

    var schedulerClient = _createSchedulerClient();
    var challengeResponse = await schedulerClient.getChallenge(scheduler.ChallengeRequest(nodeId: nodePubkey, scope: scheduler.ChallengeScope.REGISTER));    
    var sig = await signer.signMessage(message: Uint8List.fromList(challengeResponse.challenge));    

    var registration = await schedulerClient.register(scheduler.RegistrationRequest(
        network: network,
        nodeId: nodePubkey,
        initMsg: init,
        signature: sig,
        signerProto: "v0.11.0.1",
        challenge: challengeResponse.challenge));
    _nodeCredentials =
        NodeCredentials(caCert, registration.deviceCert, registration.deviceKey, nodePubkey, seed);
    var creds = _nodeCredentials!.writeBuffer();
    initWithCredentials(creds);
    return creds;
  }

  @override
  Signer getSigner() {
    return _signer!;
  }

  @override
  Future<Invoice> addInvoice(Int64 amount,
      {String? payeeName,
      String? payeeImageURL,
      String? payerName,
      String? payerImageURL,
      String? description,
      Int64? expiry}) async {
    await schedule();
    var invoice = await _nodeClient!.createInvoice(greenlight.InvoiceRequest(
        label: "breez-${DateTime.now().millisecondsSinceEpoch}",
        amount: greenlight.Amount(satoshi: amount),
        description: description));
    return Invoice(
        label: invoice.label,
        amountMsats: amountToMSats(invoice.amount),
        description: invoice.description,
        receivedMsats: amountToMSats(invoice.received),
        status: _convertInvoiceStatus(invoice.status),
        paymentTime: invoice.paymentTime,
        expiryTime: invoice.expiryTime,
        bolt11: invoice.bolt11,
        paymentHash: HEX.encode(invoice.paymentHash),
        paymentPreimage: HEX.encode(invoice.paymentPreimage));
  }

  @override
  Future<NodeInfo> getNodeInfo() async {
    await schedule();
    var info = await _nodeClient!.getInfo(greenlight.GetInfoRequest());
    return NodeInfo(
        nodeID: HEX.encode(info.nodeId),
        nodeAlias: info.alias,
        numPeers: info.numPeers,
        addresses: info.addresses.map((a) => _convertAddress(a)).toList(),
        version: info.version,
        blockheight: info.blockheight,
        network: info.network);
  }

  @override
  Future<ListFunds> listFunds() async {
    await schedule();
    var listFunds = await _nodeClient!.listFunds(greenlight.ListFundsRequest());

    var channelFunds = listFunds.channels.map((e) {
      return ListFundsChannel(
          peerId: HEX.encode(e.peerId),
          connected: e.connected,
          shortChannelId: e.shortChannelId,
          ourAmountMsat: e.ourAmountMsat,
          amountMsat: e.amountMsat,
          fundingTxid: HEX.encode(e.fundingTxid),
          fundingOutput: e.fundingOutput);
    }).toList();

    var onchainFunds = listFunds.outputs.map((e) {
      return ListFundsOutput(
          amountMsats: amountToMSats(e.amount),
          address: e.address,
          status: e.status.value as OutputStatus,
          outpoint: Outpoint(HEX.encode(e.output.txid), e.output.outnum));
    }).toList();

    return ListFunds(channelFunds: channelFunds, onchainFunds: onchainFunds);
  }

  @override
  Future<List<Peer>> listPeers() async {
    await schedule();
    var peers = await _nodeClient!.listPeers(greenlight.ListPeersRequest());
    return peers.peers.map((e) {
      return Peer(
          id: HEX.encode(e.id),
          connected: e.connected,
          features: e.features,
          addresses: e.addresses.map((e) => _convertAddress(e)).toList(),
          channels: e.channels.map((e) => _convertChannel(e)).toList());
    }).toList();
  }

  @override
  Future connectPeer(String nodeID, String address) async {
    await schedule();
    await _nodeClient!.connectPeer(greenlight.ConnectRequest(nodeId: nodeID, addr: address));
  }

  @override
  Future<Int64> getDefaultOnChainFeeRate() {
    return Future.value(Int64.ZERO);
  }

  @override
  Future<List<OutgoingLightningPayment>> getPayments() async {
    await schedule();
    var payments = await _nodeClient!.listPayments(greenlight.ListPaymentsRequest());
    var paymentsList = payments.payments.map((p) {
      var sentMsats = amountToMSats(p.amountSent);
      var requestedMsats = amountToMSats(p.amount);

      return OutgoingLightningPayment(
          creationTimestamp: p.createdAt.toInt(),
          amountMsats: requestedMsats,
          amountSentMsats: sentMsats,
          paymentHash: HEX.encode(p.paymentHash),
          destination: HEX.encode(p.destination),
          feeMsats: sentMsats - requestedMsats,
          preimage: HEX.encode(p.paymentPreimage),
          isKeySend: p.bolt11.isNotEmpty == true,
          pending: p.status == greenlight.PayStatus.PENDING,
          bolt11: p.bolt11);
    }).toList();

    return paymentsList;
  }

  @override
  Future<List<Invoice>> getInvoices() async {
    await schedule();
    var invoices = await _nodeClient!.listInvoices(greenlight.ListInvoicesRequest());
    return invoices.invoices.map((p) {
      return Invoice(
          label: p.label,
          amountMsats: amountToMSats(p.amount),
          receivedMsats: amountToMSats(p.received),
          description: p.description,
          status: _convertInvoiceStatus(p.status),
          paymentTime: p.paymentTime,
          expiryTime: p.expiryTime,
          bolt11: p.bolt11,
          paymentPreimage: HEX.encode(p.paymentPreimage),
          paymentHash: HEX.encode(p.paymentHash));
    }).toList();
  }

  @override
  Future<String> newAddress(String breezID) {
    // TODO: implement newAddress
    throw UnimplementedError();
  }

  @override
  Future newNode() {
    // TODO: implement newNode
    throw UnimplementedError();
  }

  @override
  Future publishTransaction(List<int> tx) {
    // TODO: implement publishTransaction
    throw UnimplementedError();
  }

  @override
  Future sendPaymentForRequest(String blankInvoicePaymentRequest, {Int64? amount}) async {
    await schedule();
    await _nodeClient!.pay(greenlight.PayRequest(bolt11: blankInvoicePaymentRequest, amount: greenlight.Amount(satoshi: amount), timeout: 60));    
  }

  @override
  Future<OutgoingLightningPayment> sendSpontaneousPayment(String destNode, Int64 amount, String description,
      {Int64 feeLimitMsat = Int64.ZERO, Map<Int64, String> tlv = const {}}) {
    // TODO: implement sendSpontaneousPayment
    throw UnimplementedError();
  }

  @override
  Future<Withdrawal> sweepAllCoinsTransactions(String address) {
    // TODO: implement sweepAllCoinsTransactions
    throw UnimplementedError();
  }

  ClientChannel _createNodeChannel(NodeCredentials credentials, String grpcUri) {
    var uri = Uri.parse(grpcUri);
    return ClientChannel(uri.host,
        port: uri.port,
        options: ChannelOptions(
            connectionTimeout: const Duration(seconds: 90),
            credentials: ClientCertificateChannelCredentials(
                trustedRoots: Uint8List.fromList(utf8.encode(caCert)),
                certificateChain: Uint8List.fromList(utf8.encode(credentials.deviceCert)),
                privateKey: Uint8List.fromList(utf8.encode(credentials.deviceKey)),
                authority: 'localhost',
                onBadCertificate: allowBadCertificates)));
  }
}

Int64 amountToMSats(greenlight.Amount amount) {
  var sats = Int64(0);
  if (amount.hasSatoshi()) {
    sats = amount.satoshi * 1000;
  } else if (amount.hasBitcoin()) {
    sats = amount.bitcoin * 100000000000;
  } else {
    sats = amount.millisatoshi;
  }
  return sats;
}

Int64 _amountStringToMsat(String amount) {
  if (amount.endsWith("msat")) {
    return Int64.parseInt(amount.replaceAll("msat", ""));
  }
  if (amount.endsWith("sat")) {
    return Int64.parseInt(amount.replaceAll("sat", "")) * 1000;
  }
  if (amount.isEmpty) {
    return Int64.ZERO;
  }

  throw Exception("unknown amount $amount");
}

InvoiceStatus _convertInvoiceStatus(greenlight.InvoiceStatus s) {
  switch (s) {
    case greenlight.InvoiceStatus.EXPIRED:
      return InvoiceStatus.EXPIRED;
    case greenlight.InvoiceStatus.PAID:
      return InvoiceStatus.PAID;
    default:
      return InvoiceStatus.UNPAID;
  }
}

Address _convertAddress(greenlight.Address a) {
  return Address(a.type.value as NetAddressType, a.addr, a.port);
}

Channel _convertChannel(greenlight.Channel c) {
  ChannelState chanState = ChannelState.CLOSED;
  if (c.state == "CHANNELD_NORMAL") {
    chanState = ChannelState.OPEN;
  }
  if (["CHANNELD_AWAITING_LOCKIN", "DUALOPEND_OPEN_INIT", "DUALOPEND_AWAITING_LOCKIN"].contains(c.state)) {
    chanState = ChannelState.PENDING_OPEN;
  }

  return Channel(
      state: chanState,
      channelId: c.channelId,
      direction: c.direction,
      shortChannelId: c.shortChannelId,
      fundingTxid: c.fundingTxid,
      closeToAddr: c.closeToAddr,
      closeTo: c.closeTo,
      private: c.private,
      total: _amountStringToMsat(c.total).toInt(),
      dustLimit: _amountStringToMsat(c.dustLimit).toInt(),
      spendable: _amountStringToMsat(c.spendable).toInt(),
      receivable: _amountStringToMsat(c.receivable).toInt(),
      theirToSelfDelay: c.theirToSelfDelay,
      ourToSelfDelay: c.ourToSelfDelay,
      htlcs: c.htlcs
          .map((h) => Htlc(
              direction: h.direction,
              id: h.id,
              amountMsat: _amountStringToMsat(h.amount),
              expiry: h.expiry.toInt(),
              paymentHash: h.paymentHash,
              state: h.state,
              localTrimmed: h.localTrimmed))
          .toList());
}

class ClientCertificateChannelCredentials extends ChannelCredentials {
  final Uint8List certificateChain;
  final Uint8List privateKey;

  ClientCertificateChannelCredentials({
    required Uint8List trustedRoots,
    required this.certificateChain,
    required this.privateKey,
    required String authority,
    required BadCertificateHandler onBadCertificate,
  }) : super.secure(certificates: trustedRoots, authority: authority, onBadCertificate: onBadCertificate);

  @override
  SecurityContext get securityContext {
    final ctx = super.securityContext;
    ctx!.useCertificateChainBytes(certificateChain);
    ctx.usePrivateKeyBytes(privateKey);
    return ctx;
  }
}
