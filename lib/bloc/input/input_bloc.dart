import 'dart:async';

import 'package:breez_sdk/breez_bridge.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_sdk/sdk.dart' as breez_sdk;
import 'package:c_breez/bloc/input/input_state.dart';
import 'package:c_breez/models/clipboard.dart';
import 'package:c_breez/models/invoice.dart';
import 'package:c_breez/services/device.dart';
import 'package:c_breez/services/lightning_links.dart';
import 'package:c_breez/utils/lnurl.dart';
import 'package:c_breez/utils/node_id.dart';
import 'package:dart_lnurl/dart_lnurl.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class InputBloc extends Cubit<InputState> {
  final _log = FimberLog("InputBloc");
  final BreezBridge _breezLib;
  final LightningLinksService _lightningLinks;
  final Device _device;

  final _decodeInvoiceController = StreamController<String>();

  InputBloc(this._breezLib, this._lightningLinks, this._device)
      : super(InputState()) {
    _watchIncomingInvoices().listen((inputState) => emit(inputState!));
  }

  void addIncomingInput(String bolt11) {
    _decodeInvoiceController.add(bolt11);
  }

  Future trackPayment(String paymentHash) async {
    await _breezLib.invoicePaidStream.firstWhere((invoice) {
      _log.v("invoice paid: ${invoice.paymentHash} we are waiting for "
          "$paymentHash, same: ${invoice.paymentHash == paymentHash}");
      return invoice.paymentHash == paymentHash;
    });
  }

  Stream<InputState?> _watchIncomingInvoices() {
    return Rx.merge([
      _decodeInvoiceController.stream,
      _lightningLinks.linksNotifications,
      _device.clipboardStream.distinct().skip(1),
    ]).asyncMap((s) async {
      _log.v("Incoming input: '$s'");
      // Emit an empty InputState with isLoading to display a loader on UI layer
      emit(InputState(isLoading: true));
      try {
        final command = await breez_sdk.InputParser().parse(s);
        _log.v("Parsed command: '$command'");
        switch (command.protocol) {
          case breez_sdk.InputProtocol.paymentRequest:
            return handlePaymentRequest(s, command);
          case breez_sdk.InputProtocol.lnurl:
            return InputState(
                protocol: command.protocol,
                inputData: command.decoded as LNURLParseResult);
          case breez_sdk.InputProtocol.nodeID:
          case breez_sdk.InputProtocol.appLink:
          case breez_sdk.InputProtocol.webView:
            return InputState(
                protocol: command.protocol, inputData: command.decoded);
          default:
            return InputState(isLoading: false);
        }
      } catch (e) {
        _log.e("Failed to parse input", ex: e);
        return InputState(isLoading: false);
      }
    }).where((inputState) => inputState != null);
  }

  Future<InputState?> handlePaymentRequest(
      String raw, breez_sdk.ParsedInput command) async {
    final lnInvoice = command.decoded as breez_sdk.LNInvoice;
    NodeState? nodeState = await _breezLib.getNodeState();
    if (nodeState == null || nodeState.id == lnInvoice.payeePubkey) {
      return null;
    }
    var invoice = Invoice(
        bolt11: raw,
        paymentHash: lnInvoice.paymentHash,
        description: lnInvoice.description ?? "",
        amountMsat: lnInvoice.amountMsat ?? 0,
        expiry: lnInvoice.expiry);

    return InputState(protocol: command.protocol, inputData: invoice);
  }

  Stream<DecodedClipboardData> get decodedClipboardStream => _device.clipboardStream.distinct().skip(1).map((clipboardData) {
        if (clipboardData.isEmpty) {
          return DecodedClipboardData.unrecognized();
        }
        var nodeID = parseNodeId(clipboardData);
        if (nodeID != null) {
          return DecodedClipboardData(
              data: nodeID, type: ClipboardDataType.nodeID);
        }
        String normalized = clipboardData.toLowerCase();
        if (normalized.startsWith("lightning:")) {
          normalized = normalized.substring(10);
        }

        if (normalized.startsWith("lnurl")) {
          return DecodedClipboardData(
              data: clipboardData, type: ClipboardDataType.lnurl);
        }

        if (isLightningAddress(normalized)) {
          return DecodedClipboardData(
              data: normalized, type: ClipboardDataType.lightningAddress);
        }

        if (normalized.startsWith("ln")) {
          return DecodedClipboardData(
              data: normalized, type: ClipboardDataType.paymentRequest);
        }
        return DecodedClipboardData.unrecognized();
      });
}
