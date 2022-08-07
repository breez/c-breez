import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:breez_sdk/sdk.dart';
import 'package:breez_sdk/src/native_toolkit.dart';
import 'package:breez_sdk/src/utils/retry.dart';
import 'package:dart_lnurl/dart_lnurl.dart';
import 'package:fimber/fimber.dart';
import 'package:fixnum/fixnum.dart';
import 'package:hex/hex.dart';
import 'package:http/http.dart' as http;
import 'package:breez_sdk/src/node/node_api/greenlight/generated/greenlight.pbgrpc.dart' as greenlight;

import 'node_api/node_api.dart';

const _maxPaymentAmountMsats = 4294967000;
const maxInboundLiquidityMsats = 4000000000;

class LightningNode {
  final _log = FimberLog("GreenlightService");
  final NodeAPI _nodeAPI = Greenlight();
  final LSPService _lspService;
  final _lnToolkit = getNativeToolkit();
  LSPInfo? _currentLSP;
  Signer? _signer;

  LightningNode(this._lspService);

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

  Future<NodeState> getState() async {
    final peers = await _nodeAPI.listPeers();
    final nodeInfo = await _nodeAPI.getNodeInfo();
    final funds = await _nodeAPI.listFunds();
    return _assembleAccountState(nodeInfo, funds.channelFunds, funds.onchainFunds, peers);
  }

  Future<List<OutgoingLightningPayment>> getOutgoingPaymentsSince(DateTime since) async {
    final outgoingPayments = await _nodeAPI.getPayments();
    return outgoingPayments.where((p) => DateTime.fromMillisecondsSinceEpoch(p.creationTimestamp).isAfter(since)).toList();
  }

  Future<List<Invoice>> getIncomingPaymentsSince() async {
    final invoices = await _nodeAPI.getInvoices();
    return invoices.where((i) => i.receivedMsats > 0).toList();
  }

  Future<Invoice> requestPayment(Int64 amountSats, {String? description, Int64? expiry}) async {
    final currentNodeState = await getState();
    final amountMSat = amountSats * 1000;

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
          shortChannelId = _parseShortChannelID(p.channels.first.shortChannelId);
          break;
        }
      }
    }

    final invoice = await _nodeAPI.addInvoice(destinationInvoiceAmountSats, description: description, expiry: expiry);
    _log.i("requestPayment: node returned a new invoice, adding routing hints");

    // create lsp routing hints
    var lspHop = RouteHintHop(
      srcNodeId: _currentLSP!.pubKey,
      shortChannelId: shortChannelId,
      feesBaseMsat: _currentLSP!.baseFeeMsat,
      feesProportionalMillionths: 0,
      cltvExpiryDelta: _currentLSP!.timeLockDelta,
      htlcMinimumMsat: _currentLSP!.minHtlcMsat,
      htlcMaximumMsat: 1000000000,
    );

    // inject routing hints and sign the new invoice
    var routingHints = RouteHint(field0: List.from([lspHop]));

    final bolt11WithHints = await _signer!.addRoutingHints(invoice: invoice.bolt11, hints: [routingHints], newAmount: amountSats.toInt() * 1000);
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

  Future<LNURLPayResult> getPaymentResult(LNURLPayParams payParams, Map<String, String> qParams) async {
    /*
     5. LN WALLET makes a GET request using
        <callback><?|&>amount=<milliSatoshi>
        amount being the amount specified by the user in millisatoshis.
   */
    Uri uri = Uri.parse(payParams.callback).replace(queryParameters: qParams);
    var response = await http.get(uri).timeout(const Duration(seconds: 60));
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to call ${payParams.domain} API');
    }
    /*
   6. LN Service takes the GET request and returns JSON response of form:
      {
        pr: string, // bech32-serialized lightning invoice
        routes: [] // an empty array
        "successAction": Object (optional)
      }
      or
      {"status":"ERROR", "reason":"error details..."}
  */
    Map<String, dynamic> parsedJson = json.decode(response.body);
    if (parsedJson['status'] == 'ERROR') {
      throw Exception(parsedJson['reason']);
    }
    return LNURLPayResult.fromJson(parsedJson);
  }

  Future<Withdrawal> sweepAllCoinsTransactions(String address, TransactionCostSpeed speed) {
    final feerate = speed == TransactionCostSpeed.priority
        ? greenlight.FeeratePreset.URGENT
        : speed == TransactionCostSpeed.economy
            ? greenlight.FeeratePreset.SLOW
            : greenlight.FeeratePreset.NORMAL;
    return _nodeAPI.sweepAllCoinsTransactions(address, feerate);
  }
}

