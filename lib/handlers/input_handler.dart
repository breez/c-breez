import 'package:breez_sdk/sdk.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/input/input_bloc.dart';
import 'package:c_breez/bloc/input/input_state.dart';
import 'package:c_breez/routes/lnurl/lnurl_invoice_delegate.dart';
import 'package:c_breez/routes/spontaneous_payment/spontaneous_payment_page.dart';
import 'package:c_breez/utils/lnurl.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:c_breez/widgets/payment_dialogs/payment_request_dialog.dart'
    as payment_request;
import 'package:dart_lnurl/dart_lnurl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/open_link_dialog.dart';
import '../widgets/route.dart';

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
      // Display a loader while input is being parsed
      // Remove loader if input can't be parsed
      if (inputState.inputData == null) {
        _setLoading(inputState.isLoading!);
        return;
      }
      _setLoading(false);
      _handlingRequest = true;
      handleInput(inputState);
    }).onError((error) {
      _handlingRequest = false;
      _setLoading(false);
      showFlushbar(_context, message: error.toString());
    });
    // Handle LNURL Success Action
    final AccountBloc accountBloc = _context.read<AccountBloc>();
    accountBloc.lnurlPayResultStream.listen((payResult) {
      handleSuccessAction(_context, payResult);
    });
  }

  void handleInput(InputState inputState) {
    switch (inputState.protocol) {
      case InputProtocol.paymentRequest:
        handleInvoice(inputState.inputData);
        return;
      case InputProtocol.lnurl:
        handleLNURL(
          _context,
          inputState.inputData,
        ).onError((error, stackTrace) {
          showFlushbar(_context, message: error.toString());
        }).then((pageResult) {
          if (pageResult is LNURLPayResult) {
            final AccountBloc accountBloc = _context.read<AccountBloc>();
            LNURLPaySuccessAction? successAction = pageResult.successAction;
            if (successAction != null) {
              accountBloc.lnurlPayResultSink.add(pageResult);
            }
          }
        }).whenComplete(() {
          _handlingRequest = false;
        });
        return;
      case InputProtocol.nodeID:
        handleNodeID(inputState.inputData);
        return;
      case InputProtocol.appLink:
      case InputProtocol.webView:
        handleWebAddress(inputState.inputData);
        return;
      default:
        break;
    }
  }

  void handleInvoice(dynamic invoice) {
    showDialog(
      useRootNavigator: false,
      context: _context,
      barrierDismissible: false,
      builder: (_) => payment_request.PaymentRequestDialog(
        invoice,
        firstPaymentItemKey,
        scrollController,
        () => _handlingRequest = false,
      ),
    );
  }

  void handleNodeID(String nodeID) {
    _handlingRequest = false;
    Navigator.of(_context).push(
      FadeInRoute(
        builder: (_) => SpontaneousPaymentPage(
          nodeID,
          firstPaymentItemKey,
        ),
      ),
    );
  }

  void handleWebAddress(String url) {
    _handlingRequest = false;
    showDialog(
      useRootNavigator: false,
      context: _context,
      barrierDismissible: false,
      builder: (_) => OpenLinkDialog(url),
    );
  }

  _setLoading(bool visible) {
    if (visible && _loaderRoute == null) {
      _loaderRoute = createLoaderRoute(_context);
      Navigator.of(_context).push(_loaderRoute!);
      return;
    }

    if (!visible && _loaderRoute != null) {
      Navigator.removeRoute(_context, _loaderRoute!);
      _loaderRoute = null;
    }
  }
}
