// ignore_for_file: unused_local_variable

import 'package:c_breez/bloc/input/input_bloc.dart';
import 'package:c_breez/routes/lnurl/add_payer_data_page.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:c_breez/widgets/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LNURLHandler {
  final BuildContext _context;
  final GlobalKey firstPaymentItemKey;
  final ScrollController scrollController;
  final GlobalKey<ScaffoldState> scaffoldController;

  ModalRoute? _loaderRoute;

  LNURLHandler(
    this._context,
    this.firstPaymentItemKey,
    this.scrollController,
    this.scaffoldController,
  ) {
    _context.read<InputBloc>().lnurlPaymentStream.listen((payParams) {
      Navigator.of(_context).push(
        FadeInRoute(
          builder: (_) => AddPayerDataPage(
              payParams: payParams,
              onSubmit: (payerDataMap) {
                var amount = payerDataMap["amount"];
                var comment = payerDataMap["comment"];
                var payerData = payerDataMap["payerData"];
                debugPrint(payerDataMap.toString());
              }),
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
