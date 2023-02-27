import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_sdk/sdk.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/input/input_bloc.dart';
import 'package:c_breez/bloc/input/input_state.dart';
import 'package:c_breez/routes/create_invoice/widgets/successful_payment.dart';
import 'package:c_breez/routes/lnurl/lnurl_invoice_delegate.dart';
import 'package:c_breez/routes/lnurl/payment/pay_response.dart';
import 'package:c_breez/routes/lnurl/payment/success_action/success_action_dialog.dart';
import 'package:c_breez/routes/lnurl/withdraw/withdraw_response.dart';
import 'package:c_breez/routes/spontaneous_payment/spontaneous_payment_page.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:c_breez/widgets/open_link_dialog.dart';
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

  Future handleInput(InputState inputState) async {
    _log.v("handle input ${inputState.protocol}");
    switch (inputState.protocol) {
      case InputProtocol.paymentRequest:
        return handleInvoice(inputState.inputData);
      case InputProtocol.lnurl:
        return handleLNURL(_context, inputState.inputData, firstPaymentItemKey);
      case InputProtocol.nodeID:
        return handleNodeID(inputState.inputData);
      case InputProtocol.appLink:
      case InputProtocol.webView:
        return handleWebAddress(inputState.inputData);
      default:
        break;
    }
  }

  Future handleInvoice(dynamic invoice) async {
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
    return await Navigator.of(_context).push(
      FadeInRoute(
        builder: (_) => SpontaneousPaymentPage(
          nodeID,
          firstPaymentItemKey,
        ),
      ),
    );
  }

  Future handleWebAddress(String url) async {
    return await showDialog(
      useRootNavigator: false,
      context: _context,
      barrierDismissible: false,
      builder: (_) => OpenLinkDialog(url),
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
    handleInput(inputState)
        .then((result) {
          _log.v("Input state handled: $result");
          if (result is LNURLPaymentPageResult) {
            _handleLNURLPaymentPageResult(result);
          } else if (result is LNURLWithdrawPageResult) {
            _handleLNURLWithdrawPageResult(result);
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

  void _handleLNURLPaymentPageResult(LNURLPaymentPageResult result) {
    if (result.successAction != null) {
      _handleSuccessAction(result.successAction!);
    } else {
      _log.v("Handle LNURL withdraw page result with error '${result.error}'");
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

  void _handleLNURLWithdrawPageResult(LNURLWithdrawPageResult result) {
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
