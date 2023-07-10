import 'dart:async';

import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/input/input_bloc.dart';
import 'package:c_breez/bloc/input/input_state.dart';
import 'package:c_breez/handlers/handler.dart';
import 'package:c_breez/handlers/handler_context_provider.dart';
import 'package:c_breez/models/invoice.dart';
import 'package:c_breez/routes/lnurl/lnurl_invoice_delegate.dart';
import 'package:c_breez/routes/lnurl/widgets/lnurl_page_result.dart';
import 'package:c_breez/routes/spontaneous_payment/spontaneous_payment_page.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:c_breez/widgets/payment_dialogs/payment_request_dialog.dart';
import 'package:c_breez/widgets/route.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _log = FimberLog("InputHandler");

class InputHandler extends Handler {
  StreamSubscription<InputState>? _subscription;
  ModalRoute? _loaderRoute;
  bool _handlingRequest = false;
  final BuildContext context;

  InputHandler({required this.context});

  @override
  void init(HandlerContextProvider<StatefulWidget> contextProvider) {
    _subscription = context.read<InputBloc>().stream.listen(
      _listen,
      onError: (error) {
        _handlingRequest = false;
        _setLoading(false);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
    _subscription = null;
  }

  void _listen(InputState inputState) {
    _log.v("Input state changed: $inputState");
    if (_handlingRequest) {
      _log.v("Already handling request, skipping state change");
      return;
    }

    _setLoading(inputState.isLoading);
    _handlingRequest = true;
    handleInputData(inputState.inputData)
        .then((result) {
          handleResult(result);
        })
        .whenComplete(() => _handlingRequest = false)
        .onError((error, _) {
          _log.e("Input state error", ex: error);
          _handlingRequest = false;
          _setLoading(false);
          if (error != null) {
            showFlushbar(context, message: extractExceptionMessage(error, context.texts()));
          }
        });
  }

  void handleResult(result) {
    _log.v("Input state handled: $result");
    if (result is LNURLPageResult && result.protocol != null) {
      handleLNURLPageResult(context, result);
    }
  }

  Future handleInputData(dynamic parsedInput) async {
    _log.v("handle input $parsedInput");

    if (parsedInput is LNInvoice) {
      Invoice invoice = Invoice(
          bolt11: parsedInput.bolt11,
          paymentHash: parsedInput.paymentHash,
          amountMsat: parsedInput.amountMsat!,
          expiry: parsedInput.expiry);
      return handleInvoice(context, invoice);
    } else if (parsedInput is InputType_LnUrlPay ||
        parsedInput is InputType_LnUrlWithdraw ||
        parsedInput is InputType_LnUrlAuth ||
        parsedInput is InputType_LnUrlError) {
      return handleLNURL(context, parsedInput.data);
    } else if (parsedInput is InputType_NodeId) {
      return handleNodeID(context, parsedInput.nodeId);
    }
    // Input wasn't handled
    return false;
  }

  Future handleInvoice(BuildContext context, Invoice invoice) async {
    _log.v("handle invoice $invoice");
    return await showDialog(
      useRootNavigator: false,
      context: context,
      barrierDismissible: false,
      builder: (_) => PaymentRequestDialog(
        invoice,
      ),
    );
  }

  Future handleNodeID(BuildContext context, String nodeID) async {
    _log.v("handle node id $nodeID");
    return await Navigator.of(context).push(
      FadeInRoute(
        builder: (_) => SpontaneousPaymentPage(nodeID),
      ),
    );
  }

  void _setLoading(bool visible) {
    if (visible && _loaderRoute == null) {
      final context = contextProvider?.getBuildContext();
      if (context != null) {
        _loaderRoute = createLoaderRoute(context);
        Navigator.of(context).push(_loaderRoute!);
      }
      return;
    }

    if (!visible && _loaderRoute != null) {
      _loaderRoute?.navigator?.removeRoute(_loaderRoute!);
      _loaderRoute = null;
    }
  }
}
