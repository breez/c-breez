import 'dart:async';
import 'dart:io';

import 'package:bip39/bip39.dart' as bip39;
import 'package:breez_sdk/breez_bridge.dart';
import 'package:breez_sdk/bridge_generated.dart' as sdk;
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/account/credential_manager.dart';
import 'package:c_breez/bloc/account/payment_error.dart';
import 'package:c_breez/bloc/account/payment_filters.dart';
import 'package:c_breez/bloc/account/payment_result.dart';
import 'package:c_breez/config.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path/path.dart' as p;
import 'package:rxdart/rxdart.dart';

import 'account_state_assembler.dart';

const maxPaymentAmount = 4294967;
const nodeSyncInterval = 60;

// AccountBloc is the business logic unit that is responsible to communicating with the lightning service
// and reflect the node state. It is responsible for:
// 1. Synchronizing with the node state.
// 2. Abstracting actions exposed by the lightning service.
class AccountBloc extends Cubit<AccountState> with HydratedMixin {
  final _log = FimberLog("AccountBloc");
  static const String paymentFilterSettingsKey = "payment_filter_settings";
  static const int defaultInvoiceExpiry = Duration.secondsPerHour;

  final StreamController<PaymentResult> _paymentResultStreamController = StreamController<PaymentResult>();

  Stream<PaymentResult> get paymentResultStream => _paymentResultStreamController.stream;

  final StreamController<PaymentFilters> _paymentFiltersStreamController = BehaviorSubject<PaymentFilters>();

  Stream<PaymentFilters> get paymentFiltersStream => _paymentFiltersStreamController.stream;

  final BreezBridge _breezLib;
  final CredentialsManager _credentialsManager;

  AccountBloc(
    this._breezLib,
    this._credentialsManager,
  ) : super(AccountState.initial()) {
    // emit on every change
    _watchAccountChanges().listen((acc) => emit(acc));

    _paymentFiltersStreamController.add(state.paymentFilters);

    if (!state.initial) _startRegisteredNode();

    _listenPaymentResultEvents();
  }

  // TODO: _watchAccountChanges listens to every change in the local storage and assemble a new account state accordingly
  _watchAccountChanges() {
    return Rx.combineLatest3<List<sdk.Payment>, PaymentFilters, sdk.NodeState?, AccountState>(
      _breezLib.paymentsStream,
      paymentFiltersStream,
      _breezLib.nodeStateStream,
      (payments, paymentFilters, nodeState) {
        return assembleAccountState(payments, paymentFilters, nodeState, state) ?? state;
      },
    );
  }

  Future _startRegisteredNode() async {
    final credentials = await _credentialsManager.restoreCredentials();
    final seed = bip39.mnemonicToSeed(credentials.mnemonic);
    await _breezLib.initServices(
      config: (await Config.instance()).sdkConfig,
      seed: seed,
      creds: credentials.glCreds,
    );
    await _startSdkForever();
  }

  // startNewNode register a new node and start it
  Future startNewNode({
    sdk.Network network = sdk.Network.Bitcoin,
    required String mnemonic,
  }) async {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final sdk.GreenlightCredentials creds = await _breezLib.registerNode(
      config: (await Config.instance()).sdkConfig,
      network: network,
      seed: seed,
    );
    _log.i("node registered successfully");
    await _credentialsManager.storeCredentials(
      glCreds: creds,
      mnemonic: mnemonic,
    );
    emit(state.copyWith(initial: false));
    await _startSdkForever();
    _log.i("new node started");
  }

  // recoverNode recovers a node from seed
  Future recoverNode({
    sdk.Network network = sdk.Network.Bitcoin,
    required String mnemonic,
  }) async {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final sdk.GreenlightCredentials creds = await _breezLib.recoverNode(
      config: (await Config.instance()).sdkConfig,
      network: network,
      seed: seed,
    );
    _log.i("node recovered successfully");
    await _credentialsManager.storeCredentials(
      glCreds: creds,
      mnemonic: mnemonic,
    );
    emit(state.copyWith(initial: false));
    await _startSdkForever();
    _log.i("recovered node started");
  }

  Future _startSdkForever() async {
    await _startSdkOnce();

    // in case we failed to start (lack of inet connection probably)
    if (state.connectionStatus == ConnectionStatus.DISCONNECTED) {
      StreamSubscription<ConnectivityResult>? subscription;
      subscription = Connectivity().onConnectivityChanged.listen((event) async {
        // we should try fetch the selected lsp information when internet is back.
        if (event != ConnectivityResult.none && state.connectionStatus == ConnectionStatus.DISCONNECTED) {
          await _startSdkOnce();
          if (state.connectionStatus == ConnectionStatus.CONNECTED) {
            subscription!.cancel();
            _onConnected();
          }
        }
      });
    } else {
      _onConnected();
    }
  }

