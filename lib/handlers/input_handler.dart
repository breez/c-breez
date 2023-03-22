import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/input/input_bloc.dart';
import 'package:c_breez/bloc/input/input_state.dart';
import 'package:c_breez/models/invoice.dart';
import 'package:c_breez/routes/create_invoice/widgets/successful_payment.dart';

import 'package:c_breez/routes/lnurl/lnurl_invoice_delegate.dart';
import 'package:c_breez/routes/lnurl/payment/success_action/success_action_dialog.dart';
import 'package:c_breez/routes/lnurl/widgets/lnurl_page_result.dart';
import 'package:c_breez/routes/spontaneous_payment/spontaneous_payment_page.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:c_breez/widgets/payment_dialogs/payment_request_dialog.dart';
import 'package:c_breez/widgets/route.dart';
import 'package:c_breez/widgets/transparent_page_route.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _log = FimberLog("InputHandler");

class InputHandler {
  final BuildContext _context;
  final GlobalKey firstPaymentItemKey;
  final ScrollController scrollController;
  final GlobalKey<ScaffoldState> scaffoldController;

  ModalRoute? _loaderRoute;
  bool _handlingRequest = false;

  InputHandler(
    this._context,
    this.firstPaymentItemKey,
    this.scrollController,
    this.scaffoldController,
  ) {
    final InputBloc inputBloc = _context.read<InputBloc>();

    inputBloc.stream.listen(_handleInputState).onError((error) {
      _handlingRequest = false;
      _setLoading(false);
    });
  }

  Future handleInputData(dynamic parsedInput) async {
    _log.v("handle input $parsedInput");
    if (parsedInput is Invoice) {
      return handleInvoice(parsedInput);
    } else if (parsedInput is InputType_LnUrlPay ||
        parsedInput is InputType_LnUrlWithdraw ||
        parsedInput is InputType_LnUrlAuth ||
        parsedInput is InputType_LnUrlError) {
      return handleLNURL(_context, firstPaymentItemKey, parsedInput.data);
    } else if (parsedInput is InputType_NodeId) {
      return handleNodeID(parsedInput.nodeId);
    }
  }

  Future handleInvoice(Invoice invoice) async {
    _log.v("handle invoice $invoice");
    return await showDialog(
      useRootNavigator: false,
      context: _context,
      barrierDismissible: false,
      builder: (_) => PaymentRequestDialog(
        invoice,
        firstPaymentItemKey,
        scrollController,
      ),
    );
  }

  Future handleNodeID(String nodeID) async {
    _log.v("handle node id $nodeID");
    return await Navigator.of(_context).push(
      FadeInRoute(
        builder: (_) => SpontaneousPaymentPage(
          nodeID,
          firstPaymentItemKey,
        ),
      ),
    );
  }

  void _handleInputState(InputState inputState) {
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
            _handleLNURLPageResult(result);
          }
        })
        .whenComplete(() => _handlingRequest = false)
        .onError((error, _) {
          _log.e("Input state error", ex: error);
          _handlingRequest = false;
          _setLoading(false);
          if (error != null) {
            showFlushbar(_context, message: extractExceptionMessage(error, _context.texts()));
          }
        });
  }

  void _handleLNURLPageResult(LNURLPageResult result) {
    switch (result.protocol) {
      case LnUrlProtocol.Pay:
        _handleLNURLPaymentPageResult(result);
        break;
      case LnUrlProtocol.Withdraw:
        _handleLNURLWithdrawPageResult(result);
        break;
      case LnUrlProtocol.Auth:
        _handleLNURLAuthPageResult(result);
        break;
      default:
        break;
    }
  }

  void _handleLNURLPaymentPageResult(LNURLPageResult result) {
    if (result.successAction != null) {
      _handleSuccessAction(result.successAction!);
    } else {
      _log.v("Handle LNURL payment page result with error '${result.error}'");
      throw Exception(
        extractExceptionMessage(
          result.error!,
          _context.texts(),
          defaultErrorMsg: _context.texts().lnurl_payment_page_unknown_error,
        ),
      );
    }
  }

  Future _handleSuccessAction(SuccessActionProcessed successAction) {
    String message = '';
    String? url;
    if (successAction is SuccessActionProcessed_Message) {
      message = successAction.data.message;
      _log.v("Handle LNURL payment page result with message action '$message'");
    } else if (successAction is SuccessActionProcessed_Url) {
      message = successAction.data.description;
      url = successAction.data.url;
      _log.v("Handle LNURL payment page result with url action '$message', '$url'");
    } else if (successAction is SuccessActionProcessed_Aes) {
      message = "${successAction.data.description} ${successAction.data.plaintext}";
      _log.v("Handle LNURL payment page result with aes action '$message'");
    }
    // Artificial delay for UX purposes
    return Future.delayed(const Duration(seconds: 1)).then(
      (_) => showDialog(
        useRootNavigator: false,
        context: _context,
        builder: (_) => SuccessActionDialog(
          message: message,
          url: url,
        ),
      ),
    );
  }

  void _handleLNURLWithdrawPageResult(LNURLPageResult result) {
    if (result.error == null) {
      _log.v("Handle LNURL withdraw page result with success");
      Navigator.of(_context).push(
        TransparentPageRoute((ctx) => const SuccessfulPaymentRoute()),
      );
    } else {
      _log.v("Handle LNURL withdraw page result with error '${result.error}'");
      throw result.error!;
    }
  }

  void _handleLNURLAuthPageResult(LNURLPageResult result) {
    if (result.error != null) {
      _log.v("Handle LNURL auth page result with error '${result.error}'");
      throw result.error!;
    }
  }

  _setLoading(bool visible) {
    if (visible && _loaderRoute == null) {
      _loaderRoute = createLoaderRoute(_context);
      Navigator.of(_context).push(_loaderRoute!);
      return;
    }

    if (!visible && _loaderRoute != null) {
      _loaderRoute?.navigator?.removeRoute(_loaderRoute!);
      _loaderRoute = null;
    }
  }
}
