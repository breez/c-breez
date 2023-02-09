import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_sdk/sdk.dart';
import 'package:c_breez/bloc/input/input_bloc.dart';
import 'package:c_breez/bloc/input/input_state.dart';
import 'package:c_breez/routes/lnurl/lnurl_invoice_delegate.dart';
import 'package:c_breez/routes/lnurl/payment/pay_response.dart';
import 'package:c_breez/routes/spontaneous_payment/spontaneous_payment_page.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:c_breez/widgets/open_link_dialog.dart';
import 'package:c_breez/widgets/payment_dialogs/payment_request_dialog.dart';
import 'package:c_breez/widgets/route.dart';
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
    inputBloc.stream.listen((inputState) {
      if (_handlingRequest) {
        return;
      }
      _setLoading(inputState.isLoading);
      _handlingRequest = true;
      handleInput(inputState)
          .then((result) {
            if (result is LNURLPaymentPageResult) {
              _handleLNURLPaymentPageResult(result);
            }
          })
          .whenComplete(() => _handlingRequest = false)
          .onError((error, _) {
            _handlingRequest = false;
            _setLoading(false);
            if (error != null) {
              showFlushbar(_context, message: extractExceptionMessage(error));
            }
          });
    }).onError((error) {
      _handlingRequest = false;
      _setLoading(false);
    });
  }

  Future handleInput(InputState inputState) async {
    switch (inputState.protocol) {
      case InputProtocol.paymentRequest:
        return handleInvoice(inputState.inputData);
      case InputProtocol.lnurl:
        return handleLNURL(_context, inputState.inputData);
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

  void _handleLNURLPaymentPageResult(LNURLPaymentPageResult result) {
    final action = result.successAction;
    if (action is SuccessAction_Message) {
      final message = action.field0.message;
      _log.v("Handle LNURL payment page result with message action '$message'");
    } else if (action is SuccessAction_Url) {
      final description = action.field0.description;
      final url = action.field0.url;
      _log.v(
          "Handle LNURL payment page result with url action '$description', '$url'");
    } else {
      _log.v("Handle LNURL payment page result with unknown action '$action'");
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