enum NodeStatus { connecting, connected, disconnecting, disconnected }

class NodeState {
  final String id;
  final Int64 blockheight;
  final Int64 channelsBalanceMsats;
  final Int64 onchainBalanceMsats;
  final NodeStatus status;
  final Int64 maxAllowedToPayMsats;
  final Int64 maxAllowedToReceiveMsats;
  final Int64 maxPaymentAmountMsats;
  final Int64 maxChanReserveMsats;
  final List<String> connectedPeers;
  final Int64 maxInboundLiquidityMsats;
  final Int64 onChainFeeRate;

  NodeState(
      {required this.id,
      required this.blockheight,
      required this.channelsBalanceMsats,
      required this.onchainBalanceMsats,
      required this.status,
      required this.maxAllowedToPayMsats,
      required this.maxAllowedToReceiveMsats,
      required this.maxPaymentAmountMsats,
      required this.maxChanReserveMsats,
      required this.connectedPeers,
      required this.maxInboundLiquidityMsats,
      required this.onChainFeeRate});
}

NodeState _assembleAccountState(
    NodeInfo nodeInfo, List<ListFundsChannel> offChainFunds, List<ListFundsOutput> onChainFunds, List<Peer> peers) {
  var channelsBalance = offChainFunds.fold<Int64>(Int64(0), (balance, element) => balance + element.ourAmountMsat);

  // calculate the on-chain balance
  var walletBalance = onChainFunds.fold<Int64>(Int64(0), (balance, element) => balance + element.amountMsats);

  // assemble the peers list and channels list.
  var channels = List<Channel>.empty(growable: true);
  List<String> peersList = List<String>.empty(growable: true);
  for (var p in peers) {
    peersList.add(p.id);
    channels.addAll(p.channels);
  }

  // calculate the account status based on the channels status.
  bool hasActive = channels.any((c) => c.state == ChannelState.OPEN);
  bool hasPendingOpen = channels.any((c) => c.state == ChannelState.PENDING_OPEN);
  bool hasPendingClose = channels.any((c) => c.state == ChannelState.PENDING_CLOSED);

  NodeStatus accStatus = NodeStatus.disconnected;
  if (hasActive) {
    accStatus = NodeStatus.connected;
  } else if (hasPendingOpen) {
    accStatus = NodeStatus.connecting;
  } else if (hasPendingClose) {
    accStatus = NodeStatus.disconnecting;
  }

  // calculate incoming and outgoing liquidity
  Int64 maxPayable = Int64(0);  
  Int64 maxReceivableSingleChannel = Int64(0);
  for (var c in channels) {
    maxPayable += c.spendable;
    Int64 channelReceivable = Int64(c.receivable);
    if (channelReceivable > maxReceivableSingleChannel) {
      maxReceivableSingleChannel = channelReceivable;
    }    
  }

  final maxAllowedToReceiveMsats = max(maxInboundLiquidityMsats - channelsBalance.toInt(), 0);

  // return the new account state
  return NodeState(
    blockheight: Int64(nodeInfo.blockheight),
    id: nodeInfo.nodeID,
    channelsBalanceMsats: channelsBalance,
    onchainBalanceMsats: walletBalance,
    status: accStatus,
    maxAllowedToPayMsats: maxPayable,
    maxAllowedToReceiveMsats: Int64(maxAllowedToReceiveMsats),
    maxPaymentAmountMsats: Int64(_maxPaymentAmountMsats),
    maxChanReserveMsats: channelsBalance - maxPayable,
    connectedPeers: peersList,
    onChainFeeRate: Int64(0),
    maxInboundLiquidityMsats: maxReceivableSingleChannel,
  );
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
