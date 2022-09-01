import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:breez_sdk/src/node/node_api/greenlight/generated/greenlight.pbgrpc.dart'
    as greenlight;
import 'package:breez_sdk/src/node/node_api/greenlight/generated/scheduler.pbgrpc.dart'
    as scheduler;
import 'package:breez_sdk/src/node/node_api/models.dart';
import 'package:breez_sdk/src/node/node_api/node_api.dart';
import 'package:breez_sdk/src/signer.dart';
import 'package:fimber/fimber.dart';
import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';
import 'package:hex/hex.dart';

import 'incoming.dart';
import 'scheduler_credentials.dart';

class Greenlight implements NodeAPI {  
  NodeCredentials? _nodeCredentials;
  greenlight.NodeClient? _nodeClient;
  //scheduler.SchedulerClient? _schedulerClient;
  ClientChannel? _schedulerChannel;
  Signer? _signer;

  final _log = FimberLog("GreenlightService");
  final _incomingPaymentsStream = StreamController<IncomingLightningPayment>.broadcast();
  final Completer _readyCompleter = Completer();

  Greenlight();

  @override
  void initWithCredentials(List<int> credentials, Signer signer) {
    _signer = signer;
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
  Future ensureScheduled() async {
    await schedule();
  }

  Future<scheduler.SchedulerClient> _createSchedulerClient() async {
    if (_schedulerChannel == null) {
      final NodeCredentials schedulerCredentials = NodeCredentials(caCert, nobodyCert, nobodyKey, null, null);
      _schedulerChannel = _createNodeChannel(schedulerCredentials, "https://scheduler.gl.blckstrm.com:2601");
    }
    return scheduler.SchedulerClient(_schedulerChannel!);
  }

  Future streamIncomingRequests(List<int> nodeID) async {
    while (true) {
      try {
        _log.i("streaming signer requests");
        var schedulerClient = await _createSchedulerClient();
        var nodeInfo = await schedulerClient.getNodeInfo(scheduler.NodeInfoRequest()
          ..nodeId = nodeID
          ..wait = true);
        var nodeChannel = _createNodeChannel(_nodeCredentials!, nodeInfo.grpcUri);
        _nodeClient = greenlight.NodeClient(nodeChannel);

        _nodeClient!.streamLog(greenlight.StreamLogRequest()).listen((value) {
          _log.v(value.line);
        });
        // stream incoming payments
        IncomingPaymentsLoop(_nodeClient!, _incomingPaymentsStream.sink).start();

        // stream signer and wait for it to shut down.
        await SignerLoop(_signer!, _nodeClient!).start();
      } catch (e) {
        _log.e("signer exited, waiting 1 seconds...", ex: e);
      }
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  bool signerRunning = false;
  Future<scheduler.NodeInfoResponse> schedule() async {
    _log.i("scheduling node ${_nodeCredentials!.nodeId}");
    var schedulerClient = await _createSchedulerClient();
    try {
      if (!signerRunning) {
        signerRunning = true;
        streamIncomingRequests(_nodeCredentials!.nodeId!);
      }

      var res = await schedulerClient.schedule(scheduler.ScheduleRequest(nodeId: _nodeCredentials!.nodeId));
      var nodeChannel = _createNodeChannel(_nodeCredentials!, res.grpcUri);
      _nodeClient = greenlight.NodeClient(nodeChannel);      
      return res;
    } catch (e) {
      _log.e("error scheduling node ${e.toString()}");
      rethrow;
    }
  }

  @override
  Stream<IncomingLightningPayment> incomingPaymentsStream() {
    return _incomingPaymentsStream.stream;
  }

  @override
  Future<List<int>> recover(Uint8List seed, Signer signer) async {
    final init = await signer.init();
    final nodePubkey = await signer.getNodePubkey();
    var schedulerClient = await _createSchedulerClient();
    var challengeResponse = await schedulerClient
        .getChallenge(scheduler.ChallengeRequest(nodeId: nodePubkey, scope: scheduler.ChallengeScope.RECOVER));
    var sig = await signer.signMessage(message: Uint8List.fromList(challengeResponse.challenge));
    var recoverResponse = await schedulerClient
        .recover(scheduler.RecoveryRequest(challenge: challengeResponse.challenge, nodeId: nodePubkey, signature: sig));
    _nodeCredentials = NodeCredentials(caCert, recoverResponse.deviceCert, recoverResponse.deviceKey, nodePubkey, seed);
    var creds = _nodeCredentials!.writeBuffer();
    initWithCredentials(creds, signer);
    return creds;
  }

  @override
  Future<List<int>> register(Uint8List seed, Signer signer, {String network = "bitcoin", String? email}) async {    
    final init = await signer.init();
    final nodePubkey = await signer.getNodePubkey();

    var schedulerClient = await _createSchedulerClient();
    var challengeResponse = await schedulerClient
        .getChallenge(scheduler.ChallengeRequest(nodeId: nodePubkey, scope: scheduler.ChallengeScope.REGISTER));
    var sig = await signer.signMessage(message: Uint8List.fromList(challengeResponse.challenge));

    var registration = await schedulerClient.register(scheduler.RegistrationRequest(
        network: network,
        nodeId: nodePubkey,
        initMsg: init,
        signature: sig,
        signerProto: "v0.11.0.1",
        challenge: challengeResponse.challenge));
    _nodeCredentials = NodeCredentials(caCert, registration.deviceCert, registration.deviceKey, nodePubkey, seed);
    var creds = _nodeCredentials!.writeBuffer();
    initWithCredentials(creds, signer);
    return creds;
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
          amountMsats: amountToMSats(e.amount),
          address: e.address,
          status: OutputStatus.values[e.status.value],
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
  Future<List<int>> closeChannel(List<int> nodeID) async {
    var addressResp = await _nodeClient!.newAddr(greenlight.NewAddrRequest(addressType: greenlight.BtcAddressType.BECH32));
    var closeResp = await _nodeClient!.closeChannel(greenlight.CloseChannelRequest(nodeId: nodeID, unilateraltimeout: greenlight.Timeout(seconds: 30), destination: greenlight.BitcoinAddress(address: addressResp.address)));
    return closeResp.txid;
  }

  @override
  Future connectPeer(String nodeID, String address) async {    
    await _nodeClient!.connectPeer(greenlight.ConnectRequest(nodeId: nodeID, addr: address));
  }

  @override
  Future<Int64> getDefaultOnChainFeeRate() {
    return Future.value(Int64.ZERO);
  }

  @override
  Future<List<OutgoingLightningPayment>> getPayments() async {    
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
    await _nodeClient!
        .pay(greenlight.PayRequest(bolt11: blankInvoicePaymentRequest, amount: greenlight.Amount(satoshi: amount), timeout: 60));
  }

  @override
  Future<OutgoingLightningPayment> sendSpontaneousPayment(String destNode, Int64 amount, String description,
      {Int64 feeLimitMsat = Int64.ZERO, Map<Int64, String> tlv = const {}}) {
    // TODO: implement sendSpontaneousPayment
    throw UnimplementedError();
  }

  @override
  Future<Withdrawal> sweepAllCoinsTransactions(String address, greenlight.FeeratePreset feerate) async {
    final response = await _nodeClient!.withdraw(greenlight.WithdrawRequest(
      destination: address,
      amount: greenlight.Amount(
          all: true,
      ),
      feerate: greenlight.Feerate(
          preset: feerate,
      ),
    ));
    return Withdrawal(
      HEX.encode(response.txid),
      HEX.encode(response.tx),
    );
  }

  ClientChannel _createNodeChannel(NodeCredentials credentials, String grpcUri) {
    var uri = Uri.parse(grpcUri);
    return ClientChannel(uri.host,
        port: uri.port,
        options: ChannelOptions(            
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
