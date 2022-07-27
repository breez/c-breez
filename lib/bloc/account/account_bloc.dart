import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:breez_sdk/sdk.dart' as lntoolkit;
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/account/account_state_assembler.dart';
import 'package:c_breez/bloc/account/models_extensions.dart';
import 'package:c_breez/bloc/account/payment_error.dart';
import 'package:c_breez/models/invoice.dart';
import 'package:c_breez/models/payment_filter.dart';
import 'package:c_breez/models/payment_info.dart';
import 'package:c_breez/models/payment_type.dart';
import 'package:c_breez/repositories/app_storage.dart';
import 'package:c_breez/repositories/dao/db.dart' as db;
import 'package:c_breez/services/keychain.dart';
import 'package:dart_lnurl/dart_lnurl.dart';
import 'package:drift/drift.dart';
import 'package:fimber/fimber.dart';
import 'package:fixnum/fixnum.dart';
import 'package:hex/hex.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

const maxPaymentAmount = 4294967;

// AccountBloc is the business logic unit that is responsible to communicating with the lightning service
// and reflect the node state. It is responsible for:
// 1. Synchronizing with the node state.
// 2. Abstracting actions exposed by the lightning service.
// 3. Managing user keys.
class AccountBloc extends Cubit<AccountState> with HydratedMixin {
  static const String paymentFilterSettingsKey = "payment_filter_settings";
  static const String accountCredsKey = "account_creds_key";
  static const String accountSeedKey = "account_seed_key";
  static const int defaultInvoiceExpiry = Duration.secondsPerHour;

  final _log = FimberLog("AccountBloc");
  final AppStorage _appStorage;
  final lntoolkit.LightningNode _lightningNode;
  final lntoolkit.LNURLService _lnurlService;
  final KeyChain _keyChain;
  bool started = false;
  lntoolkit.Signer? _signer;

  AccountBloc(
      this._lightningNode, this._lnurlService, this._appStorage, this._keyChain)
      : super(AccountState.initial()) {
    // emit on every change
    _watchAccountChanges().listen((acc) {
      emit(acc);
    });

    // sync node info on incoming payments
    final nodeAPI = _lightningNode.getNodeAPI();
    nodeAPI.incomingPaymentsStream().listen((event) {
      syncStateWithNode();
    });

    if (!state.initial) {
      _keyChain.read(accountCredsKey).then((credsHEX) async {
        if (credsHEX != null) {
          var creds = HEX.decode(credsHEX);
          _log.v("found account credentials: ${String.fromCharCodes(creds)}");

          // temporary fix for older versions that didn't save the seed in keychain
          final nodeCreds = lntoolkit.NodeCredentials.fromBuffer(creds);
          await _keyChain.write(accountSeedKey, HEX.encode(nodeCreds.secret!));

          // create signer
          final seedHex = await _keyChain.read(accountSeedKey);          
          await _createSignerFromSeed(Uint8List.fromList(HEX.decode(seedHex!)));         

          // init service with credentials
          _lightningNode.connectWithCredentials(creds, _signer!);
          _startNode();
        }
      });
    }
  }  

  // Export the user keys to a file
  Future exportKeyFiles(Directory destDir) async {
    var keys = await _lightningNode.getNodeAPI().exportKeys();
    for (var k in keys) {
      File(p.join(destDir.path, k.name)).writeAsBytesSync(k.content, flush: true);
    }
  }

  // startNewNode register a new node and start it
  Future<List<int>> startNewNode(Uint8List seed, {String network = "bitcoin", String email = ""}) async {
    if (started) {
      throw Exception("Node already started");
    }
    await _createSignerFromSeed(seed);
    var creds = await _lightningNode.newNodeFromSeed(seed, _signer!);
    _log.i("node registered successfully");
    await _keyChain.write(accountSeedKey,HEX.encode(seed));
    await _keyChain.write(accountCredsKey, HEX.encode(creds));
    emit(state.copyWith(initial: false));
    await _startNode();
    _log.i("new node started");
    return creds;
  }