  Future _startSdkOnce() async {
    try {
      emit(state.copyWith(connectionStatus: ConnectionStatus.CONNECTING));
      await _breezLib.startNode();
      emit(state.copyWith(connectionStatus: ConnectionStatus.CONNECTED));
    } catch (e) {
      emit(state.copyWith(connectionStatus: ConnectionStatus.DISCONNECTED));
    }
  }

  // Once connected sync sdk periodically on foreground events.
  void _onConnected() {
    var lastSync = DateTime.fromMillisecondsSinceEpoch(0);
    FGBGEvents.stream.listen((event) async {
      if (event == FGBGType.foreground && DateTime.now().difference(lastSync).inSeconds > nodeSyncInterval) {
        await _breezLib.syncNode();
        lastSync = DateTime.now();
      }
    });
  }

  Future<sdk.LnUrlWithdrawCallbackStatus> lnurlWithdraw({
    required int amountSats,
    required sdk.LnUrlWithdrawRequestData reqData,
    String? description,
  }) async {
    _log.v("lnurlWithdraw amount: $amountSats, description: '$description', reqData: $reqData");
    try {
      return await _breezLib.lnurlWithdraw(
        amountSats: amountSats,
        reqData: reqData,
        description: description,
      );
    } catch (e) {
      _log.e("lnurlWithdraw error", ex: e);
      rethrow;
    }
  }

  Future<sdk.LnUrlPayResult> lnurlPay({
    required int amount,
    required sdk.LnUrlPayRequestData reqData,
    String? comment,
  }) async {
    _log.v("lnurlPay amount: $amount, comment: '$comment', reqData: $reqData");
    try {
      return await _breezLib.lnurlPay(
        userAmountSat: amount,
        reqData: reqData,
        comment: comment,
      );
    } catch (e) {
      _log.e("lnurlPay error", ex: e);
      rethrow;
    }
  }

  Future sendPayment(String bolt11, int? amountSats) async {
    _log.v("sendPayment: $bolt11, $amountSats");
    try {
      await _breezLib.sendPayment(bolt11: bolt11, amountSats: amountSats);
    } catch (e) {
      _log.e("sendPayment error", ex: e);
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
    _log.v("sendSpontaneousPayment: $nodeId, $description, $amountSats");
    _log.i("description field is not being used by the SDK yet");
    try {
      await _breezLib.sendSpontaneousPayment(
        nodeId: nodeId,
        amountSats: amountSats,
      );
    } catch (e) {
      _log.e("sendSpontaneousPayment error", ex: e);
      return Future.error(e);
    }
  }

  Future<bool> isValidBitcoinAddress(String? address) async {
    if (address == null) return false;
    return _breezLib.isValidBitcoinAddress(address);
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
      if (channelMinimumFee != null &&
          (amount > accState.maxInboundLiquidity && amount <= channelMinimumFee)) {
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
      throw const InsufficientLocalBalanceError();
    }
  }

  void changePaymentFilter({
    sdk.PaymentTypeFilter? filter,
    int? fromTimestamp,
    int? toTimestamp,
  }) async {
    _paymentFiltersStreamController.add(
      state.paymentFilters.copyWith(
        filter: filter,
        fromTimestamp: fromTimestamp,
        toTimestamp: toTimestamp,
      ),
    );
  }

  Future<sdk.LNInvoice> addInvoice({
    String description = "",
    required int amountSats,
  }) async {
    return await _breezLib.receivePayment(
      amountSats: amountSats,
      description: description,
    );
  }

  @override
  AccountState? fromJson(Map<String, dynamic> json) {
    return AccountState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(AccountState state) {
    return state.toJson();
  }

  Future<List<File>> exportCredentialFiles() async {
    return _credentialsManager.exportCredentials();
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

  void _listenPaymentResultEvents() {
    _breezLib.paymentResultStream.listen((paymentInfo) {
      _paymentResultStreamController.add(
        PaymentResult(paymentInfo: paymentInfo),
      );
    }, onError: (error) {
      _paymentResultStreamController.add(PaymentResult(error: error));
    });
  }

  void verifyMnemonics() {
    emit(state.copyWith(verificationStatus: VerificationStatus.VERIFIED));
  }
}
