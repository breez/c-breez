import 'dart:async';

import 'package:breez_sdk/sdk.dart' as lntoolkit;
import 'package:c_breez/bloc/input/input_state.dart';
import 'package:c_breez/models/clipboard.dart';
import 'package:c_breez/models/invoice.dart';
import 'package:c_breez/repositories/app_storage.dart';
import 'package:c_breez/services/device.dart';
import 'package:c_breez/services/lightning_links.dart';
import 'package:c_breez/utils/lnurl.dart';
import 'package:c_breez/utils/node_id.dart';
import 'package:dart_lnurl/dart_lnurl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class InputBloc extends Cubit<InputState> {
  final LightningLinksService _lightningLinks;
  final Device _device;
  final AppStorage _appStorage;
  final lntoolkit.LightningNode _lightningNode;

  final _decodeInvoiceController = StreamController<String>();

  InputBloc(
      this._lightningLinks, this._device, this._appStorage, this._lightningNode)
      : super(InputState()) {
    _watchIncomingInvoices().listen((inputState) => emit(inputState!));
  }

  void addIncomingInput(String bolt11) {
    _decodeInvoiceController.add(bolt11);
  }

  Future trackPayment(String paymentHash) {
    return _lightningNode
        .getNodeAPI()
        .incomingPaymentsStream()
        .where((p) => p.paymentHash == paymentHash)
        .first;
  }

  Stream<InputState?> _watchIncomingInvoices() {
    return Rx.merge([
      _decodeInvoiceController.stream,
      _lightningLinks.linksNotifications,
      _device.distinctClipboardStream
    ]).asyncMap((s) async {
      final command = await lntoolkit.InputParser().parse(s);
      switch (command.protocol) {
        case lntoolkit.InputProtocol.paymentRequest:
          return handlePaymentRequest(s, command);
        case lntoolkit.InputProtocol.lnurl:
          return InputState(
            lnurlParseResult: command.decoded as LNURLParseResult,
          );
        default:
          return null;
      }
    }).where((inputState) => inputState != null);
  }

  Future<InputState?> handlePaymentRequest(
      String raw, lntoolkit.ParsedInput command) async {
    final lnInvoice = command.decoded as lntoolkit.LNInvoice;
    var nodeState = await _appStorage.watchNodeState().first;
    if (nodeState == null || nodeState.nodeID == lnInvoice.payeePubkey) {
      return null;
    }
    var invoice = Invoice(
        bolt11: raw,
        paymentHash: lnInvoice.paymentHash,
        description: lnInvoice.description,
        amountMsat: lnInvoice.amount ?? 0,
        expiry: lnInvoice.expiry);

    return InputState(invoice: invoice);
  }

  Stream<DecodedClipboardData> get decodedClipboardStream => _device.rawClipboardStream.map((clipboardData) {
        if (clipboardData.isEmpty) {
          return DecodedClipboardData.unrecognized();
        }
        var nodeID = parseNodeId(clipboardData);
        if (nodeID != null) {
          return DecodedClipboardData(data: nodeID, type: ClipboardDataType.nodeID);
        }
        String normalized = clipboardData.toLowerCase();
        if (normalized.startsWith("lightning:")) {
          normalized = normalized.substring(10);
        }

        if (normalized.startsWith("lnurl")) {
          return DecodedClipboardData(data: clipboardData, type: ClipboardDataType.lnurl);
        }

        if (isLightningAddress(normalized)) {
          return DecodedClipboardData(data: normalized, type: ClipboardDataType.lightningAddress);
        }

        if (normalized.startsWith("ln")) {
          return DecodedClipboardData(data: normalized, type: ClipboardDataType.paymentRequest);
        }
        return DecodedClipboardData.unrecognized();
      });
}
