import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:breez_sdk/breez_bridge.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_sdk/sdk.dart' as breez_sdk;
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/account/account_state_assembler.dart';
import 'package:c_breez/bloc/account/payment_error.dart';
import 'package:c_breez/bloc/account/payment_result_data.dart';
import 'package:c_breez/routes/lnurl/payment/success_action/success_action_data.dart';
import 'package:c_breez/services/keychain.dart';
import 'package:c_breez/utils/lnurl.dart';
import 'package:dart_lnurl/dart_lnurl.dart';
import 'package:drift/drift.dart';
import 'package:fimber/fimber.dart';
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
  final breez_sdk.LightningNode _lightningNode;
  final breez_sdk.LNURLService _lnurlService;
  final BreezBridge breezLib;
  final KeyChain _keyChain;
  bool started = false;
  breez_sdk.Signer? _signer;

  AccountBloc(this._lightningNode, this._lnurlService, this.breezLib, this._keyChain) : super(AccountState.initial()) {
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
          final nodeCreds = breez_sdk.NodeCredentials.fromBuffer(creds);
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
    final docDir = await getApplicationDocumentsDirectory();
    final signerDir = Directory("${docDir.path}/signer");
    recursiveFolderCopySync(signerDir.path, destDir.path);
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
  Future<List<int>> startNewNode(Uint8List seed, {String network = "bitcoin", String email = ""}) async {
    if (started) {
      throw Exception("Node already started");
    }
    await _createSignerFromSeed(seed);
    var creds = await _lightningNode.newNodeFromSeed(seed, _signer!);
    _log.i("node registered successfully");
    await _keyChain.write(accountSeedKey, HEX.encode(seed));
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
  Future syncStateWithNode() {
    return _lightningNode.syncState();
  }

  Future<bool> processLNURLWithdraw(LNURLWithdrawParams withdrawParams, Map<String, String> qParams) async {
    bool isSent = await _lnurlService.processWithdrawRequest(withdrawParams, qParams).timeout(
          const Duration(minutes: 3),
          onTimeout: () => throw Exception('Timed out waiting 3 minutes for payment.'),
        );
    if (isSent) {
      await syncStateWithNode();
    }
    return isSent;
  }

  Future<breez_sdk.PaymentInfo> sendLNURLPayment(
      LNURLPayResult lnurlPayResult, Map<String, String> qParams) async {
    try {
      final paymentInfo = await _lightningNode
          .sendPaymentForRequest(
            lnurlPayResult.pr,
            amount: int.parse(qParams['amount']!),
          )
          .timeout(
            const Duration(minutes: 3),
            onTimeout: () =>
                throw Exception('Timed out waiting 3 minutes for payment.'),
          );
      await syncStateWithNode();
      if (lnurlPayResult.successAction != null) {
        _paymentResultStreamController.add(
          PaymentResultData(
            paymentInfo: paymentInfo,
            successActionData: SuccessActionData(
              getSuccessActionMessage(lnurlPayResult),
              lnurlPayResult.successAction!.url,
            ),
          ),
        );
      }
      return paymentInfo;
    } catch (e) {
      _paymentResultStreamController.add(PaymentResultData(error: e));
      return Future.error(e);
    }
  }

  Future<LNURLPayResult> getPaymentResult(LNURLPayParams payParams, Map<String, String> qParams) async {
    final LNURLPayResult lnurlPayResult = await _lnurlService.getPaymentResult(payParams, qParams);
    return lnurlPayResult;
  }

  Future<breez_sdk.PaymentInfo> sendPayment(
      String bolt11, int amountSat) async {
    try {
      final paymentInfo =
          await _lightningNode.sendPaymentForRequest(bolt11, amount: amountSat);
      await syncStateWithNode();
      _paymentResultStreamController.add(
        PaymentResultData(paymentInfo: paymentInfo),
      );
      return paymentInfo;
    } catch (e) {
      _paymentResultStreamController.add(PaymentResultData(error: e));
      return Future.error(e);
    }
  }

  Future cancelPayment(String bolt11) async {
    //throw Exception("not implemented");
  }

  Future<breez_sdk.PaymentInfo> sendSpontaneousPayment(
      String nodeID, String description, int amountSat) async {
    try {
      final paymentInfo = await _lightningNode.sendSpontaneousPayment(
          nodeID, amountSat, description);
      await syncStateWithNode();
      _paymentResultStreamController.add(
        PaymentResultData(paymentInfo: paymentInfo),
      );
      return paymentInfo;
    } catch (e) {
      _paymentResultStreamController.add(PaymentResultData(error: e));
      return Future.error(e);
    }
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

  void changePaymentFilter(breez_sdk.PaymentFilter filter) {
    _lightningNode.setPaymentFilter(filter);
  }

  Future<LNInvoice> addInvoice({String description = "", required int amountSats}) async {
    return await breezLib.requestPayment(amountSats: amountSats, description: description);
  }

  // _watchAccountChanges listens to every change in the local storage and assemble a new account state accordingly
  Stream<AccountState> _watchAccountChanges() {
    return Rx.combineLatest3<breez_sdk.PaymentsState, breez_sdk.PaymentFilter, NodeState?, AccountState>(
        _lightningNode.paymentsStream(), _lightningNode.paymentFilterStream(), _lightningNode.nodeStateStream(),
        (payments, paymentsFilter, nodeInfo) {
      return assembleAccountState(payments, paymentsFilter, nodeInfo) ?? state;
    });
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
    _signer = breez_sdk.Signer(seed, signerDir.path);
  }

  final StreamController<PaymentResultData> _paymentResultStreamController =
      StreamController<PaymentResultData>();

  Stream<PaymentResultData> get paymentResultStream =>
      _paymentResultStreamController.stream;
}
