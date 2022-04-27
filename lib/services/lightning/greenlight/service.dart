import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:greenlight/hsmd.dart';
import 'package:greenlight/scheduler_credentials.dart';
import 'package:greenlight/signer.dart';
import 'package:c_breez/services/lightning/models.dart';
import 'package:greenlight/generated/greenlight.pbgrpc.dart' as greenlight;
import 'package:greenlight/generated/scheduler.pbgrpc.dart' as scheduler;
import 'package:c_breez/services/lightning/interface.dart';
import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';
import 'package:hex/hex.dart';
import 'package:c_breez/logger.dart';

class GreenlightService implements LightningService {
  NodeCredentials? _nodeCredentials;
  greenlight.NodeClient? _nodeClient;
  scheduler.SchedulerClient? _schedulerClient;
  final Completer _readyCompleter = Completer();

  GreenlightService() {
    final NodeCredentials schedulerCredentials =
        NodeCredentials(caCert, nobodyCert, nobodyKey, null, null, null);
    var grpcChannel = _createNodeChannel(
        schedulerCredentials, "https://scheduler.gl.blckstrm.com:2601");
    _schedulerClient = scheduler.SchedulerClient(grpcChannel);
  }

  @override
  Future initWithCredentials(List<int> credentials) async {
    _nodeCredentials = NodeCredentials.fromBuffer(credentials);
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

  @override
  Future startNode() async {
    var res = await _schedulerClient!
        .schedule(scheduler.ScheduleRequest(nodeId: _nodeCredentials!.nodeId));
    var nodeChannel = _createNodeChannel(_nodeCredentials!, res.grpcUri);
    _nodeClient = greenlight.NodeClient(nodeChannel,
        interceptors: [NodeInterceptor(_nodeCredentials!.deviceKey)]);
    _readyCompleter.complete(true);
    log.info("node started! " + HEX.encode(res.nodeId));
    _nodeClient!.streamLog(greenlight.StreamLogRequest()).listen((value) {
      log.info(value.line);
    });

    // _nodeClient!.streamHsmRequests(greenlight.Empty()).listen((value) {
    //   print("hsmd: ${value.context.dbid}");
    // });
  }

  @override
  Future waitReady() {
    return _readyCompleter.future;
  }

  @override
  Stream<IncomingLightningPayment> incomingPaymentsStream() {
    return _nodeClient!.streamIncoming(greenlight.StreamIncomingFilter()).map(
        (p) => IncomingLightningPayment(
            label: p.offchain.label,
            preimage: HEX.encode(p.offchain.preimage),
            amountSat: amountToSats(p.offchain.amount),
            paymentHash: HEX.encode(p.offchain.paymentHash),
            bolt11: p.offchain.bolt11,
            extratlvs: p.offchain.extratlvs
                .map((t) =>
                    TlvField(type: t.type.toInt(), value: HEX.encode(t.value)))
                .toList()));
  }

  @override
  Future<List<int>> recover(Uint8List seed) async {
    var hsmdCreds = await hsmdInit(seed);
    var challengeResponse = await _schedulerClient!.getChallenge(
        scheduler.ChallengeRequest(
            nodeId: hsmdCreds.nodeId, scope: scheduler.ChallengeScope.RECOVER));
    var sig = await _signChallenge(hsmdCreds.nodePrivateKey,
        challengeResponse.challenge, scheduler.ChallengeScope.REGISTER);
    var recoverResponse = await _schedulerClient!.recover(
        scheduler.RecoveryRequest(
            challenge: challengeResponse.challenge,
            nodeId: hsmdCreds.nodeId,
            signature: sig));
    _nodeCredentials = NodeCredentials(
        caCert,
        recoverResponse.deviceCert,
        recoverResponse.deviceKey,
        hsmdCreds.nodeId,
        hsmdCreds.nodePrivateKey,
        hsmdCreds.secret);
    var creds = _nodeCredentials!.writeBuffer();
    await initWithCredentials(creds);
    return creds;
  }

  @override
  Future<List<int>> register(Uint8List seed,
      {String network = "bitcoin", String? email}) async {
    var hsmdCreds = await hsmdInit(seed);
    var challengeResponse = await _schedulerClient!.getChallenge(
        scheduler.ChallengeRequest(
            nodeId: hsmdCreds.nodeId,
            scope: scheduler.ChallengeScope.REGISTER));
    var sig = await _signChallenge(hsmdCreds.nodePrivateKey,
        challengeResponse.challenge, scheduler.ChallengeScope.REGISTER);
    var registration = await _schedulerClient!.register(
        scheduler.RegistrationRequest(
            network: network,
            nodeId: hsmdCreds.nodeId,
            initMsg: hsmdCreds.init,
            signature: sig,
            signerProto: "v0.10.1",
            challenge: challengeResponse.challenge));
    _nodeCredentials = NodeCredentials(
        caCert,
        registration.deviceCert,
        registration.deviceKey,
        hsmdCreds.nodeId,
        hsmdCreds.nodePrivateKey,
        hsmdCreds.secret);
    var creds = _nodeCredentials!.writeBuffer();
    await initWithCredentials(creds);
    return creds;
  }

  Future<List<int>> _signChallenge(List<int> privateKey, List<int> challenge,
      scheduler.ChallengeScope scope) async {
    var s = "Lightning Signed Message:";
    var chal = List<int>.empty(growable: true)
      ..addAll(s.codeUnits)
      ..addAll(challenge);

    return eccSign(Uint8List.fromList(privateKey), doubleHash(chal));
  }

  @override
  Future<Invoice> addInvoice(Int64 amount,
      {String? payeeName,
      String? payeeImageURL,
      String? payerName,
      String? payerImageURL,
      String? description,
      Int64? expiry}) async {
    var invoice = await _nodeClient!.createInvoice(greenlight.InvoiceRequest(
        amount: greenlight.Amount(satoshi: amount), description: description));
    return Invoice(
        label: invoice.label,
        amountSats: amountToSats(invoice.amount),
        description: invoice.description,
        received: amountToSats(invoice.received),
        status: _convertInvoiceStatus(invoice.status),
        paymentTime: invoice.paymentTime,
        expiryTime: invoice.expiryTime,
        bolt11: invoice.bolt11,
        paymentHash: HEX.encode(invoice.paymentHash),
        paymentPreimage: HEX.encode(invoice.paymentPreimage));
  }

  @override
  Future<NodeInfo> getNodeInfo() async {
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
          amount: amountToSats(e.amount),
          address: e.address,
          status: e.status.value as OutputStatus,
          outpoint: Outpoint(HEX.encode(e.output.txid), e.output.outnum));
    }).toList();

    return ListFunds(channelFunds: channelFunds, onchainFunds: onchainFunds);
  }

  @override
  Future<List<Peer>> listPeers() async {
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
    await _nodeClient!
        .connectPeer(greenlight.ConnectRequest(nodeId: nodeID, addr: address));
  }

  @override
  Future<Int64> getDefaultOnChainFeeRate() {
    return Future.value(Int64.ZERO);
  }

  @override
  Future<List<OutgoingLightningPayment>> getPayments() async {
    var payments =
        await _nodeClient!.listPayments(greenlight.ListPaymentsRequest());
    var paymentsList = payments.payments.map((p) {
      var sentSats = amountToSats(p.amountSent);
      var requestedSats = amountToSats(p.amount);

      return OutgoingLightningPayment(
          creationTimestamp: p.createdAt.toInt(),
          amount: requestedSats,
          amountSent: sentSats,
          paymentHash: HEX.encode(p.paymentHash),
          destination: HEX.encode(p.destination),
          fee: sentSats - requestedSats,
          preimage: HEX.encode(p.paymentPreimage),
          isKeySend: p.bolt11.isNotEmpty == true,
          pending: p.status == greenlight.PayStatus.PENDING,
          bolt11: p.bolt11);
    }).toList();

    return paymentsList;
  }

  @override
  Future<List<Invoice>> getInvoices() async {
    var invoices =
        await _nodeClient!.listInvoices(greenlight.ListInvoicesRequest());
    return invoices.invoices.map((p) {
      return Invoice(
          label: p.label,
          amountSats: amountToSats(p.amount),
          received: amountToSats(p.received),
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
  Future<OutgoingLightningPayment> sendPaymentForRequest(
      String blankInvoicePaymentRequest,
      {Int64? amount}) {
    // TODO: implement sendPaymentForRequest
    throw UnimplementedError();
  }

  @override
  Future<OutgoingLightningPayment> sendSpontaneousPayment(
      String destNode, Int64 amount, String description,
      {Int64 feeLimitMsat = Int64.ZERO, Map<Int64, String> tlv = const {}}) {
    // TODO: implement sendSpontaneousPayment
    throw UnimplementedError();
  }

  @override
  Future<Withdrawal> sweepAllCoinsTransactions(String address) {
    // TODO: implement sweepAllCoinsTransactions
    throw UnimplementedError();
  }

  ClientChannel _createNodeChannel(
      NodeCredentials credentials, String grpcUri) {
    var uri = Uri.parse(grpcUri);
    return ClientChannel(uri.host,
        port: uri.port,
        options: ChannelOptions(
            connectionTimeout: const Duration(seconds: 90),
            credentials: ClientCertificateChannelCredentials(
                trustedRoots: Uint8List.fromList(utf8.encode(caCert)),
                certificateChain:
                    Uint8List.fromList(utf8.encode(credentials.deviceCert)),
                privateKey:
                    Uint8List.fromList(utf8.encode(credentials.deviceKey)),
                authority: 'localhost',
                onBadCertificate: allowBadCertificates)));
  }
}

Int64 amountToSats(greenlight.Amount amount) {
  var sats = Int64(0);
  if (amount.hasSatoshi()) {
    sats = amount.satoshi;
  } else if (amount.hasBitcoin()) {
    sats = amount.bitcoin * 100000000;
  } else {
    sats = amount.bitcoin ~/ 1000;
  }
  return sats;
}

Int64 _amountStringtoMsats(String amountStr) {
  return Int64.parseInt(amountStr);
}

InvoiceStatus _convertInvoiceStatus(greenlight.InvoiceStatus s) {
  switch (s) {
    case greenlight.InvoiceStatus.EXPIRED:
      return InvoiceStatus.EXPIRED;
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
  if ([
    "CHANNELD_AWAITING_LOCKIN",
    "DUALOPEND_OPEN_INIT",
    "DUALOPEND_AWAITING_LOCKIN"
  ].contains(c.state)) {
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
      total: c.total,
      dustLimit: c.dustLimit,
      spendable: c.spendable,
      receivable: c.receivable,
      theirToSelfDelay: c.theirToSelfDelay,
      ourToSelfDelay: c.ourToSelfDelay,
      htlcs: c.htlcs
          .map((h) => Htlc(
              direction: h.direction,
              id: h.id,
              amountMsat: _amountStringtoMsats(h.amount),
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
  }) : super.secure(
            certificates: trustedRoots,
            authority: authority,
            onBadCertificate: onBadCertificate);

  @override
  SecurityContext get securityContext {
    final ctx = super.securityContext;
    ctx!.useCertificateChainBytes(certificateChain);
    ctx.usePrivateKeyBytes(privateKey);
    return ctx;
  }
}
