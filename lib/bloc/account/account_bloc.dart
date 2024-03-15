import 'dart:async';
import 'dart:io';

import 'package:bip39/bip39.dart' as bip39;
import 'package:breez_sdk/sdk.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/account/account_state_assembler.dart';
import 'package:c_breez/bloc/account/credentials_manager.dart';
import 'package:c_breez/bloc/account/payment_error.dart';
import 'package:c_breez/bloc/account/payment_filters.dart';
import 'package:c_breez/bloc/account/payment_result.dart';
import 'package:c_breez/config.dart' as app;
import 'package:c_breez/models/payment_minutiae.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;
import 'package:rxdart/rxdart.dart';

const maxPaymentAmount = 4294967;
const nodeSyncInterval = 60;

final _log = Logger("AccountBloc");

// AccountBloc is the business logic unit that is responsible to communicating with the lightning service
// and reflect the node state. It is responsible for:
// 1. Synchronizing with the node state.
// 2. Abstracting actions exposed by the lightning service.
class AccountBloc extends Cubit<AccountState> with HydratedMixin {
  static const String paymentFilterSettingsKey = "payment_filter_settings";
  static const int defaultInvoiceExpiry = Duration.secondsPerHour;

  final StreamController<PaymentResult> _paymentResultStreamController = StreamController<PaymentResult>();

  Stream<PaymentResult> get paymentResultStream => _paymentResultStreamController.stream;

  final StreamController<PaymentFilters> _paymentFiltersStreamController = BehaviorSubject<PaymentFilters>();

  Stream<PaymentFilters> get paymentFiltersStream => _paymentFiltersStreamController.stream;

  final CredentialsManager _credentialsManager;

  AccountBloc(this._credentialsManager) : super(AccountState.initial()) {
    hydrate();
    _watchAccountChanges().listen((acc) {
      _log.info("State changed: $acc");
      emit(acc);
    });

    _paymentFiltersStreamController.add(state.paymentFilters);

    if (!state.initial) connect();

    _listenPaymentResultEvents();
  }

  // TODO: _watchAccountChanges listens to every change in the local storage and assemble a new account state
  // accordingly
  Stream<AccountState> _watchAccountChanges() {
    return Rx.combineLatest3<List<Payment>, PaymentFilters, NodeState?, AccountState>(
      BreezSDK.paymentsStream,
      paymentFiltersStream,
      BreezSDK.nodeStateStream,
      (payments, paymentFilters, nodeState) {
        return assembleAccountState(payments, paymentFilters, nodeState, state) ?? state;
      },
    );
  }

  Future connect({
    String? mnemonic,
    bool restored = false,
  }) async {
    _log.info("connect new mnemonic: ${mnemonic != null}, restored: $restored");
    if (mnemonic != null) {
      await _credentialsManager.storeMnemonic(mnemonic: mnemonic);
      emit(state.copyWith(
        initial: false,
        verificationStatus: restored ? VerificationStatus.VERIFIED : null,
      ));
    }
    await _startSdkForever();
  }

  Future _startSdkForever() async {
    _log.info("starting sdk forever");
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
    _log.info("starting sdk once");
    var config = await app.Config.instance();
    if (config.sdkConfig.apiKey != null) {
      await _credentialsManager.storeApiKey(apiKey: config.sdkConfig.apiKey!);
    }
    if (await BreezSDK.isInitialized()) {
      _log.info("sdk already initialized");
      await BreezSDK.fetchNodeData();
      emit(state.copyWith(connectionStatus: ConnectionStatus.CONNECTED));
      return;
    }
    try {
      emit(state.copyWith(connectionStatus: ConnectionStatus.CONNECTING));
      final mnemonic = await _credentialsManager.restoreMnemonic();
      final seed = bip39.mnemonicToSeed(mnemonic);
      _log.info("connecting to breez lib");
      final req = ConnectRequest(
        config: config.sdkConfig,
        seed: seed,
      );
      await BreezSDK.connect(req: req);
      _log.info("connected to breez lib");
      emit(state.copyWith(connectionStatus: ConnectionStatus.CONNECTED));
    } catch (e) {
      _log.warning("failed to connect to breez lib", e);
      emit(state.copyWith(connectionStatus: ConnectionStatus.DISCONNECTED));
    }
  }

