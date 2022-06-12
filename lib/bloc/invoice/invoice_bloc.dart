import 'dart:async';

import 'package:c_breez/bloc/invoice/invoice_state.dart';
import 'package:c_breez/models/invoice.dart';
import 'package:c_breez/models/clipboard.dart';
import 'package:c_breez/repositories/app_storage.dart';
import 'package:c_breez/services/device.dart';
import 'package:c_breez/services/lightning_links.dart';
import 'package:c_breez/utils/node_id.dart';
import 'package:c_breez/utils/lnurl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:breez_sdk/sdk.dart' as lntoolkit;
import 'package:rxdart/rxdart.dart';

class InvoiceBloc extends Cubit<InvoiceState> {
  final LightningLinksService _lightningLinks;
  final Device _device;
  final AppStorage _appStorage;
  final lntoolkit.LightningServices _lightningService;

  final _decodeInvoiceController = StreamController<String>();

  InvoiceBloc(this._lightningLinks, this._device, this._appStorage, this._lightningService) : super(InvoiceState(null)) {
    _watchIncomingInvoices().listen((invoice) => emit(InvoiceState(invoice)));
  }

  void addIncomingInvoice(String bolt11) {
    _decodeInvoiceController.add(bolt11);
  }

  Future trackPayment(String paymentHash) {
    return _lightningService.getNodeAPI().incomingPaymentsStream().where((p) => p.paymentHash == paymentHash).first;
  }

  Stream<Invoice?> _watchIncomingInvoices() {
    return Rx.merge([_decodeInvoiceController.stream, _lightningLinks.linksNotifications, _device.distinctClipboardStream])
        .asyncMap((s) async {

      final command = await lntoolkit.InputParser().parse(s);
      switch (command.protocol) {
        case lntoolkit.InputProtocol.paymentRequest:
          return handlePaymentRequest(s, command);
        default:
          return null;
      }
    }).where((invoice) => invoice != null);
  }

  Future<Invoice?> handlePaymentRequest(String raw, lntoolkit.ParsedInput command) async {
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

    return invoice;
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
