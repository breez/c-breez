import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:breez_sdk/breez_bridge.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/account/payment_error.dart';
import 'package:c_breez/bloc/account/payment_result_data.dart';
import 'package:c_breez/services/keychain.dart';
import 'package:dart_lnurl/dart_lnurl.dart';
import 'package:drift/drift.dart';
import 'package:fimber/fimber.dart';
import 'package:hex/hex.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path/path.dart' as p;

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
  final BreezBridge _breezLib;
  final KeyChain _keyChain;
  bool started = false;

  AccountBloc(this._breezLib, this._keyChain) : super(AccountState.initial()) {
    // emit on every change
    _watchAccountChanges().listen((acc) {
      emit(acc);
    });

    // TODO: sync node info on incoming payments

    if (!state.initial) {
      throw Exception("not implemented");
    }
  }

  // TODO: Export the user keys to a file
  Future exportKeyFiles(Directory destDir) async {
    throw Exception("not implemented");
  }

  void recursiveFolderCopySync(String path1, String path2) {
    Directory dir1 = Directory(path1);
    Directory dir2 = Directory(path2);
    if (!dir2.existsSync()) {
      dir2.createSync(recursive: true);
    }

    dir1.listSync().forEach((element) {
      String elementName = p.basename(element.path);
      String newPath = "${dir2.path}/$elementName";
      if (element is File) {
        File newFile = File(newPath);
        newFile.writeAsBytesSync(element.readAsBytesSync());
      } else {
        recursiveFolderCopySync(element.path, newPath);
      }
    });
  }

  // startNewNode register a new node and start it
  Future<GreenlightCredentials> startNewNode(
      {Network network = Network.Bitcoin, required Uint8List seed}) async {
    if (started) {
      throw Exception("Node already started");
    }
    final GreenlightCredentials creds =
        await _breezLib.registerNode(network: network, seed: seed);
    _log.i("node registered successfully");
    await _storeCredentials(creds);
    emit(state.copyWith(initial: false));
    await _startNode();
    _log.i("new node started");
    return creds;
  }

  // recoverNode recovers a node from seed
  Future<GreenlightCredentials> recoverNode(
      {Network network = Network.Bitcoin, required Uint8List seed}) async {
    if (started) {
      throw Exception("Node already started");
    }
    final GreenlightCredentials creds =
        await _breezLib.recoverNode(network: network, seed: seed);
    _log.i("node recovered successfully");
    await _storeCredentials(creds);
    await _startNode();
    return creds;
  }

  Future<void> _storeCredentials(GreenlightCredentials creds) async {
    await _keyChain.write(accountSeedKey, HEX.encode(creds.deviceCert));
    await _keyChain.write(accountCredsKey, HEX.encode(creds.deviceKey));
  }

  Future _startNode() async {
    await _breezLib.runSigner();
    await syncStateWithNode();
    started = true;
  }

  // syncStateWithNode synchronized the node state with the local state.
  // This is required to assemble the account state (e.g liquidity, connected, etc...)
  Future syncStateWithNode() async {
    return await _breezLib.sync();
  }

  Future<bool> processLNURLWithdraw(
      LNURLWithdrawParams withdrawParams, Map<String, String> qParams) async {
    throw Exception("not implemented");
  }

  Future sendLNURLPayment(
      LNURLPayResult lnurlPayResult, Map<String, String> qParams) async {
    throw Exception("not implemented");
  }

  Future<LNURLPayResult> getPaymentResult(
      LNURLPayParams payParams, Map<String, String> qParams) async {
    throw Exception("not implemented");
  }

  Future sendPayment(String bolt11, int amountSat) async {
    try {
      await _breezLib.pay(bolt11: bolt11);
      syncStateWithNode();
    } catch (e) {
      _paymentResultStreamController.add(PaymentResultData(error: e));
      return Future.error(e);
    }
  }

  Future cancelPayment(String bolt11) async {
    throw Exception("not implemented");
  }

  Future sendSpontaneousPayment(
    String nodeId,
    String description,
    int amountSats,
  ) async {
    try {
      return await _breezLib.keysend(nodeId: nodeId, amountSats: amountSats);
    } catch (e) {
      _paymentResultStreamController.add(PaymentResultData(error: e));
      return Future.error(e);
    }
  }

  bool validateAddress(String? address) {
    if (address == null) return false;
    // TODO real impl. Random next bool is used to simulate valid/invalid flow
    return Random().nextBool();
  }

  // validatePayment is used to validate that outgoing/incoming payments meet the liquidity
  // constraints.
  void validatePayment(
    int amount,
    bool outgoing, {
    int? channelMinimumFee,
  }) {
    var accState = state;
    if (amount > accState.maxPaymentAmount) {
      throw PaymentExceededLimitError(accState.maxPaymentAmount);
    }

    if (!outgoing) {
      if (channelMinimumFee != null && (amount > accState.maxInboundLiquidity && amount <= channelMinimumFee)) {
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

  // TODO:
  void changePaymentFilter({
    PaymentTypeFilter filter = PaymentTypeFilter.All,
    int? fromTimestamp,
    int? toTimestamp,
  }) {
    _breezLib.listTransactions(
      filter: filter,
      fromTimestamp: fromTimestamp,
      toTimestamp: toTimestamp,
    );
  }

  Future<LNInvoice> addInvoice({
    String description = "",
    required int amountSats,
  }) async {
    return await _breezLib.requestPayment(
      amountSats: amountSats,
      description: description,
    );
  }

  // TODO: _watchAccountChanges listens to every change in the local storage and assemble a new account state accordingly
  _watchAccountChanges() {
    throw Exception("not implemented");
  }

  @override
  AccountState? fromJson(Map<String, dynamic> json) {
    return AccountState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(AccountState state) {
    return state.toJson();
  }

  final StreamController<PaymentResultData> _paymentResultStreamController =
      StreamController<PaymentResultData>();

  Stream<PaymentResultData> get paymentResultStream =>
      _paymentResultStreamController.stream;
}