  // Once connected sync sdk periodically on foreground events.
  void _onConnected() {
    _log.info("on connected");
    var lastSync = DateTime.fromMillisecondsSinceEpoch(0);
    FGBGEvents.stream.listen((event) async {
      if (event == FGBGType.foreground && DateTime.now().difference(lastSync).inSeconds > nodeSyncInterval) {
        await BreezSDK.sync();
        lastSync = DateTime.now();
      }
    });
  }

  Future<LnUrlWithdrawResult> lnurlWithdraw({
    required LnUrlWithdrawRequest req,
  }) async {
    _log.info("lnurlWithdraw amount: req: $req");
    try {
      return await BreezSDK.lnurlWithdraw(req: req);
    } catch (e) {
      _log.severe("lnurlWithdraw error", e);
      rethrow;
    }
  }

  Future<LnUrlPayResult> lnurlPay({required req}) async {
    _log.info("lnurlPay amount: req: $req");
    try {
      return await BreezSDK.lnurlPay(req: req);
    } catch (e) {
      _log.severe("lnurlPay error", e);
      rethrow;
    }
  }

  Future<LnUrlCallbackStatus> lnurlAuth({
    required LnUrlAuthRequestData reqData,
  }) async {
    _log.info("lnurlAuth amount: reqData: $reqData");
    try {
      return await BreezSDK.lnurlAuth(reqData: reqData);
    } catch (e) {
      _log.severe("lnurlAuth error", e);
      rethrow;
    }
  }

  Future sendPayment(String bolt11, int? amountMsat) async {
    _log.info("sendPayment: $bolt11, $amountMsat");
    try {
      final req = SendPaymentRequest(
        bolt11: bolt11,
        amountMsat: amountMsat,
      );
      await BreezSDK.sendPayment(req: req);
    } catch (e) {
      _log.severe("sendPayment error", e);
      return Future.error(e);
    }
  }

  Future cancelPayment(String bolt11) async {
    _log.info("cancelPayment: $bolt11");
    throw Exception("not implemented");
  }

  Future sendSpontaneousPayment({
    required String nodeId,
    String? description,
    required int amountMsat,
  }) async {
    _log.info("sendSpontaneousPayment: $nodeId, $description, $amountMsat");
    _log.info("description field is not being used by the SDK yet");
    try {
      final req = SendSpontaneousPaymentRequest(
        nodeId: nodeId,
        amountMsat: amountMsat,
      );
      await BreezSDK.sendSpontaneousPayment(req: req);
    } catch (e) {
      _log.severe("sendSpontaneousPayment error", e);
      return Future.error(e);
    }
  }

  Future<bool> isValidBitcoinAddress(String? address) async {
    _log.info("isValidBitcoinAddress: $address");
    if (address == null) return false;
    return BreezSDK.isValidBitcoinAddress(address);
  }

  // validatePayment is used to validate that outgoing/incoming payments meet the liquidity
  // constraints.
  void validatePayment(
    int amount,
    bool outgoing,
    bool channelCreationPossible, {
    int? channelMinimumFee,
  }) {
    _log.info("validatePayment: $amount, $outgoing, $channelMinimumFee");
    var accState = state;
    if (amount > accState.maxPaymentAmount) {
      _log.info("Amount $amount is bigger than maxPaymentAmount ${accState.maxPaymentAmount}");
      throw PaymentExceededLimitError(accState.maxPaymentAmount);
    }

    if (!outgoing) {
      if (!channelCreationPossible && accState.maxInboundLiquidity == 0) {
        throw NoChannelCreationZeroLiqudityError();
      } else if (!channelCreationPossible && accState.maxInboundLiquidity < amount) {
        throw PaymentExcededLiqudityChannelCreationNotPossibleError(accState.maxInboundLiquidity);
      } else if (channelMinimumFee != null &&
          (amount > accState.maxInboundLiquidity && amount <= channelMinimumFee)) {
        throw PaymentBelowSetupFeesError(channelMinimumFee);
      } else if (channelMinimumFee == null && amount > accState.maxInboundLiquidity) {
        throw PaymentExceedLiquidityError(accState.maxInboundLiquidity);
      } else if (amount > accState.maxAllowedToReceive) {
        throw PaymentExceededLimitError(accState.maxAllowedToReceive);
      }
    }

    if (outgoing && amount > accState.maxAllowedToPay) {
      _log.info("Outgoing but amount $amount is bigger than ${accState.maxAllowedToPay}");
      if (accState.reserveAmount > 0) {
        _log.info("Reserve amount ${accState.reserveAmount}");
        throw PaymentBelowReserveError(accState.reserveAmount);
      }
      throw const InsufficientLocalBalanceError();
    }
  }

