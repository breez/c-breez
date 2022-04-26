import 'dart:async';

import 'package:c_breez/logger.dart';
import 'package:c_breez/models/lsp.dart';
import 'package:c_breez/services/breez_server/generated/breez.pbgrpc.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/services.dart';
import 'package:grpc/grpc.dart';
import "package:ini/ini.dart";
import 'package:c_breez/services/breez_server/models.dart' as serverModels;

//proto command:
//protoc --dart_out=grpc:lib/services/breez_server/generated/ -Ilib/services/breez_server/protobuf/ lib/services/breez_server/protobuf/breez.proto
class BreezServer {

  CallOptions? _defaultCallOptions;

  ClientChannel? _channel;

  Future<CallOptions> get defaultCallOptions async {
    if (_defaultCallOptions == null) {
      String configString = await rootBundle.loadString('conf/breez.conf');
      Config config = Config.fromString(configString);
      var lspToken = config.get("Application Options", "lsptoken");
      var metadata = <String,String>{};
      metadata["authorization"] = "Bearer $lspToken";
      _defaultCallOptions = CallOptions(timeout: const Duration(seconds: 20), metadata: metadata);
    }
    return _defaultCallOptions!;
  }

  Future<List<serverModels.Rate>> rate() async {
    var channel = await _ensureValidChannel();
    var infoClient = InformationClient(channel, options: await defaultCallOptions);
    var response = await infoClient.rates(RatesRequest());
    log.info('registerDevice response: $response');    

    return response.rates.map((r) => serverModels.Rate(r.coin, r.value)).toList();
  }

  Future<Map<String, LSPInfo>> getLSPList(String nodePubkey) async {
    var channel = await _ensureValidChannel();
    var channelClient = ChannelOpenerClient(channel, options: await defaultCallOptions);
    var response = await channelClient.lSPList(LSPListRequest()..pubkey = nodePubkey);      

    return response.lsps.map((key, value) => MapEntry(key, LSPInfo(
      lspID: key,
      name: value.name,
      widgetURL: value.widgetUrl,
      pubKey: value.pubkey,
      host: value.host,
      frozen: value.isFrozen,
      minHtlcMsat: value.minHtlcMsat.toInt(),
      targetConf: value.targetConf,
      timeLockDelta: value.timeLockDelta,
      baseFeeMsat: value.baseFeeMsat.toInt(),
      channelCapacity: value.channelCapacity.toInt(),
      channelMinimumFeeMsat: value.channelMinimumFeeMsat.toInt(),
      maxInactiveDuration: value.maxInactiveDuration.toInt(),
      channelFeePermyriad: value.channelFeePermyriad.toInt(),
    )));
  }

  Future checkVersion() async {
    // await _ensureValidChannel();
    // var infoClient = InformationClient(_channel, options: defaultCallOptions);
    // var response = await infoClient
    // log.info('registerDevice response: $response');    

    // return response.rates.map((r) => models.Rate(r.coin, r.value));
  }

  Future<String> registerDevice(String id, String nodeid) async {
    await _ensureValidChannel();
    // var invoicerClient = InvoicerClient(_channel, options: defaultCallOptions);
    // var response = await invoicerClient.registerDevice(RegisterRequest()
    //   ..deviceID = id
    //   ..lightningID = nodeid);
    // log.info('registerDevice response: $response');
    // return response.breezID;

    return id;
  }

  Future<String> sendInvoice(
      String breezId, String bolt11, String payee, Int64 amount) async {
    var channel = await _ensureValidChannel();
    var invoicerClient = InvoicerClient(channel, options: await defaultCallOptions);
    var response = await invoicerClient.sendInvoice(PaymentRequest()
      ..breezID = breezId
      ..invoice = bolt11
      ..payee = payee
      ..amount = amount);
    log.info('sendInvoice response: $response');
    return response.toString();
  }

  Future<String> uploadLogo(List<int> logo) async {
    var channel = await _ensureValidChannel();
    var posClient = PosClient(channel,
        options: CallOptions(timeout: const Duration(seconds: 30)));
    return posClient
        .uploadLogo(UploadFileRequest()..content = logo)
        .then((reply) => reply.url);
  }

  Future<JoinCTPSessionResponse> joinSession(
      bool payer, String userName, String notificationToken,
      {String? sessionID}) async {
    var channel = await _ensureValidChannel();
    var ctpClient = CTPClient(channel, options: await defaultCallOptions);
    return await ctpClient.joinCTPSession(JoinCTPSessionRequest()
      ..partyType = payer
          ? JoinCTPSessionRequest_PartyType.PAYER
          : JoinCTPSessionRequest_PartyType.PAYEE
      ..partyName = userName
      ..notificationToken = notificationToken
      ..sessionID = sessionID ?? "");
  }

  Future<TerminateCTPSessionResponse> terminateSession(String sessionID) async {
    var channel = await _ensureValidChannel();
    var ctpClient = CTPClient(channel, options: await defaultCallOptions);
    return await ctpClient.terminateCTPSession(
        TerminateCTPSessionRequest()..sessionID = sessionID);
  }

  Future openLSPChannel(String lspID, String pubkey) async {
    var channel = await _ensureValidChannel();
    var channelClient = ChannelOpenerClient(channel, options: await defaultCallOptions);
    await channelClient.openLSPChannel(OpenLSPChannelRequest(lspId: lspID, pubkey: pubkey));    
  }

  Future<ClientChannel> _ensureValidChannel() async {
    _channel ??= await _createChannel();
    return _channel!;
  }

  Future<ClientChannel> _createChannel() async {
    String configString = await rootBundle.loadString('conf/breez.conf');
    Config config = Config.fromString(configString);
    var hostdetails =
        config.get("Application Options", "breezserver")?.split(':');
    if (hostdetails != null && hostdetails.length < 2) {
      hostdetails.add("443");
    }    
    return ClientChannel(hostdetails![0],
        port: int.parse(hostdetails[1]),  
        options: const ChannelOptions(credentials: ChannelCredentials.secure()));
  }
}
