import 'dart:async';

import 'package:breez_sdk/breez_bridge.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

class BreezBridgeMock extends Mock implements BreezBridge {
  GreenlightCredentials credentials = GreenlightCredentials(
    deviceKey: Uint8List(2),
    deviceCert: Uint8List(2),
  );

  @override
  Future initNode({
    required Config config,
    required Uint8List seed,
    required GreenlightCredentials creds,
  }) async {}

  @override
  Future<GreenlightCredentials> recoverNode({
    required Config config,
    required Network network,
    required Uint8List seed,
  }) async {
    return credentials;
  }

  NodeState? nodeState = NodeState(
    id: '123456789012345678901234567890123456789012345678901234567890123456',
    blockHeight: 2,
    channelsBalanceMsat: 0,
    onchainBalanceMsat: 0,
    maxPayableMsat: 0,
    maxReceivableMsat: 0,
    maxSinglePaymentAmountMsat: 0,
    maxChanReserveMsats: 0,
    connectedPeers: [],
    inboundLiquidityMsats: 0,
  );

  @override
  Future<NodeState?> getNodeState() async {
    nodeStateController.add(nodeState);
    return nodeState;
  }

  LspInformation lspInformation = LspInformation(
    id: "",
    name: "",
    widgetUrl: "",
    pubkey: "",
    host: "",
    channelCapacity: 0,
    targetConf: 0,
    baseFeeMsat: 0,
    feeRate: 0,
    timeLockDelta: 0,
    minHtlcMsat: 0,
    channelFeePermyriad: 0,
    lspPubkey: Uint8List(2),
    maxInactiveDuration: 0,
    channelMinimumFeeMsat: 0,
  );

  @override
  Future<LspInformation> getLspInfo() async {
    return lspInformation;
  }

  @override
  Future connectLSP(String lspId) async {}

  final invoicePaidController = StreamController<InvoicePaidDetails>.broadcast();

  @override
  Stream<InvoicePaidDetails> get invoicePaidStream => invoicePaidController.stream;

  @override
  final nodeStateController = StreamController<NodeState?>.broadcast();

  @override
  Stream<NodeState?> get nodeStateStream => nodeStateController.stream;

  @override
  final paymentsController = BehaviorSubject<List<Payment>>.seeded([]);

  @override
  Stream<List<Payment>> get paymentsStream => paymentsController.stream;
}
