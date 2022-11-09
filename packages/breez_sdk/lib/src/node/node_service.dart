import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_sdk/src/btc_swapper/btc_swapper.dart';
import 'package:breez_sdk/src/chain_service/chain_service_mempool_space_settings.dart';
import 'package:breez_sdk/src/chain_service/mempool_space.dart';
import 'package:breez_sdk/src/chain_service/payload/recommended_fee_payload.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:breez_sdk/sdk.dart';
import 'package:breez_sdk/src/node/sync_state.dart';
import 'package:breez_sdk/src/utils/retry.dart';
import 'package:fimber/fimber.dart';
import 'package:fixnum/fixnum.dart';
import 'package:hex/hex.dart';
import 'package:breez_sdk/src/node/node_api/greenlight/generated/greenlight.pbgrpc.dart' as greenlight;
import 'package:rxdart/rxdart.dart';

import 'models_extensions.dart';

const maxPaymentAmountMsats = 4294967000;
const maxInboundLiquidityMsats = 4000000000;

class LightningNode {
  static const String paymentFilterSettingsKey = "payment_filter_settings";
  final _log = FimberLog("GreenlightService");
  
  final NodeAPI _nodeAPI = Greenlight();
  final LNURLService _lnurlService = LNURLService();

  final _storage = Storage.createDefault();
  late final ChainService _chainService;
  late final BTCSwapper _subswapService;
  late final NodeStateSyncer _syncer;
  LspInformation? _currentLSP;
  Signer? _signer;

  LightningNode() {
    _syncer = NodeStateSyncer(_nodeAPI, _storage);
    _chainService = MempoolSpace(_storage);
    _subswapService = BTCSwapper(this, _storage, _chainService);
    FGBGEvents.stream.where((event) => event == FGBGType.foreground).throttleTime(const Duration(minutes: 1)).listen((event) async {
      if (_signer != null) {
        await syncState();           
      }
    });

    FGBGEvents.stream.where((event) => event == FGBGType.foreground).listen((event) async {
      await _subswapService.redeemPendingSwaps();     
    });
    Timer.periodic(const Duration(minutes: 10), (timer) {
      _subswapService.redeemPendingSwaps();
    });    
  }

  LNURLService get lnurlService => _lnurlService;

  BTCSwapper get subwapService => _subswapService;

  void setPaymentFilter(PaymentFilter filter) {
    _storage.updateSettings(paymentFilterSettingsKey, json.encode(filter.toJson()));
  }

  Stream<PaymentFilter> paymentFilterStream() {
    return _storage
        .watchSetting(paymentFilterSettingsKey)
        .map((s) => s == null ? PaymentFilter.initial() : PaymentFilter.fromJson(json.decode(s.value)));
  }

  Stream<NodeState?> nodeStateStream() {
    return _storage.watchNodeState().map((dbState) => dbState == null ? null : NodeStateAdapter.fromDbNodeState(dbState));
  }

  Future<NodeState?> getNodeState() async {
    final dbState = await _storage.getNodeState();
    return dbState == null ? null : NodeStateAdapter.fromDbNodeState(dbState);
  }

