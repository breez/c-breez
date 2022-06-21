import 'dart:async';

import 'package:breez_sdk/sdk.dart' as lntoolkit;
import 'package:c_breez/bloc/invoice/invoice_state.dart';
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

class InvoiceBloc extends Cubit<InvoiceState> {
  final LightningLinksService _lightningLinks;
  final Device _device;
  final AppStorage _appStorage;
  final lntoolkit.LightningNode _lightningNode;

  final _decodeInvoiceController = StreamController<String>();

  InvoiceBloc(this._lightningLinks, this._device, this._appStorage, this._lightningNode) : super(InvoiceState(null)) {
    _watchIncomingInvoices().listen((invoice) => emit(InvoiceState(invoice)));
  }

  void addIncomingInvoice(String bolt11) {
    _decodeInvoiceController.add(bolt11);
  }

  Future trackPayment(String paymentHash) {
    return _lightningNode.getNodeAPI().incomingPaymentsStream().where((p) => p.paymentHash == paymentHash).first;
  }

  Stream<Invoice?> _watchIncomingInvoices() {
    return Rx.merge([_decodeInvoiceController.stream, _lightningLinks.linksNotifications, _device.distinctClipboardStream])
        .asyncMap((s) async {

      final command = await lntoolkit.InputParser().parse(s);
      switch (command.protocol) {
        case lntoolkit.InputProtocol.paymentRequest:
          return handlePaymentRequest(s, command);
        case lntoolkit.InputProtocol.lnurlPay:
          return handleLNURLPayRequest(s, command);
        case lntoolkit.InputProtocol.lnurlWithdraw:
          return handleLNURLWithdrawRequest(s, command);
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

  Future<Invoice?> handleLNURLPayRequest(
      String raw, lntoolkit.ParsedInput command) async {
    /* TODO: Open a page or a dialog to supply PayerData & comment string,
        specify payment amount bounded by <minSendable-maxSendable>
        with domain name in the title and a way to display sent metadata
    */
    /*
    final lnURL = command.decoded;
    final payRequestParams = command.lnurlParseResult!.payParams!;
    await specifyPayerData(payRequestParams.payerData);
    await addComment(payRequestParams.commentAllowed);
     */
    throw Exception('Not implemented yet.');
  }

  Future<PayerData> specifyPayerData(PayerDataRecord? payerDataRecord) async {
    throw Exception('Not implemented yet. Will be handled on UI.');
    // Fill mandatory fields and return PayerData
    PayerData payerData = PayerData();
    if (payerDataRecord!.name?.mandatory != null &&
        payerDataRecord!.name!.mandatory) {
      payerData = payerData.copyWith(name: "placeholderName");
    }
    return payerData;
  }

  Future<String> addComment(int charLimit) async {
    throw Exception('Not implemented yet. Will be handled on UI.');
  }

  Future<Invoice?> handleLNURLWithdrawRequest(
      String raw, lntoolkit.ParsedInput command) async {
    throw Exception('Not implemented yet.');
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
