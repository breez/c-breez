import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:c_breez/bloc/account/models_extensions.dart';
import 'package:c_breez/logger.dart';
import 'package:c_breez/models/account.dart';
import 'package:c_breez/models/bolt11.dart';
import 'package:c_breez/repositorires/dao/db.dart' as db;
import 'package:c_breez/repositorires/app_storage.dart';
import 'package:c_breez/services/keychain.dart';
import 'package:c_breez/services/lightning/interface.dart';
import 'package:drift/drift.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hex/hex.dart';
import 'package:path/path.dart' as p;
import 'package:rxdart/rxdart.dart';
import './account_state.dart';

const MAX_PAYMENT_AMOUNT = 4294967;

class AccountBloc extends Cubit<AccountState> {
  static const String PAYMENT_FILTER_SETTINGS_PREFERENCES_KEY = "payment_filter_settings";
  static const String ACCOUNT_KEY = "account_key";
  static const String ACCOUNT_CREDS_KEY = "account_creds_key";
  static const int defaultInvoiceExpiry = Duration.secondsPerHour;

  final AppStorage _appStorage;
  final LightningService _breezLib;
  final KeyChain _keyChain;
  bool started = false;

  AccountBloc(this._breezLib, this._appStorage, this._keyChain) : super(AccountState.initial()) {
    _watchAccountChanges().listen((acc) {
      emit(acc);
    });    
    _keyChain.read(ACCOUNT_CREDS_KEY).then((credsHEX) {
      if (credsHEX != null) {
        log.info("found account credentials");        
        var creds = HEX.decode(credsHEX);
        var c = String.fromCharCodes(creds);        
        _breezLib.initWithCredentials(creds);
        _startNode();
      }
    });
  }

  Future exportKeyFiles(Directory destDir) async {
    var keys = await _breezLib.exportKeys();
    for (var k in keys) {
      File(p.join(destDir.path, k.name)).writeAsBytesSync(k.content, flush: true);
    }
  }

  void initiWithCredentials(List<int> creds) {
    _breezLib.initWithCredentials(creds);
  }

  Future<List<int>> startNewNode(Uint8List seed, {String network = "bitcoin", String email = ""}) async {
    if (started) {
      throw Exception("Node already started");
    }
    var creds = await _breezLib.register(seed, email: email, network: network);    
    log.info("node registered succesfully");
    await _keyChain.write(ACCOUNT_CREDS_KEY, HEX.encode(creds));
    await _startNode();
    log.info("new node started");
    return creds;
  }

  Future<List<int>> recoverNode(Uint8List seed) async {
    if (started) {
      throw Exception("Node already started");
    }
    var creds = await _breezLib.recover(seed);
    await _keyChain.write(ACCOUNT_CREDS_KEY, HEX.encode(creds));
    await _startNode();
    return creds;
  }

