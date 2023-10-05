import 'dart:async';

import 'package:breez_sdk/breez_sdk.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/bloc/input/input_state.dart';
import 'package:c_breez/models/invoice.dart';
import 'package:c_breez/services/device.dart';
import 'package:c_breez/services/lightning_links.dart';
import 'package:logging/logging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class InputBloc extends Cubit<InputState> {
  final _log = Logger("InputBloc");
  final BreezSDK _breezLib;
  final LightningLinksService _lightningLinks;
  final Device _device;

  final _decodeInvoiceController = StreamController<String>();

  InputBloc(
    this._breezLib,
    this._lightningLinks,
    this._device,
  ) : super(InputState()) {
    _initializeInputBloc();
  }

  void _initializeInputBloc() async {
    _log.config("initializeInputBloc");
    await _breezLib.nodeStateStream.firstWhere((nodeState) => nodeState != null);
    _watchIncomingInvoices().listen((inputState) => emit(inputState!));
  }

  void addIncomingInput(String bolt11) {
    _log.fine("addIncomingInput: $bolt11");
    _decodeInvoiceController.add(bolt11);
  }

  Future trackPayment(String paymentHash) async {
    await _breezLib.invoicePaidStream.firstWhere((invoice) {
      _log.fine("invoice paid: ${invoice.paymentHash} we are waiting for "
          "$paymentHash, same: ${invoice.paymentHash == paymentHash}");
      return invoice.paymentHash == paymentHash;
    });
  }

  Stream<InputState?> _watchIncomingInvoices() {
    return Rx.merge([
      _decodeInvoiceController.stream.doOnData((event) => _log.fine("decodeInvoiceController: $event")),
      _lightningLinks.linksNotifications.doOnData((event) => _log.fine("lightningLinks: $event")),
      _device.clipboardStream.distinct().skip(1).doOnData((event) => _log.fine("clipboardStream: $event")),
    ]).asyncMap((input) async {
      _log.fine("Incoming input: '$input'");
      // Emit an empty InputState with isLoading to display a loader on UI layer
      emit(InputState(isLoading: true));
      try {
        final parsedInput = await parseInput(input: input);
        // Todo: Merge these functions w/o sacrificing readability
        _logParsedInput(parsedInput);
        return await _handleParsedInput(parsedInput);
      } catch (e) {
        _log.severe("Failed to parse input", e);
        return InputState(isLoading: false);
      }
    });
  }

  Future<InputState> handlePaymentRequest({required InputType_Bolt11 inputData}) async {
    final LNInvoice lnInvoice = inputData.invoice;

    NodeState? nodeState = await _breezLib.nodeInfo();
    if (nodeState == null || nodeState.id == lnInvoice.payeePubkey) {
      return InputState(isLoading: false);
    }
    var invoice = Invoice(
      bolt11: lnInvoice.bolt11,
      paymentHash: lnInvoice.paymentHash,
      description: lnInvoice.description ?? "",
      amountMsat: lnInvoice.amountMsat ?? 0,
      expiry: lnInvoice.expiry,
    );

    return InputState(inputData: invoice);
  }

  Future<InputState> _handleParsedInput(InputType parsedInput) async {
    if (parsedInput is InputType_Bolt11) {
      return await handlePaymentRequest(inputData: parsedInput);
    } else if (parsedInput is InputType_LnUrlPay ||
        parsedInput is InputType_LnUrlWithdraw ||
        parsedInput is InputType_LnUrlAuth ||
        parsedInput is InputType_LnUrlError ||
        parsedInput is InputType_NodeId) {
      return InputState(inputData: parsedInput);
    } else {
      return InputState(isLoading: false);
    }
  }

  void _logParsedInput(InputType parsedInput) {
    // Todo: Find a better way to serialize parsed input
    _log.fine("Parsed input type: '${parsedInput.runtimeType.toString()}");
    if (parsedInput is InputType_Bolt11) {
      final lnInvoice = parsedInput.invoice;
      _log.info(
        "bolt11: ${lnInvoice.bolt11}\n"
        "payeePubkey: ${lnInvoice.payeePubkey}\n"
        "paymentHash: ${lnInvoice.paymentHash}\n"
        "description: ${lnInvoice.description}\n"
        "descriptionHash: ${lnInvoice.descriptionHash}\n"
        "amountMsat: ${lnInvoice.amountMsat}\n"
        "timestamp: ${lnInvoice.timestamp}\n"
        "expiry: ${lnInvoice.expiry}\n"
        "routingHints: ${lnInvoice.routingHints}\n"
        "paymentSecret: ${lnInvoice.paymentSecret}",
      );
    } else if (parsedInput is InputType_LnUrlPay) {
      final lnUrlPayReqData = parsedInput.data;
      _log.info(
        "${lnUrlPayReqData.toString()}\n"
        "callback: ${lnUrlPayReqData.callback}\n"
        "minSendable: ${lnUrlPayReqData.minSendable}\n"
        "maxSendable: ${lnUrlPayReqData.maxSendable}\n"
        "metadataStr: ${lnUrlPayReqData.metadataStr}\n"
        "commentAllowed: ${lnUrlPayReqData.commentAllowed}\n"
        "domain: ${lnUrlPayReqData.domain}",
      );
    } else if (parsedInput is InputType_LnUrlWithdraw) {
      final lnUrlWithdrawReqData = parsedInput.data;
      _log.info(
        "callback: ${lnUrlWithdrawReqData.callback}\n"
        "k1: ${lnUrlWithdrawReqData.k1}\n"
        "defaultDescription: ${lnUrlWithdrawReqData.defaultDescription}\n"
        "minWithdrawable: ${lnUrlWithdrawReqData.minWithdrawable}\n"
        "maxWithdrawable: ${lnUrlWithdrawReqData.maxWithdrawable}",
      );
    } else if (parsedInput is InputType_LnUrlAuth) {
      final lnUrlAuthReqData = parsedInput.data;
      _log.info("k1: ${lnUrlAuthReqData.k1}");
    } else if (parsedInput is InputType_LnUrlError) {
      final lnUrlErrorData = parsedInput.data;
      _log.info("reason: ${lnUrlErrorData.reason}");
    } else if (parsedInput is InputType_NodeId) {
      _log.info("nodeId: ${parsedInput.nodeId}");
    } else if (parsedInput is InputType_Url) {
      _log.info("url: ${parsedInput.url}");
    }
  }

  Future<InputType> parseInput({required String input}) async => await _breezLib.parseInput(input: input);
}