  Stream<PaymentsState> paymentsStream() {
    // outgoing payments stream
    final outgoingPaymentsStream = _storage.watchOutgoingPayments().map((pList) {
      return true;
    });

    // incoming payments stream (settled invoices)
    final incomingPaymentsStream = _storage.watchIncomingPayments().map((iList) {
      return true;
    });

    final paymentsFilterStream = _storage.watchSetting(paymentFilterSettingsKey);

    return Rx.merge([outgoingPaymentsStream, incomingPaymentsStream, paymentsFilterStream]).asyncMap((e) async {
      // node info
      final nodeState = await _storage.watchNodeState().first;
      final rawFilter = await _storage.readSettings(paymentFilterSettingsKey);
      final paymentFilter = rawFilter == null || rawFilter.value.isEmpty
          ? PaymentFilter.initial()
          : PaymentFilter.fromJson(json.decode(rawFilter.value));

      var outgoing = await _storage.listOutgoingPayments();
      var outgoingList = outgoing.map((p) {
        return PaymentInfo(
            type: PaymentType.sent,
            amountMsat: p.amountMsats,
            destination: p.destination,
            shortTitle: p.description,
            description: p.description,
            feeMsat: p.feeMsat,
            creationTimestamp: p.createdAt,
            pending: p.pending,
            keySend: p.isKeySend,
            paymentHash: p.paymentHash);
      });

      var incoming = await _storage.listIncomingPayments();
      var incomingList = incoming.map((invoice) {
        return PaymentInfo(
            type: PaymentType.received,
            amountMsat: invoice.receivedMsat,
            feeMsat: 0,
            destination: nodeState!.nodeID,
            shortTitle: invoice.description,
            creationTimestamp: invoice.paymentTime,
            pending: false,
            keySend: false,
            paymentHash: invoice.paymentHash);
      });

      final unifiedList = incomingList.toList()
        ..addAll(outgoingList)
        ..sort((p1, p2) => (p2.creationTimestamp - p1.creationTimestamp).toInt());

      var list = unifiedList.where((p) => paymentFilter.includes(p)).toList();
      return PaymentsState(list, paymentFilter, unifiedList.isEmpty ? null : DateTime.fromMillisecondsSinceEpoch(unifiedList.first.creationTimestamp.toInt() * 1000));
    });
  }

  Future<List<int>> newNodeFromSeed(Uint8List seed, Signer signer) async {
    final creds = await _nodeAPI.register(seed, signer);
    _signer = signer;
    return creds;
  }

  Future<List<int>> connectWithSeed(Uint8List seed, Signer signer) async {
    final creds = await _nodeAPI.recover(seed, signer);
    _signer = signer;
    return creds;
  }

  connectWithCredentials(List<int> credentials, Signer signer) {
    _nodeAPI.initWithCredentials(credentials, signer);
    _signer = signer;  
  }

  NodeAPI getNodeAPI() {
    return _nodeAPI;
  }

  Future syncState() async{
    await _nodeAPI.ensureScheduled();
    return await _syncer.syncState();
  }

  LspInformation? get currentLSP => _currentLSP;

  Future setLSP(LspInformation lspInfo, {required bool connect}) async {
    _currentLSP = lspInfo;
    if (connect) {
      await retry(() async {
        await _nodeAPI.connectPeer(lspInfo.pubkey, lspInfo.host);
      }, tryLimit: 3, interval: const Duration(seconds: 2));
    }    
  }

  Future<PaymentInfo> sendPaymentForRequest(String blankInvoicePaymentRequest, {int? amount}) async {
    final outgoingPayment = await _nodeAPI.sendPaymentForRequest(blankInvoicePaymentRequest, amount: amount);
    return outgoingPayment.toPaymentInfo();
  }

  Future<PaymentInfo> sendSpontaneousPayment(String destNode, int amount, String description,
  {int feeLimitMsat = 0, Map<int, String> tlv = const {}}) async {
    final outgoingPayment = await _nodeAPI.sendSpontaneousPayment(destNode, amount, description, feeLimitMsat: feeLimitMsat, tlv: tlv);
    return outgoingPayment.toPaymentInfo();
  }

  Future<Withdrawal> sweepAllCoinsTransactions(String address, TransactionCostSpeed speed) {
    final feerate = speed == TransactionCostSpeed.priority
        ? greenlight.FeeratePreset.URGENT
        : speed == TransactionCostSpeed.economy
            ? greenlight.FeeratePreset.SLOW
            : greenlight.FeeratePreset.NORMAL;
    return _nodeAPI.sweepAllCoinsTransactions(address, feerate);
  }

  Future<RecommendedFeePayload> fetchRecommendedFees() => _chainService.fetchRecommendedFees();

  MempoolSpace _mempoolSpace() =>
      _chainService is MempoolSpace ? (_chainService as MempoolSpace) : MempoolSpace(_storage);

  Future<ChainServiceMempoolSpaceSettings> getMempoolSpaceSettings() =>
      _mempoolSpace().getMempoolSpaceSettings();

  Future<void> setMempoolSpaceSettings(String scheme, String host, String? port) =>
      _mempoolSpace().setMempoolSpaceSettings(scheme, host, port);

  Future<void> resetMempoolSpaceSettings() =>
      _mempoolSpace().resetMempoolSpaceSettings();
}
