import 'dart:async';

import 'package:breez_sdk/breez_bridge.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/bloc/input/input_state.dart';
import 'package:c_breez/models/clipboard.dart';
import 'package:c_breez/models/invoice.dart';
import 'package:c_breez/services/device.dart';
import 'package:c_breez/services/lightning_links.dart';
import 'package:c_breez/utils/lnurl.dart';
import 'package:c_breez/utils/node_id.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class InputBloc extends Cubit<InputState> {
  final _log = FimberLog("InputBloc");
  final BreezBridge _breezLib;
  final LightningLinksService _lightningLinks;
  final Device _device;

  final _decodeInvoiceController = StreamController<String>();

  InputBloc(this._breezLib, this._lightningLinks, this._device) : super(InputState()) {
    _initializeInputBloc();
  }

  void _initializeInputBloc() async {
    await _breezLib.nodeStateStream.firstWhere((nodeState) => nodeState != null);
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
    ]).asyncMap((input) async {
      _log.v("Incoming input: '$input'");
      // Emit an empty InputState with isLoading to display a loader on UI layer
      emit(InputState(isLoading: true));
      try {
        return await _handleParsedInput(await _breezLib.parseInput(input: input));
      } catch (e) {
        _log.e("Failed to parse input", ex: e);
        return InputState(isLoading: false);
      }
    });
  }

  Future<InputState> handlePaymentRequest({required dynamic inputData}) async {
    late LNInvoice lnInvoice;
    if (inputData is InputType_Bolt11) {
      lnInvoice = inputData.invoice;
    } else if (inputData is InputType_BitcoinAddress) {
      lnInvoice = await _breezLib.parseInvoice(inputData.address.address);
    }

    NodeState? nodeState = await _breezLib.getNodeState();
    if (nodeState == null || nodeState.id == lnInvoice.payeePubkey) {
      return InputState(isLoading: false);
    }
    var invoice = Invoice(
        bolt11: lnInvoice.bolt11,
        paymentHash: lnInvoice.paymentHash,
        description: lnInvoice.description ?? "",
        amountMsat: lnInvoice.amountMsat ?? 0,
        expiry: lnInvoice.expiry);

    return InputState(inputType: InputType_Bolt11, inputData: invoice);
  }

  Future<InputState> _handleParsedInput(InputType parsedInput) async {
    if (parsedInput is InputType_Bolt11 || parsedInput is InputType_BitcoinAddress) {
      return await handlePaymentRequest(inputData: parsedInput);
    } else if (parsedInput is InputType_LnUrlPay ||
        parsedInput is InputType_LnUrlWithdraw ||
        parsedInput is InputType_LnUrlAuth ||
        parsedInput is InputType_LnUrlError ||
        parsedInput is InputType_NodeId) {
      return InputState(inputType: parsedInput.runtimeType, inputData: parsedInput);
    } else {
      return InputState(isLoading: false);
    }
  }

  Stream<DecodedClipboardData> get decodedClipboardStream =>
      _device.clipboardStream.distinct().skip(1).map((clipboardData) {
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
