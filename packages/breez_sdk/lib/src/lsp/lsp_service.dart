import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_sdk/native_toolkit.dart';
import 'package:breez_sdk/src/breez_server/generated/breez.pbgrpc.dart';
import 'package:breez_sdk/src/breez_server/server.dart';
import 'package:breez_sdk/src/lsp/models.dart';
import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';

class LSPService {
  final _lnToolkit = getNativeToolkit();

  Future<Map<String, LSPInfo>> getLSPList(String nodePubkey) async {
    List<LspInformation> lspList = await _lnToolkit.listLsps();
    // Ideally we'll use the generated data from rust bridge as is but trying to do so
    // the scope gets very large, very quick and it affects parts of the app that are not yet implemented.
    // That's why we chose to map the generated data to the models we're already using for now.
    return lspList.map(
      (lsp) => MapEntry(
        lsp.id,
        LSPInfo(
          lspID: lsp.id,
          name: lsp.name,
          pubKey: lsp.pubkey,
          lspPubkey: lsp.lspPubkey,
          host: lsp.host,
          minHtlcMsat: lsp.minHtlcMsat,
          targetConf: lsp.targetConf,
          timeLockDelta: lsp.timeLockDelta,
          baseFeeMsat: lsp.baseFeeMsat,
          channelCapacity: lsp.channelCapacity,
          channelFeePermyriad: lsp.channelFeePermyriad,
          maxInactiveDuration: lsp.maxInactiveDuration,
          channelMinimumFeeMsat: lsp.channelMinimumFeeMsat,
        ),
      ),
    ) as Map<String, LSPInfo>;
  }

  Future registerPayment(
      {required String lspID,
      required List<int> lspPubKey,
      required List<int> paymentHash,
      required List<int> paymentSecret,
      required List<int> destination,
      required Int64 incomingAmountMsat,
      required Int64 outgoingAmountMsat}) async {
    throw Exception("Ready for Integration");
    /*
    final server = await BreezServer.createWithDefaultConfig();
    var channel = await server.createServerChannel();
    var channelClient = ChannelOpenerClient(channel, options: server.defaultCallOptions);
    final paymentInfo = PaymentInformation(
      paymentHash: paymentHash,
      paymentSecret: paymentSecret,
      destination: destination,
      incomingAmountMsat: incomingAmountMsat,
      outgoingAmountMsat: outgoingAmountMsat,
    );
    final buffer = paymentInfo.writeToBuffer();
    final key = Uint8List.fromList(lspPubKey);
    final encryptedMessage = await _lnToolkit.encrypt(key: key, msg: buffer);

    return channelClient.registerPayment(RegisterPaymentRequest(lspId: lspID, blob: encryptedMessage));
     */
  }

  Future openLSPChannel(String lspID, String pubkey) async {
    final server = await BreezServer.createWithDefaultConfig();
    var channel = await server.createServerChannel();
    var callOptions = server.defaultCallOptions;
    callOptions = callOptions.mergedWith(CallOptions(
        metadata: {"authorization": "Bearer ${server.openChannelToken}"}));
    var channelClient =
        PublicChannelOpenerClient(channel, options: callOptions);
    await channelClient
        .openPublicChannel(OpenPublicChannelRequest(pubkey: pubkey));
  }
}
