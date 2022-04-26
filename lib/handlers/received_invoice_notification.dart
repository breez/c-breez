import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/invoice/invoice_bloc.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:c_breez/widgets/payment_request_dialog.dart' as paymentRequest;
import 'package:flutter/material.dart';

class InvoiceNotificationsHandler {
  final BuildContext _context;
  final AccountBloc _accountBloc;
  final InvoiceBloc _invoiceBloc;
  final GlobalKey firstPaymentItemKey;
  final ScrollController scrollController;
  final GlobalKey<ScaffoldState> scaffoldController;

  ModalRoute? _loaderRoute;
  bool _handlingRequest = false;

  InvoiceNotificationsHandler(
      this._context,
      this._accountBloc,
      this._invoiceBloc,
      this.firstPaymentItemKey,
      this.scrollController,
      this.scaffoldController) {
    _listenPaymentRequests();
  }

  _listenPaymentRequests() {
    _invoiceBloc.stream.listen((invoiceState) {
      if (_handlingRequest || invoiceState.invoice == null) {
        return;
      }
      _handlingRequest = true;
      showDialog(
          useRootNavigator: false,
          context: _context,
          barrierDismissible: false,
          builder: (_) => paymentRequest.PaymentRequestDialog(
                  _context,
                  _accountBloc,
                  invoiceState.invoice!,
                  firstPaymentItemKey,
                  scrollController, () {
                _handlingRequest = false;
              }));
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