  // recoverNode recovers a node from seed
  Future<List<int>> recoverNode(Uint8List seed) async {
    if (started) {
      throw Exception("Node already started");
    }
    await _createSignerFromSeed(seed);
    var creds = await _lightningNode.connectWithSeed(seed, _signer!);
    await _keyChain.write(accountCredsKey, HEX.encode(creds));
    await _startNode();
    return creds;
  }

  Future _startNode() async {    
    await syncStateWithNode();
    started = true;
  }

  // syncStateWithNode synchronized the node state with the local state.
  // This is required to assemble the account state (e.g liquidity, connected, etc...)
  Future syncStateWithNode() async {        
    await _syncNodeState();
    await _syncPeers();
    await _syncOutgoingPayments();
    await _syncSettledInvoices();
  }

  Future<bool> processLNURLWithdraw(
      LNURLWithdrawParams withdrawParams, Map<String, String> qParams) async {
    bool isSent = await _lnurlService
        .processWithdrawRequest(withdrawParams, qParams)
        .timeout(
          const Duration(minutes: 3),
          onTimeout: () =>
              throw Exception('Timed out waiting 3 minutes for payment.'),
        );
    await syncStateWithNode();
    return isSent;
  }

  Future<LNURLPayResult> sendLNURLPayment(LNURLPayParams payParams,
      Map<String, String> qParams) async {
    final LNURLPayResult lnurlPayResult =
        await _lnurlService.getPaymentResult(payParams, qParams);
    await _lightningNode
        .sendPaymentForRequest(lnurlPayResult.pr,
            amount: Int64.parseInt(qParams['amount']!))
        .timeout(
          const Duration(minutes: 3),
          onTimeout: () =>
              throw Exception('Timed out waiting 3 minutes for payment.'),
        );
    await syncStateWithNode();
    return lnurlPayResult;
  }

  Future sendPayment(String bolt11, Int64 amountSat) async {
    await _lightningNode.sendPaymentForRequest(bolt11, amount: amountSat);
    await syncStateWithNode();
  }

  Future cancelPayment(String bolt11) async {
    throw Exception("not implemented");
  }

  Future sendSpontaneousPayment(String nodeID, String description, Int64 amountSat) async {
    await _lightningNode.getNodeAPI().sendSpontaneousPayment(nodeID, amountSat, description);
    await syncStateWithNode();
  }

  Future publishTransaction(List<int> tx) async {
    await _lightningNode.getNodeAPI().publishTransaction(tx);
  }

  bool validateAddress(String? address) {
    if (address == null) return false;
    // TODO real impl. Random next bool is used to simulate valid/invalid flow
    return Random().nextBool();
  }

  // validatePayment is used to validate that outgoing/incoming payments meet the liquidity
  // constraints.
  void validatePayment(
    Int64 amount,
    bool outgoing, {
    Int64? channelMinimumFee,
  }) {
    var accState = state;
    if (amount > accState.maxPaymentAmount) {
      throw PaymentExceededLimitError(accState.maxPaymentAmount);
    }

    if (!outgoing) {
      if (channelMinimumFee != null &&
          (amount > accState.maxInboundLiquidity &&
              amount <= channelMinimumFee)) {
        throw PaymentBelowSetupFeesError(channelMinimumFee);
      }
      if (amount > accState.maxAllowedToReceive) {
        throw PaymentExceededLimitError(accState.maxAllowedToReceive);
      }
    }

    if (outgoing && amount > accState.maxAllowedToPay) {
      if (accState.reserveAmount > 0) {
        throw PaymentBelowReserveError(accState.reserveAmount);
      }
      throw PaymentBelowReserveError(accState.reserveAmount);
    }
  }

  void changePaymentFilter(PaymentFilterModel filter) {
    _appStorage.updateSettings(paymentFilterSettingsKey, json.encode(filter.toJson()));
  }

