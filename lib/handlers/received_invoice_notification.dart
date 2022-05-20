import 'package:c_breez/bloc/invoice/invoice_bloc.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:c_breez/widgets/payment_request_dialog.dart' as payment_request;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvoiceNotificationsHandler {
  final BuildContext _context;
  final GlobalKey firstPaymentItemKey;
  final ScrollController scrollController;
  final GlobalKey<ScaffoldState> scaffoldController;

  ModalRoute? _loaderRoute;
  bool _handlingRequest = false;

  InvoiceNotificationsHandler(
    this._context,
    this.firstPaymentItemKey,
    this.scrollController,
    this.scaffoldController,
  ) {
    _context.read<InvoiceBloc>().stream.listen((invoiceState) {
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
