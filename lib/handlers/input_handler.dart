import 'package:c_breez/bloc/input/input_bloc.dart';
import 'package:c_breez/routes/lnurl/lnurl_payment_dialog.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:c_breez/widgets/payment_dialogs/payment_request_dialog.dart'
    as payment_request;
import 'package:dart_lnurl/dart_lnurl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../routes/lnurl/lnurl_payment_page.dart';
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
    _context.read<InputBloc>().stream.listen((invoiceState) {
      if (_handlingRequest || invoiceState.invoice == null) {
        return;
      }
      _handlingRequest = true;
      showDialog(
        useRootNavigator: false,
        context: _context,
        barrierDismissible: false,
        builder: (_) => payment_request.PaymentRequestDialog(
          invoiceState.invoice!,
          firstPaymentItemKey,
          scrollController,
          () => _handlingRequest = false,
        ),
      );
    }).onError((error) {
      _setLoading(false);
      showFlushbar(_context, message: error.toString());
    });
    _context.read<InputBloc>().lnurlParseResultStream.listen((parseResult) {
      if (_handlingRequest) {
        return;
      }
      _handlingRequest = true;
      switch (parseResult.runtimeType) {
        case LNURLPayParams:
          bool fixedAmount = parseResult.minSendable == parseResult.maxSendable;
          if (fixedAmount && !(parseResult.commentAllowed > 0)) {
            showDialog(
              useRootNavigator: false,
              context: _context,
              barrierDismissible: false,
              builder: (_) => LNURLPaymentDialog(
                parseResult,
                onComplete: () {
                  Navigator.pop(_context);
                  _handlingRequest = false;
                  throw Exception("Not implemented");
                },
                onCancel: () {
                  Navigator.pop(_context);
                  _handlingRequest = false;
                  throw Exception("Payment Cancelled");
                },
              ),
            );
          } else {
            Navigator.of(_context).push(
              FadeInRoute(
                builder: (_) => LNURLPaymentPage(
                    payParams: parseResult,
                    onSubmit: (payerDataMap) {
                      var amount = payerDataMap["amount"];
                      var comment = payerDataMap["comment"];
                      var payerData = payerDataMap["payerData"];
                      debugPrint(payerDataMap.toString());
                    }),
              ),
            );
            _handlingRequest = false;
          }
          break;
        case LNURLWithdrawParams:
          _handlingRequest = false;
          throw Exception("Withdraw is not implemented yet.");
        default:
          _handlingRequest = false;
          throw Exception("Not implemented.");
      }
    }).onError((error) {
      _setLoading(false);
      showFlushbar(_context, message: error.toString());
    });
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