  Future _startNode() async {
    await _breezLib.startNode();
    await syncStateWithNode();
    started = true;
  }

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
    _appStorage.updateSettings(PAYMENT_FILTER_SETTINGS_PREFERENCES_KEY, json.encode(filter.toJson()));
  }

  Future<Invoice> addInvoice(
      {String payeeName = "", String description = "", String logo = "", required Int64 amount, Int64? expiry}) async {    
    var invoice = await _breezLib.addInvoice(amount, description: description, expiry: expiry ?? Int64(defaultInvoiceExpiry));
    await syncStateWithNode();
    return Invoice(amount: invoice.amountSats, bolt11: invoice.bolt11, description: invoice.description, expiry: expiry ?? Int64(defaultInvoiceExpiry));
  }

  Stream<AccountState> _watchAccountChanges() {    
    return Rx.combineLatest6<List<PaymentInfo>, PaymentFilterModel, db.NodeInfo?, List<db.OffChainFund>, List<db.OnChainFund>,
            List<db.PeerWithChannels>, AccountState>(
        _paymentsStream(),
        _paymentsFilterStream(),
        _appStorage.watchNodeInfo(),
        _appStorage.watchOffchainFunds(),
        _appStorage.watchOnchainFunds(),
        _appStorage.watchPeers(), (payments, paymentsFilter, nodeInfo, offChainFunds, onChainFunds, peers) {
      return _assembleAccountState(payments, paymentsFilter, nodeInfo, offChainFunds, onChainFunds, peers);
    });
  }

  AccountState _assembleAccountState(List<PaymentInfo> payments, PaymentFilterModel paymentsFilter, db.NodeInfo? nodeInfo,
      List<db.OffChainFund> offChainFunds, List<db.OnChainFund> onChainFunds, List<db.PeerWithChannels> peers) {
    var channelsBalance = offChainFunds.fold<Int64>(Int64(0), (balance, element) => balance + element.ourAmountMsat) ~/ 1000;

    var walletBalance = onChainFunds.fold<Int64>(Int64(0), (balance, element) => balance + element.amountMsat) ~/ 1000;

    var channels = List<db.Channel>.empty(growable: true);
    List<String> peersList = List<String>.empty(growable: true);
    for (var p in peers) {
      peersList.add(p.peer.peerId);
      channels.addAll(p.channels);
    }
    bool hasActive = channels.any((c) => c.channelState == db.ChannelState.OPEN.index);
    bool hasPendingOpen = channels.any((c) => c.channelState == db.ChannelState.PENDING_OPEN.index);
    bool hasPendingClose = channels.any((c) => c.channelState == db.ChannelState.PENDING_CLOSED.index);

    AccountStatus accStatus = AccountStatus.DISCONNECTED;
    if (hasActive) {
      accStatus = AccountStatus.CONNECTED;
    } else if (hasPendingOpen) {
      accStatus = AccountStatus.CONNECTING;
    } else if (hasPendingClose) {
      accStatus = AccountStatus.DISCONNECTION;
    }

    Int64 maxPayable = Int64(0);
    Int64 maxReceivable = Int64(0);
    Int64 maxReceivableSingleChannel = Int64(0);
    for (var c in channels) {
      maxPayable += c.spendableMsat ~/ 1000;
      Int64 channelReceivable = Int64(c.receivableMsat ~/ 1000);
      if (channelReceivable > maxReceivableSingleChannel) {
        maxReceivableSingleChannel = channelReceivable;
      }
      maxReceivable += channelReceivable;
    }

    if (nodeInfo == null) {
      var s =  state.copyWith(initial: false);
      return s;
    }
    return AccountState(
      initial: false,
      blockheight: Int64(nodeInfo.node.blockheight),
      id: nodeInfo.node.nodeID,
      balance: channelsBalance,
      walletBalance: walletBalance,
      status: accStatus,
      maxAllowedToPay: maxPayable,
      maxAllowedToReceive: maxReceivable,
      maxPaymentAmount: Int64(MAX_PAYMENT_AMOUNT),
      maxChanReserve: channelsBalance - maxPayable,
      connectedPeers: peersList,
      onChainFeeRate: Int64(0),
      maxInboundLiquidity: maxReceivableSingleChannel,
      payments: PaymentsState(payments, _filterPayments(payments, paymentsFilter), paymentsFilter, null),
    );
  }

  Stream<PaymentFilterModel> _paymentsFilterStream() {
    return _appStorage
        .watchSetting(PAYMENT_FILTER_SETTINGS_PREFERENCES_KEY)
        .map((filter) => filter == null ? PaymentFilterModel.initial() : PaymentFilterModel.fromJson(json.decode(filter.value)));
  }

  Stream<List<PaymentInfo>> _paymentsStream() {
    var outgoingPaymentsStream = _appStorage.watchOutgoingPayments().map((pList) => pList.map((p) {
      var bolt11 = Bolt11.fromPaymentRequest(p.bolt11);
      return PaymentInfo(
        type: PaymentType.SENT,
        amountMsat: Int64(p.amount),
        destination: p.destination,
        shortTitle: bolt11.description,
        fee: Int64(p.feeMsat),
        creationTimestamp: Int64(p.createdAt),
        pending: p.pending,
        keySend: p.isKeySend,
        paymentHash: p.paymentHash);
    }));

    var incomingPaymentsStream = _appStorage.watchIncomingPayments().map((iList) => iList.map((invoice){ 
      var bolt11 = Bolt11.fromPaymentRequest(invoice.bolt11);
      return PaymentInfo(
        type: PaymentType.RECEIVED,
        amountMsat: Int64(invoice.amountMsat),
        fee: Int64.ZERO,      
        destination: state.id!,
        shortTitle: bolt11.description,
        creationTimestamp: Int64(invoice.paymentTime),
        pending: false,
        keySend: false,
        paymentHash: invoice.paymentHash);
        }));

    return Rx.merge([outgoingPaymentsStream, incomingPaymentsStream])
        .map((payments) => payments.toList()..sort((p1, p2) => (p1.creationTimestamp - p2.creationTimestamp).toInt()));
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
}

List<PaymentInfo> _filterPayments(List<PaymentInfo> paymentsList, PaymentFilterModel filter) {  
  return paymentsList
      .where((p){
        if (!filter.paymentType.contains(p.type)) {
          return false;
        }
        if (filter.startDate != null && p.creationTimestamp.toInt() * 1000 < filter.startDate!.millisecondsSinceEpoch) {
          return false;
        }
        if (filter.endDate != null && p.creationTimestamp.toInt() * 1000 > filter.endDate!.millisecondsSinceEpoch) {
          return false;
        }
        return true;
      })
      .toList();
}