  Future<Invoice> addInvoice(
      {String payeeName = "", String description = "", String logo = "", required Int64 amount, Int64? expiry}) async {
    var invoice = await _lightningNode.requestPayment(amount, description: description, expiry: expiry ?? Int64(defaultInvoiceExpiry));    
    syncStateWithNode();

    return Invoice(
        paymentHash: invoice.paymentHash,
        amountMsat: invoice.amountMsats.toInt(),
        bolt11: invoice.bolt11,
        description: invoice.description,
        expiry: expiry?.toInt() ?? defaultInvoiceExpiry);
  }

  // _watchAccountChanges listens to every change in the local storage and assemble a new account state accordingly
  Stream<AccountState> _watchAccountChanges() {
    return Rx.combineLatest3<List<PaymentInfo>, PaymentFilterModel, db.NodeState?,
            AccountState>(
        _paymentsStream(),
        _paymentsFilterStream(),
        _appStorage.watchNodeState(),        
        (payments, paymentsFilter, nodeInfo) {
      return assembleAccountState(payments, paymentsFilter, nodeInfo) ?? state;
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
    var outgoingPaymentsStream = _appStorage.watchOutgoingPayments().map((pList) {
      return true;
    });

    // incoming payments stream (settled invoices)
    var incomingPaymentsStream = _appStorage.watchIncomingPayments().map((iList) {
      return true;
    });
    return Rx.merge([outgoingPaymentsStream, incomingPaymentsStream]).asyncMap((e) async {
      var outgoing = await _appStorage.listOutgoingPayments();
      var outgoingList = outgoing.map((p) {
        return PaymentInfo(
            type: PaymentType.sent,
            amountMsat: Int64(p.amountMsats),
            destination: p.destination,
            shortTitle: "",
            feeMsat: Int64(p.feeMsat),
            creationTimestamp: Int64(p.createdAt),
            pending: p.pending,
            keySend: p.isKeySend,
            paymentHash: p.paymentHash);
      });

      var incoming = await _appStorage.listIncomingPayments();
      var incomingList = incoming.map((invoice) {
        return PaymentInfo(
            type: PaymentType.received,
            amountMsat: Int64(invoice.amountMsat),
            feeMsat: Int64.ZERO,
            destination: state.id!,
            shortTitle: "",
            creationTimestamp: Int64(invoice.paymentTime),
            pending: false,
            keySend: false,
            paymentHash: invoice.paymentHash);
      });

      return incomingList.toList()
        ..addAll(outgoingList)
        ..sort((p1, p2) => (p2.creationTimestamp - p1.creationTimestamp).toInt());
    });
  }

  Future _syncNodeState() async {
    _log.i("_syncNodeState started");
    await _appStorage.setNodeState((await _lightningNode.getState()).toDbNodeState());
    _log.i("_syncNodeState finished");
  }

  Future _syncPeers() async {
    _log.i("_syncPeers started");
    var peers = (await _lightningNode.getNodeAPI().listPeers()).map((p) => p.toDbPeer()).toList();
    await _appStorage.setPeers(peers);
    _log.i("_syncPeers finished");
  }

  Future _syncOutgoingPayments() async {
    _log.i("_syncOutgoingPayments");
    var outgoingPayments = await _lightningNode.getNodeAPI().getPayments();
    await _appStorage.addOutgoingPayments(outgoingPayments.map((p) => p.toDbOutgoingLightningPayment()).toList());
    _log.i("_syncOutgoingPayments finished");
  }

  Future _syncSettledInvoices() async {
    _log.i("_syncSettledInvoices started");
    var invoices = await _lightningNode.getNodeAPI().getInvoices();
    await _appStorage.addIncomingPayments(invoices.map((p) => p.toDbInvoice()).toList());
    _log.i("_syncSettledInvoices finished");
  }

  @override
  AccountState? fromJson(Map<String, dynamic> json) {
    return AccountState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(AccountState state) {
    return state.toJson();
  }

  Future _createSignerFromSeed(Uint8List seed) async {
    final docDir = await getApplicationDocumentsDirectory();
    final signerDir = Directory("${docDir.path}/signer");
    await signerDir.create(recursive: true);
    _signer = lntoolkit.Signer(seed, signerDir.path);
  }
}
