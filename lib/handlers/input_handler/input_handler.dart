import 'dart:async';

import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/input/input_bloc.dart';
import 'package:c_breez/bloc/input/input_source.dart';
import 'package:c_breez/bloc/input/input_state.dart';
import 'package:c_breez/handlers/handlers.dart';
import 'package:c_breez/models/invoice.dart';
import 'package:c_breez/routes/lnurl/auth/lnurl_auth_handler.dart';
import 'package:c_breez/routes/lnurl/lnurl_invoice_delegate.dart';
import 'package:c_breez/routes/lnurl/payment/lnurl_payment_handler.dart';
import 'package:c_breez/routes/lnurl/widgets/lnurl_page_result.dart';
import 'package:c_breez/routes/lnurl/withdraw/lnurl_withdraw_handler.dart';
import 'package:c_breez/routes/spontaneous_payment/spontaneous_payment_page.dart';
import 'package:c_breez/utils/utils.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:c_breez/widgets/payment_dialogs/payment_request_dialog.dart';
import 'package:c_breez/widgets/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger("InputHandler");

class InputHandler extends Handler {
  final GlobalKey firstPaymentItemKey;
  final GlobalKey<ScaffoldState> scaffoldController;

  StreamSubscription<InputState>? _subscription;
  ModalRoute? _loaderRoute;
  bool _handlingRequest = false;

  InputHandler(this.firstPaymentItemKey, this.scaffoldController);

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
    _log.info("Input state changed: $inputState");
    if (_handlingRequest) {
      _log.info("Already handling request, skipping state change");
      return;
    }

    final isLoading = inputState is LoadingInputState;
    _handlingRequest = isLoading;
    _setLoading(isLoading);

    handleInputData(inputState)
        .then((result) {
          handleResult(result);
        })
        .whenComplete(() => _handlingRequest = false)
        .onError((error, _) {
          _log.severe("Input state error", error);
          _handlingRequest = false;
          _setLoading(false);
          if (error != null) {
            final context = contextProvider?.getBuildContext();
            if (context != null && context.mounted) {
              showFlushbar(context, message: ExceptionHandler.extractMessage(error, context.texts()));
            } else {
              _log.info("Skipping handling of error: $error because context is null");
            }
          }
        });
  }

  void handleResult(Object result) {
    _log.info("Input state handled: $result");
    if (result is LNURLPageResult && result.protocol != null) {
      final context = contextProvider?.getBuildContext();
      if (context != null) {
        handleLNURLPageResult(context, result);
      } else {
        _log.info("Skipping handling of result: $result because context is null");
      }
    }
  }

  Future handleInputData(InputState inputState) async {
    _log.info("handle input $inputState");
    final context = contextProvider?.getBuildContext();
    if (context == null) {
      _log.info("Not handling input $inputState because context is null");
      return;
    }

    if (inputState is InvoiceInputState) {
      return handleInvoice(context, inputState.invoice);
    } else if (inputState is LnUrlPayInputState) {
      handlePayRequest(context, firstPaymentItemKey, inputState.data);
    } else if (inputState is LnUrlWithdrawInputState) {
      handleWithdrawRequest(context, inputState.data);
    } else if (inputState is LnUrlAuthInputState) {
      handleAuthRequest(context, inputState.data);
    } else if (inputState is LnUrlErrorInputState) {
      throw inputState.data.reason;
    } else if (inputState is NodeIdInputState) {
      return handleNodeID(context, inputState.nodeId);
    } else if (inputState is BitcoinAddressInputState) {
      return handleBitcoinAddress(context, inputState);
    }
  }

  Future handleInvoice(BuildContext context, Invoice invoice) async {
    _log.info("handle invoice $invoice");
    return await showDialog(
      useRootNavigator: false,
      context: context,
      barrierDismissible: false,
      builder: (_) => PaymentRequestDialog(invoice, firstPaymentItemKey),
    );
  }

  Future handleNodeID(BuildContext context, String nodeID) async {
    _log.info("handle node id $nodeID");
    return await Navigator.of(
      context,
    ).push(FadeInRoute(builder: (_) => SpontaneousPaymentPage(nodeID, firstPaymentItemKey)));
  }

  Future handleBitcoinAddress(BuildContext context, BitcoinAddressInputState inputState) async {
    _log.fine("handle bitcoin address $inputState");
    if (inputState.source == InputSource.qrcode_reader) {
      return await Navigator.of(context).pushNamed("/reverse_swap", arguments: inputState.data);
    }
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
