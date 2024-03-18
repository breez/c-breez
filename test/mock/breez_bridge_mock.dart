import 'dart:async';
import 'dart:typed_data';

import 'package:breez_sdk/sdk.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

class BreezSDKMock extends Mock {
  BreezSDKMock._();

  static BreezSDKMock? _instance;

  static BreezSDKMock get instance {
    _instance ??= BreezSDKMock._();
    return _instance!;
  }

  static BreezSDKMock? delegatePackingProperty;

  static BreezSDKMock get _delegate {
    return delegatePackingProperty ??= BreezSDKMock.instance;
  }

  static GreenlightCredentials credentials = GreenlightCredentials(
    deviceKey: Uint8List(2),
    deviceCert: Uint8List(2),
  );

  static Future connect({
    required ConnectRequest req,
  }) async {
    await nodeInfo();
  }

  static Config config = const Config(
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

  static Future<Config> defaultConfig({
    required EnvironmentType envType,
    required String apiKey,
    required NodeConfig nodeConfig,
  }) async {
    return config;
  }

  static NodeState? nodeState = const NodeState(
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
    inboundLiquidityMsats: 0,
    pendingOnchainBalanceMsat: 0,
  );

  static Future<NodeState?> nodeInfo() async {
    nodeStateController.add(nodeState);
    return nodeState;
  }

  static LspInformation lspInformation = LspInformation(
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
        )
      ],
    ),
  );

  static Future<LspInformation?> fetchLspInfo(String lspId) async {
    return lspInformation;
  }

  static Future connectLSP(String lspId) async {}

  static InputType parsedInput = const InputType_LnUrlPay(
    data: LnUrlPayRequestData(
      callback: "",
      minSendable: 0,
      maxSendable: 0,
      metadataStr: "",
      commentAllowed: 0,
      domain: "",
    ),
  );

  static Future<InputType> parseInput({required String input}) async {
    return parsedInput;
  }

  static final invoicePaidController = StreamController<InvoicePaidDetails>.broadcast();

  static Stream<InvoicePaidDetails> get invoicePaidStream => invoicePaidController.stream;

  static final nodeStateController = BehaviorSubject<NodeState?>();

  static Stream<NodeState?> get nodeStateStream => nodeStateController.stream;

  static final paymentsController = BehaviorSubject<List<Payment>>.seeded([]);

  static Stream<List<Payment>> get paymentsStream => paymentsController.stream;

  static final paymentResultController = StreamController<Payment>.broadcast();

  static Stream<Payment> get paymentResultStream => paymentResultController.stream;

  static bool isInitializesController = false;

  static Future<bool> isInitialized() async {
    return isInitializesController;
  }

  static Future fetchNodeData() async {}

  static ServiceHealthCheckResponse serviceHealthCheckResponse = const ServiceHealthCheckResponse(
    status: HealthCheckStatus.Operational,
  );

  static Future<ServiceHealthCheckResponse> serviceHealthCheck({
    required String apiKey,
  }) async {
    return serviceHealthCheckResponse;
  }

  /* _ */
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BreezSDK && other.hashCode == hashCode;
  }

  @override
  int get hashCode => _delegate.hashCode;

  @override
  String toString() => 'BreezSDK';
}
