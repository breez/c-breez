import 'dart:async';
import 'package:c_breez/services/breez_server/generated/breez.pbgrpc.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/services.dart';
import 'package:grpc/grpc.dart';
import "package:ini/ini.dart";
import 'package:c_breez/services/breez_server/models.dart' as server_models;

//proto command:
//protoc --dart_out=grpc:lib/services/breez_server/generated/ -Ilib/services/breez_server/protobuf/ lib/services/breez_server/protobuf/breez.proto
class BreezServer {
  CallOptions? _defaultCallOptions;
  String? _openChannelToken;

  ClientChannel? _channel;

  Future<CallOptions> get defaultCallOptions async {
    if (_defaultCallOptions == null) {
      String configString = await rootBundle.loadString('conf/breez.conf');
      Config config = Config.fromString(configString);
      var lspToken = config.get("Application Options", "lsptoken");
      var metadata = <String, String>{};
      metadata["authorization"] = "Bearer $lspToken";
      _defaultCallOptions =
          CallOptions(timeout: const Duration(seconds: 20), metadata: metadata);
      _openChannelToken = config.get("Application Options", "openchanneltoken");
    }
    return _defaultCallOptions!;
  }

  Future<List<server_models.Rate>> rate() async {
    var channel = await _ensureValidChannel();
    var infoClient =
        InformationClient(channel, options: await defaultCallOptions);
    var response = await infoClient.rates(RatesRequest());

    return response.rates
        .map((r) => server_models.Rate(r.coin, r.value))
        .toList();
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
    var invoicerClient =
        InvoicerClient(channel, options: await defaultCallOptions);
    var response = await invoicerClient.sendInvoice(PaymentRequest()
      ..breezID = breezId
      ..invoice = bolt11
      ..payee = payee
      ..amount = amount);
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
    var callOptions = await defaultCallOptions;
    callOptions = callOptions.mergedWith(
        CallOptions(metadata: {"authorization": "Bearer $_openChannelToken"}));
    var channelClient =
        PublicChannelOpenerClient(channel, options: callOptions);
    await channelClient
        .openPublicChannel(OpenPublicChannelRequest(pubkey: pubkey));
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
        options:
            const ChannelOptions(credentials: ChannelCredentials.secure()));
  }
}
