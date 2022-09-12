import 'package:another_flushbar/flushbar.dart';
import 'package:c_breez/bloc/connectivity/connectivity_bloc.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConnectivityHandler {
  final BuildContext context;
  final ConnectivityBloc connectivityBloc;
  late Flushbar flushbar;

  ConnectivityHandler(this.context, this.connectivityBloc) {
    flushbar = _getNoConnectionFlushbar();
    connectivityBloc.stream.listen((connectionStatus) {
      if (connectionStatus == ConnectivityResult.none) {
        showNoInternetConnectionFlushbar();
      } else if (flushbar.isShowing() || flushbar.isAppearing()) {
        flushbar.dismiss(true);
      }
    });
  }

  void showNoInternetConnectionFlushbar() {
    if (flushbar.isShowing() || flushbar.isAppearing()) {
      flushbar.dismiss(true);
    }
    flushbar.show(context);
  }

  Flushbar _getNoConnectionFlushbar() {
    final texts = AppLocalizations.of(context)!;

    Flushbar? noConnectionFlushbar;
    noConnectionFlushbar = Flushbar(
      isDismissible: false,
      flushbarPosition: FlushbarPosition.TOP,
      icon: Icon(
        Icons.warning_amber_outlined,
        size: 28.0,
        color: Theme.of(context).errorColor,
      ),
      messageText: Text(
        texts.no_connection_flushbar_title,
        style: theme.snackBarStyle,
        textAlign: TextAlign.center,
      ),
      mainButton: TextButton(
        onPressed: () {
          noConnectionFlushbar!.dismiss(true);
          const closeAnimDur = Duration(seconds: 1);
          Future.delayed(
            closeAnimDur,
            () async => connectivityBloc.checkConnectivity(),
          );
        },
        child: Text(
          texts.invoice_btc_address_action_retry,
          style: theme.snackBarStyle.copyWith(
            color: Theme.of(context).errorColor,
          ),
        ),
      ),
      backgroundColor: theme.snackBarBackgroundColor,
    );

    return noConnectionFlushbar;
  }
}
