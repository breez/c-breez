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
  final GlobalKey firstPaymentItemKey;
  final ScrollController scrollController;
  final GlobalKey<ScaffoldState> scaffoldController;

  StreamSubscription<InputState>? _subscription;
  ModalRoute? _loaderRoute;
  bool _handlingRequest = false;

  InputHandler(
    this.firstPaymentItemKey,
    this.scrollController,
    this.scaffoldController,
  );

  @override
  void init(HandlerContextProvider<StatefulWidget> contextProvider) {
    super.init(contextProvider);
    _subscription = contextProvider.getBuildContext()!.read<InputBloc>().stream.listen(
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
          _log.v("Input state handled: $result");
          if (result is LNURLPageResult && result.protocol != null) {
            final context = contextProvider?.getBuildContext();
            if (context != null) {
              handleLNURLPageResult(context, result);
            } else {
              _log.v("Skipping handling of result: $result because context is null");
            }
          }
        })
        .whenComplete(() => _handlingRequest = false)
        .onError((error, _) {
          _log.e("Input state error", ex: error);
          _handlingRequest = false;
          _setLoading(false);
          if (error != null) {
            final context = contextProvider?.getBuildContext();
            if (context != null) {
              showFlushbar(context, message: extractExceptionMessage(error, context.texts()));
            } else {
              _log.v("Skipping handling of error: $error because context is null");
            }
          }
        });
  }

  Future handleInputData(dynamic parsedInput) async {
    _log.v("handle input $parsedInput");
    final context = contextProvider?.getBuildContext();
    if (context == null) {
      _log.v("Not handling input $parsedInput because context is null");
      return;
    }

    if (parsedInput is Invoice) {
      return handleInvoice(context, parsedInput);
    } else if (parsedInput is InputType_LnUrlPay ||
        parsedInput is InputType_LnUrlWithdraw ||
        parsedInput is InputType_LnUrlAuth ||
        parsedInput is InputType_LnUrlError) {
      return handleLNURL(context, firstPaymentItemKey, parsedInput.data);
    } else if (parsedInput is InputType_NodeId) {
      return handleNodeID(context, parsedInput.nodeId);
    }
  }

  Future handleInvoice(BuildContext context, Invoice invoice) async {
    _log.v("handle invoice $invoice");
    return await showDialog(
      useRootNavigator: false,
      context: context,
      barrierDismissible: false,
      builder: (_) => PaymentRequestDialog(
        invoice,
        firstPaymentItemKey,
        scrollController,
      ),
    );
  }

  Future handleNodeID(BuildContext context, String nodeID) async {
    _log.v("handle node id $nodeID");
    return await Navigator.of(context).push(
      FadeInRoute(
        builder: (_) => SpontaneousPaymentPage(
          nodeID,
          firstPaymentItemKey,
        ),
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