  void changePaymentFilter({
    List<PaymentTypeFilter>? filters,
    int? fromTimestamp,
    int? toTimestamp,
  }) async {
    _log.info("changePaymentFilter: $filters, $fromTimestamp, $toTimestamp");
    _paymentFiltersStreamController.add(
      state.paymentFilters.copyWith(
        filters: filters,
        fromTimestamp: fromTimestamp,
        toTimestamp: toTimestamp,
      ),
    );
  }

  Future<ReceivePaymentResponse> addInvoice({
    String description = "",
    required int amountMsat,
    required OpeningFeeParams? chosenFeeParams,
  }) async {
    _log.info("addInvoice: $description, $amountMsat");

    final req = ReceivePaymentRequest(
      amountMsat: amountMsat,
      description: description,
      openingFeeParams: chosenFeeParams,
    );
    return await BreezSDK.receivePayment(req: req);
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
    _log.info("exportCredentialFiles");
    return _credentialsManager.exportCredentials();
  }

  Future<StaticBackupResponse> exportStaticChannelBackup() async {
    _log.fine("exportStaticChannelBackup");
    return _credentialsManager.exportStaticChannelBackup();
  }

  void recursiveFolderCopySync(String path1, String path2) {
    _log.info("recursiveFolderCopySync: $path1, $path2");
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
    _log.info("_listenPaymentResultEvents");
    BreezSDK.paymentResultStream.listen((paymentInfo) {
      _paymentResultStreamController.add(
        PaymentResult(paymentInfo: paymentInfo),
      );
    }, onError: (error) {
      _log.info("Error in paymentResultStream", error);
      var paymentHash = "";
      if (error is PaymentException) {
        final invoice = error.data.invoice;
        if (invoice != null) {
          paymentHash = invoice.paymentHash;
        }
      }
      _paymentResultStreamController
          .add(PaymentResult(error: PaymentResultError.fromException(paymentHash, error)));
    });
  }

  void mnemonicsValidated() {
    _log.info("mnemonicsValidated");
    emit(state.copyWith(verificationStatus: VerificationStatus.VERIFIED));
  }

  List<PaymentMinutiae> filterPaymentList() {
    final nonFilteredPayments = state.payments;
    final paymentFilters = state.paymentFilters;

    var filteredPayments = nonFilteredPayments;
    // Apply date filters, if there's any
    if (paymentFilters.fromTimestamp != null || paymentFilters.toTimestamp != null) {
      filteredPayments = nonFilteredPayments.where((paymentMinutiae) {
        final fromTimestamp = paymentFilters.fromTimestamp;
        final toTimestamp = paymentFilters.toTimestamp;
        final milliseconds = paymentMinutiae.paymentTime.millisecondsSinceEpoch;
        if (fromTimestamp != null && toTimestamp != null) {
          return fromTimestamp < milliseconds && milliseconds < toTimestamp;
        }
        return true;
      }).toList();
    }

    // Apply payment type filters, if there's any
    final paymentTypeFilters = paymentFilters.filters;
    if (paymentTypeFilters != null && paymentTypeFilters != PaymentTypeFilter.values) {
      filteredPayments = filteredPayments.where((paymentMinutiae) {
        return paymentTypeFilters.any(
          (filter) {
            return filter.name == paymentMinutiae.paymentType.name;
          },
        );
      }).toList();
    }
    return filteredPayments;
  }
}
