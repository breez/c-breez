import 'dart:async';
import 'dart:typed_data';

import 'package:breez_sdk/breez_sdk.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

class BreezSDKMock extends Mock implements BreezSDK {
  GreenlightCredentials credentials = GreenlightCredentials(
    developerKey: Uint8List(2),
    developerCert: Uint8List(2),
  );

  @override
  Future connect({required ConnectRequest req}) async {
    await nodeInfo();
  }

  Config config = const Config(
    breezserver: '',
    chainnotifierUrl: '',
    mempoolspaceUrl: '',
    network: Network.Bitcoin,
    paymentTimeoutSec: 10,
    workingDir: '.',
    maxfeePercent: 0.5,
    exemptfeeMsat: 20000,
    nodeConfig: NodeConfig_Greenlight(config: GreenlightNodeConfig()),
  );

  @override
  Future<Config> defaultConfig({
    required EnvironmentType envType,
    required String apiKey,
    required NodeConfig nodeConfig,
  }) async {
    return config;
  }

  NodeState? nodeState = const NodeState(
    id: '123456789012345678901234567890123456789012345678901234567890123456',
    blockHeight: 2,
    channelsBalanceMsat: 0,
    onchainBalanceMsat: 0,
    utxos: [],
    maxPayableMsat: 0,
    maxReceivableMsat: 0,
    maxSinglePaymentAmountMsat: 0,
    maxChanReserveMsats: 0,
    connectedPeers: [],
    totalInboundLiquidityMsats: 0,
    maxReceivableSinglePaymentAmountMsat: 0,
    pendingOnchainBalanceMsat: 0,
  );

  @override
  Future<NodeState?> nodeInfo() async {
    nodeStateController.add(nodeState);
    return nodeState;
  }

  LspInformation lspInformation = LspInformation(
    id: "",
    name: "",
    widgetUrl: "",
    pubkey: "",
    host: "",
    baseFeeMsat: 0,
    feeRate: 0,
    timeLockDelta: 0,
    minHtlcMsat: 0,
    lspPubkey: Uint8List(2),
    openingFeeParamsList: OpeningFeeParamsMenu(
      values: [
        OpeningFeeParams(
          minMsat: 2000,
          proportional: 7,
          validUntil: DateTime.now().add(const Duration(days: 1)).toUtc().toIso8601String(),
          maxIdleTime: 1,
          maxClientToSelfDelay: 1,
          promise: "",
        ),
      ],
    ),
  );

  @override
  Future<LspInformation?> fetchLspInfo(String lspId) async {
    return lspInformation;
  }

  @override
  Future connectLSP(String lspId) async {}

  InputType parsedInput = const InputType_LnUrlPay(
    data: LnUrlPayRequestData(
      callback: "",
      minSendable: 0,
      maxSendable: 0,
      metadataStr: "",
      commentAllowed: 0,
      domain: "",
      allowsNostr: false,
    ),
  );

  @override
  Future<InputType> parseInput({required String input}) async {
    return parsedInput;
  }

  final invoicePaidController = StreamController<InvoicePaidDetails>.broadcast();

  @override
  Stream<InvoicePaidDetails> get invoicePaidStream => invoicePaidController.stream;

  @override
  final nodeStateController = BehaviorSubject<NodeState?>();

  @override
  Stream<NodeState?> get nodeStateStream => nodeStateController.stream;

  @override
  final paymentsController = BehaviorSubject<List<Payment>>.seeded([]);

  @override
  Stream<List<Payment>> get paymentsStream => paymentsController.stream;

  final paymentResultController = StreamController<Payment>.broadcast();

  @override
  Stream<Payment> get paymentResultStream => paymentResultController.stream;

  bool isInitializesController = false;

  @override
  Future<bool> isInitialized() async {
    return isInitializesController;
  }

  @override
  Future fetchNodeData() async {}

  ServiceHealthCheckResponse serviceHealthCheckResponse = const ServiceHealthCheckResponse(
    status: HealthCheckStatus.Operational,
  );

  @override
  Future<ServiceHealthCheckResponse> serviceHealthCheck({required String apiKey}) async {
    return serviceHealthCheckResponse;
  }
}
