import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:c_breez/bloc/account/models_extensions.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/logger.dart';
import 'package:c_breez/models/account.dart';
import 'package:c_breez/repositorires/dao/db.dart' as db;
import 'package:c_breez/repositorires/app_storage.dart';
import 'package:c_breez/services/keychain.dart';
import 'package:c_breez/services/lightning/interface.dart';
import 'package:drift/drift.dart';
import 'package:fixnum/fixnum.dart';
import 'package:hex/hex.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:lightning_toolkit/impl.dart' as lntoolkit;
import 'package:lightning_toolkit/signer.dart';
import 'package:path/path.dart' as p;
import 'package:rxdart/rxdart.dart';
import './account_state.dart';
import 'account_state_assembler.dart';

const maxPaymentAmount = 4294967;

// AccountBloc is the business logic unit that is responsible to communicating with the lightning service
// and reflect the node state. It is responsible for:
// 1. Synchronizing with the node state.
// 2. Abstracting actions exposed by the lightning service.
// 3. Managing user keys.
class AccountBloc extends Cubit<AccountState> with HydratedMixin {
  static const String paymentFilterSettingsKey = "payment_filter_settings";
  static const String accountCredsKey = "account_creds_key";
  static const int defaultInvoiceExpiry = Duration.secondsPerHour;
  
  final AppStorage _appStorage;
  final LightningService _breezLib;  
  final KeyChain _keyChain;
  final LSPBloc _lspBloc;
  bool started = false;  
  Signer? _signer;

  AccountBloc(this._breezLib, this._appStorage, this._keyChain, this._lspBloc)
      : super(AccountState.initial()) {

    // emit on every change
    _watchAccountChanges().listen((acc) {
      emit(acc);
    });

    // sync node info on incoming payments
    _breezLib.waitReady().then((value) {
      _breezLib.incomingPaymentsStream().listen((event) {
        syncStateWithNode();
      });
    });

    if (!state.initial) {
      _keyChain.read(accountCredsKey).then((credsHEX) {
        if (credsHEX != null) {
          var creds = HEX.decode(credsHEX);
          log.info("found account credentials: ${String.fromCharCodes(creds)}");
          _breezLib.initWithCredentials(creds);
          _startNode();
        }
      });
    }
  }

  // Export the user keys to a file
  Future exportKeyFiles(Directory destDir) async {
    var keys = await _breezLib.exportKeys();
    for (var k in keys) {
      File(p.join(destDir.path, k.name)).writeAsBytesSync(k.content, flush: true);
    }
  }

  // initiWithCredentials initialized the lightning service with credentials that identify the node.
  void initiWithCredentials(List<int> creds) {
    _breezLib.initWithCredentials(creds);
  }

  // startNewNode register a new node and start it
  Future<List<int>> startNewNode(Uint8List seed, {String network = "bitcoin", String email = ""}) async {
    if (started) {
      throw Exception("Node already started");
    }
    var creds = await _breezLib.register(seed, email: email, network: network);
    log.info("node registered succesfully");
    await _keyChain.write(accountCredsKey, HEX.encode(creds));
    emit(state.copyWith(initial: false));
    await _startNode();
    log.info("new node started");
    return creds;
  }

  // recoverNode recovers a node from seed
  Future<List<int>> recoverNode(Uint8List seed) async {
    if (started) {
      throw Exception("Node already started");
    }
    var creds = await _breezLib.recover(seed);
    await _keyChain.write(accountCredsKey, HEX.encode(creds));
    await _startNode();
    return creds;
  }

  Future _startNode() async {
    await _breezLib.startNode();
    await syncStateWithNode();
    started = true;
  }

  // syncStateWithNode synchronized the node state with the local state.
  // This is required to assemble the account state (e.g liquidity, connected, etc...)
  Future syncStateWithNode() async {
    await _syncNodeInfo();
    await _syncPeers();
    await _syncFunds();
    await _syncOutgoingPayments();
    await _syncSettledInvoices();
  }

