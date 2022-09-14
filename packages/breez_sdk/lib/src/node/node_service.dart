import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:breez_sdk/sdk.dart';
import 'package:breez_sdk/src/native_toolkit.dart';
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
  final LSPService _lspService;
  final _lnToolkit = getNativeToolkit();
  final Storage _stroage;
  late final NodeStateSyncer _syncer;
  LSPInfo? _currentLSP;
  Signer? _signer;

  LightningNode(this._lspService, this._stroage) {
    _syncer = NodeStateSyncer(_nodeAPI, _stroage);
    FGBGEvents.stream.where((event) => event == FGBGType.foreground).throttleTime(const Duration(minutes: 1)).listen((event) async {
      if (_signer != null) {
        await syncState();
      }
    });
  }

  void setPaymentFilter(PaymentFilter filter) {
    _stroage.updateSettings(paymentFilterSettingsKey, json.encode(filter.toJson()));
  }

  Stream<PaymentFilter> paymentFilterStream() {
    return _stroage
        .watchSetting(paymentFilterSettingsKey)
        .map((s) => s == null ? PaymentFilter.initial() : PaymentFilter.fromJson(json.decode(s.value)));
  }

  Stream<NodeState?> nodeStateStream() {
    return _stroage.watchNodeState().map((dbState) => dbState == null ? null : NodeStateAdapter.fromDbNodeState(dbState));
  }

  Future<NodeState?> getNodeState() async {
    final dbState = await _stroage.getNodeState();
    return dbState == null ? null : NodeStateAdapter.fromDbNodeState(dbState);
  }

  Stream<PaymentsState> paymentsStream() {
    // outgoing payments stream
    final outgoingPaymentsStream = _stroage.watchOutgoingPayments().map((pList) {
      return true;
    });

    // incoming payments stream (settled invoices)
    final incomingPaymentsStream = _stroage.watchIncomingPayments().map((iList) {
      return true;
    });

    final paymentsFilterStream = _stroage.watchSetting(paymentFilterSettingsKey);

    return Rx.merge([outgoingPaymentsStream, incomingPaymentsStream, paymentsFilterStream]).asyncMap((e) async {
      // node info
      final nodeState = await _stroage.watchNodeState().first;
      final rawFilter = await _stroage.readSettings(paymentFilterSettingsKey);
      final paymentFilter = rawFilter == null || rawFilter.value.isEmpty
          ? PaymentFilter.initial()
          : PaymentFilter.fromJson(json.decode(rawFilter.value));

      var outgoing = await _stroage.listOutgoingPayments();
      var outgoingList = outgoing.map((p) {
        return PaymentInfo(
            type: PaymentType.sent,
            amountMsat: Int64(p.amountMsats),
            destination: p.destination,
            shortTitle: p.description,
            description: p.description,
            feeMsat: Int64(p.feeMsat),
            creationTimestamp: Int64(p.createdAt),
            pending: p.pending,
            keySend: p.isKeySend,
            paymentHash: p.paymentHash);
      });

      var incoming = await _stroage.listIncomingPayments();
      var incomingList = incoming.map((invoice) {
        return PaymentInfo(
            type: PaymentType.received,
            amountMsat: Int64(invoice.receivedMsat),
            feeMsat: Int64.ZERO,
            destination: nodeState!.nodeID,
            shortTitle:  invoice.description,
            creationTimestamp: Int64(invoice.paymentTime),
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

  LSPInfo? get currentLSP => _currentLSP;

  Future setLSP(LSPInfo lspInfo, {required bool connect}) async {
    _currentLSP = lspInfo;
    if (connect) {
      await retry(() async {
        await _nodeAPI.connectPeer(lspInfo.pubKey, lspInfo.host);
        //final nodeInfo = await _nodeAPI.getNodeInfo();
        //await _lspService.openLSPChannel(lspInfo.lspID, nodeInfo.nodeID);
      }, tryLimit: 3, interval: const Duration(seconds: 2));
    }
  }

  Future<Invoice> requestPayment(Int64 amountSats, {String? description, Int64? expiry}) async {
    final currentNodeState = await nodeStateStream().first;
    final amountMSat = amountSats * 1000;

    if (currentNodeState == null) {
      throw Exception("Node is not ready");
    }

    if (_currentLSP == null) {
      throw Exception("LSP is not set");
    }

    int shortChannelId = ((1 & 0xFFFFFF) << 40 | (0 & 0xFFFFFF) << 16 | (0 & 0xFFFF));
    var destinationInvoiceAmountSats = amountSats;
    // check if we need to open channel
    if (currentNodeState.maxInboundLiquidityMsats < amountMSat) {
      _log.i(
          "requestPayment: need to open a channel, creating payee invoice, currentLSP = ${json.encode(_currentLSP!.toJson())}");

      // we need to open channel so we are calculating the fees for the LSP
      var channelFeesMsat = (amountMSat.toInt() * _currentLSP!.channelFeePermyriad / 10000 / 1000 * 1000).toInt();
      if (channelFeesMsat < _currentLSP!.channelMinimumFeeMsat) {
        channelFeesMsat = _currentLSP!.channelMinimumFeeMsat;
      }

      if (amountMSat.toInt() < channelFeesMsat + 1000) {
        _log.i("requestPayment: Amount should be more than the minimum fees (${_currentLSP!.channelMinimumFeeMsat / 1000} sats)");
        throw Exception("Amount should be more than the minimum fees (${_currentLSP!.channelMinimumFeeMsat / 1000} sats)");
      }

      // remove the fees from the amount to get the small amount on the current node invoice.
      destinationInvoiceAmountSats = Int64((amountSats.toInt() - channelFeesMsat / 1000).toInt());
    } else {
      // not opening a channel so we need to get the real channel id into the routing hints
      final nodePeers = await _nodeAPI.listPeers();
      for (var p in nodePeers) {
        if (p.id == _currentLSP!.pubKey && p.channels.isNotEmpty) {                    
          var activeChannel  = p.channels.firstWhere((c) => c.state == ChannelState.OPEN);
          shortChannelId = _parseShortChannelID(activeChannel.shortChannelId);
          break;
        }
      }
    }

    final invoice = await _nodeAPI.addInvoice(amountSats, description: description, expiry: expiry);
    _log.i("requestPayment: node returned a new invoice, adding routing hints");

    // create lsp routing hints
    var lspHop = RouteHintHop(
      srcNodeId: _currentLSP!.pubKey,
      shortChannelId: shortChannelId,
      feesBaseMsat: _currentLSP!.baseFeeMsat,
      feesProportionalMillionths: 10,
      cltvExpiryDelta: _currentLSP!.timeLockDelta,
      htlcMinimumMsat: _currentLSP!.minHtlcMsat,
      htlcMaximumMsat: 1000000000,
    );

    // inject routing hints and sign the new invoice
    var routingHints = RouteHint(field0: List.from([lspHop]));

    final bolt11WithHints =
        await _signer!.addRoutingHints(invoice: invoice.bolt11, hints: [routingHints], newAmount: amountSats.toInt() * 1000);
    // register the payment at the lsp if needed.
    if (destinationInvoiceAmountSats < amountSats) {
      _log.i("requestPayment: need to register paymenet, parsing invoice");
      final lnInvoice = await _lnToolkit.parseInvoice(invoice: bolt11WithHints);

      _log.i("requestPayment: registering payment in LSP");
      final destination = HEX.decode(lnInvoice.payeePubkey);

      await _lspService.registerPayment(
          destination: destination,
          lspID: _currentLSP!.lspID,
          lspPubKey: _currentLSP!.lspPubkey,
          paymentHash: HEX.decode(invoice.paymentHash),
          paymentSecret: lnInvoice.paymentSecret.toList(),
          incomingAmountMsat: amountMSat,
          outgoingAmountMsat: destinationInvoiceAmountSats * 1000);

      _log.i("requestPayment: paymenet registered");
    }

    // return the converted invoice
    return invoice.copyWithNewAmount(amountMsats: amountMSat, bolt11: bolt11WithHints);
  }

  Future sendPaymentForRequest(String blankInvoicePaymentRequest, {Int64? amount}) {
    return _nodeAPI.sendPaymentForRequest(blankInvoicePaymentRequest, amount: amount);
  }

  Future<OutgoingLightningPayment> sendSpontaneousPayment(String destNode, Int64 amount, String description,
  {Int64 feeLimitMsat = Int64.ZERO, Map<Int64, String> tlv = const {}}) async {
    return _nodeAPI.sendSpontaneousPayment(destNode, amount, description, feeLimitMsat: feeLimitMsat, tlv: tlv);
  }

  Future<Withdrawal> sweepAllCoinsTransactions(String address, TransactionCostSpeed speed) {
    final feerate = speed == TransactionCostSpeed.priority
        ? greenlight.FeeratePreset.URGENT
        : speed == TransactionCostSpeed.economy
            ? greenlight.FeeratePreset.SLOW
            : greenlight.FeeratePreset.NORMAL;
    return _nodeAPI.sweepAllCoinsTransactions(address, feerate);
  }

  int _parseShortChannelID(String idStr) {
    var parts = idStr.split("x");
    if (parts.length != 3) {
      return 0;
    }
    var blockNum = int.parse(parts[0]);
    var txNum = int.parse(parts[1]);
    var txOut = int.parse(parts[2]);
    return ((blockNum & 0xFFFFFF) << 40 | (txNum & 0xFFFFFF) << 16 | (txOut & 0xFFFF));
  }
}
