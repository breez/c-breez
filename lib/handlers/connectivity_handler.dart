import 'package:another_flushbar/flushbar.dart';
import 'package:c_breez/bloc/connectivity/connectivity_bloc.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConnectivityHandler {
  final BuildContext context;
  late Flushbar flushbar;

  ConnectivityHandler(this.context) {
    flushbar = _getNoConnectionFlushbar();
    final ConnectivityBloc connectivityBloc = context.read<ConnectivityBloc>();
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

    Flushbar? flush;
    flush = Flushbar(
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
      backgroundColor: theme.snackBarBackgroundColor,
    );

    return flush;
  }
}