  Future sendPayment(String bolt11, Int64 amountSat) async {
    await _breezLib.sendPaymentForRequest(bolt11, amount: amountSat);
    await syncStateWithNode();
  }

  Future cancelPayment(String bolt11) async {
    throw Exception("not implemented");
  }

  Future sendSpontaneousPayment(String nodeID, String description, Int64 amountSat) async {
    await _breezLib.sendSpontaneousPayment(nodeID, amountSat, description);
    await syncStateWithNode();
  }

  Future<Withdrawal> sweepAllCoins(String address) async {
    var w = await _breezLib.sweepAllCoinsTransactions(address);
    await syncStateWithNode();
    return Withdrawal(w.txid, w.tx);
  }

  Future publishTransaction(List<int> tx) async {
    await _breezLib.publishTransaction(tx);
  }

  Future<bool> validateAddress(String address) {
    throw Exception("not implemented");
  }

  // validatePayment is used to validate that outgoing/incoming payments meet the liquidity
  // constraints.
  void validatePayment(Int64 amount, bool outgoing) {
    var accState = state;
    if (amount > accState.maxPaymentAmount) {
      throw PaymentExceededLimitError(accState.maxPaymentAmount);
    }

    if (!outgoing && amount > accState.maxAllowedToReceive) {
      throw PaymentExceededLimitError(accState.maxAllowedToReceive);
    }

    if (outgoing && amount > accState.maxAllowedToPay) {
      if (accState.reserveAmount > 0) {
        throw PaymentBellowReserveError(accState.reserveAmount);
      }
      throw PaymentBellowReserveError(accState.reserveAmount);
    }
  }

  void changePaymentFilter(PaymentFilterModel filter) {
    _appStorage.updateSettings(paymentFilterSettingsKey, json.encode(filter.toJson()));
  }

  Future<Invoice> addInvoice(
      {String payeeName = "", String description = "", String logo = "", required Int64 amount, Int64? expiry}) async {
    var invoice = await _breezLib.addInvoice(amount, description: description, expiry: expiry ?? Int64(defaultInvoiceExpiry));    
    var currentLSP = _lspBloc.state.currentLSP;
    if (currentLSP == null) {
      throw Exception("LSP is not available");
    }

    // parse the lsp short channel id
    var peers = await _appStorage.watchPeers().first;
    int shortChannelId = 0;
    for (var p in peers) {
      if (p.peer.peerId == currentLSP.pubKey && p.channels.first.shortChannelId != null) {        
        shortChannelId = _parseShortChannelID(p.channels.first.shortChannelId!);
        break;
      }
    }

    // create lsp routing hints
    var lspHop = lntoolkit.RouteHintHop(
      srcNodeId: currentLSP.pubKey,
      shortChannelId: shortChannelId,
      feesBaseMsat: currentLSP.baseFeeMsat,
      feesProportionalMillionths: 0,
      cltvExpiryDelta: 40,
      htlcMinimumMsat: currentLSP.minHtlcMsat,
      htlcMaximumMsat: 1000000000,
    );

    // inject routing hints and sign the new invoice
    var routingHints = lntoolkit.RouteHint(field0: List.from([lspHop]));
    final bolt11 = await _signer!.addRoutingHints(
        invoice: invoice.bolt11, hints: [routingHints]);

    syncStateWithNode();

    return Invoice(
        paymentHash: invoice.paymentHash,
        amount: invoice.amountSats.toInt(),
        bolt11: bolt11,
        description: invoice.description,
        expiry: expiry?.toInt() ?? defaultInvoiceExpiry);
  }

