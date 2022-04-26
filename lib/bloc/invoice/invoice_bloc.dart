import 'dart:async';

import 'package:c_breez/bloc/invoice/invoice_state.dart';
import 'package:c_breez/models/account.dart';
import 'package:c_breez/models/bolt11.dart';
import 'package:c_breez/models/invoice.dart';
import 'package:c_breez/services/device.dart';
import 'package:c_breez/services/lightning_links.dart';
import 'package:c_breez/utils/bip21.dart';
import 'package:c_breez/utils/node_id.dart';
import 'package:c_breez/utils/lnurl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class InvoiceBloc extends Cubit<InvoiceState> {
  final LightningLinksService _lightningLinks;
  final Device _device;

  final _decodeInvoiceController = StreamController<String>();

  InvoiceBloc(this._lightningLinks, this._device) : super(InvoiceState(null)) {
    _watchIncomingInvoices().listen((invoice) => emit(InvoiceState(invoice)));
  }

  void addIncomingInvoice(String bolt11) {
    _decodeInvoiceController.add(bolt11);
  }

  Stream<Invoice> _watchIncomingInvoices() {
    return Rx.merge([
      _decodeInvoiceController.stream,
      _lightningLinks.linksNotifications,
      _device.distinctClipboardStream.where((s) =>
          s.toLowerCase().startsWith("ln") ||
          s.toLowerCase().startsWith("lightning:"))
    ])
        .map((s) {
          String lower = s.toLowerCase();
          if (lower.startsWith("lightning:")) {
            return s.substring(10);
          }

          // check bip21 with bolt11
          String? bolt11 = extractBolt11FromBip21(lower);
          return bolt11 ?? s;
        })
        .where((s) => !s.toLowerCase().startsWith("lnurl"))
        .map((bolt11) {
          var bolt = Bolt11.fromPaymentRequest(bolt11);
          return Invoice(
              bolt11: bolt11,
              description: bolt.description,
              amount: bolt.amount,
              expiry: bolt.expiry);
        });
  }

  Stream<DecodedClipboardData> get decodedClipboardStream =>
      _device.rawClipboardStream.map((clipboardData) {
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
              data: normalized, type: ClipboardDataType.payamentRequest);
        }
        return DecodedClipboardData.unrecognized();
      });
}