  // _watchAccountChanges listens to every change in the local storage and assemble a new account state accordingly
  Stream<AccountState> _watchAccountChanges() {
    return Rx.combineLatest6<List<PaymentInfo>, PaymentFilterModel, db.NodeInfo?, List<db.OffChainFund>, List<db.OnChainFund>,
            List<db.PeerWithChannels>, AccountState>(
        _paymentsStream(),
        _paymentsFilterStream(),
        _appStorage.watchNodeInfo(),
        _appStorage.watchOffchainFunds(),
        _appStorage.watchOnchainFunds(),
        _appStorage.watchPeers(), (payments, paymentsFilter, nodeInfo, offChainFunds, onChainFunds, peers) {
      return assembleAccountState(payments, paymentsFilter, nodeInfo, offChainFunds, onChainFunds, peers) ?? state;
    });
  }

  Stream<PaymentFilterModel> _paymentsFilterStream() {
    return _appStorage
        .watchSetting(paymentFilterSettingsKey)
        .map((filter) => filter == null ? PaymentFilterModel.initial() : PaymentFilterModel.fromJson(json.decode(filter.value)));
  }

  // _paymentsStream subscribes to local storage changes and exposes a stream of both incoming and outgoing payments.
  Stream<List<PaymentInfo>> _paymentsStream() {
    // outgoing payments stream
    var outgoingPaymentsStream = _appStorage.watchOutgoingPayments().map((pList) => pList.map((p) {
          return PaymentInfo(
              type: PaymentType.SENT,
              amountMsat: Int64(p.amount),
              destination: p.destination,
              shortTitle: "",
              fee: Int64(p.feeMsat),
              creationTimestamp: Int64(p.createdAt),
              pending: p.pending,
              keySend: p.isKeySend,
              paymentHash: p.paymentHash);
        }));

    // incoming payments stream (settled invoices)
    var incomingPaymentsStream = _appStorage.watchIncomingPayments().map((iList) => iList.map((invoice) {
          return PaymentInfo(
              type: PaymentType.RECEIVED,
              amountMsat: Int64(invoice.amountMsat),
              fee: Int64.ZERO,
              destination: state.id!,
              shortTitle: "",
              creationTimestamp: Int64(invoice.paymentTime),
              pending: false,
              keySend: false,
              paymentHash: invoice.paymentHash);
        }));

    return Rx.merge([outgoingPaymentsStream, incomingPaymentsStream])
        .map((payments) => payments.toList()..sort((p1, p2) => (p2.creationTimestamp - p1.creationTimestamp).toInt()));
  }

  Future _syncNodeInfo() async {
    log.info("_syncNodeInfo started");
    await _appStorage.setNodeInfo((await _breezLib.getNodeInfo()).toDbNodeInfo());
    log.info("_syncNodeInfo finished");
  }

  Future _syncPeers() async {
    log.info("_syncPeers started");
    var peers = (await _breezLib.listPeers()).map((p) => p.toDbPeer()).toList();
    await _appStorage.setPeers(peers);
    log.info("_syncPeers finished");
  }

  Future _syncFunds() async {
    log.info("_syncFunds started");
    var funds = await _breezLib.listFunds();
    await _appStorage.setOffchainFunds(funds.channelFunds.map((f) => f.toDbOffchainFund()).toList());
    await _appStorage.setOnchainFunds(funds.onchainFunds.map((f) => f.toDbOnchainFund()).toList());
    log.info("_syncFunds finished");
  }

  Future _syncOutgoingPayments() async {
    log.info("_syncOutgoingPayments");
    var outgoingPayments = await _breezLib.getPayments();
    await _appStorage.addOutgoingPayments(outgoingPayments.map((p) => p.toDbOutgoingLightningPayment()).toList());
    log.info("_syncOutgoingPayments finished");
  }

  Future _syncSettledInvoices() async {
    log.info("_syncSettledInvoices started");
    var invoices = await _breezLib.getInvoices();
    await _appStorage.addIncomingPayments(invoices.map((p) => p.toDbInvoice()).toList());
    log.info("_syncSettledInvoices finished");
  }

  @override
  AccountState? fromJson(Map<String, dynamic> json) {
    return AccountState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(AccountState state) {
    return state.toJson();
  }
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
