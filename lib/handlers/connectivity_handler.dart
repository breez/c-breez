import 'package:another_flushbar/flushbar.dart';
import 'package:c_breez/services/connectivity_service.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/widgets/flushbar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConnectivityHandler {
  final BuildContext context;

  ConnectivityHandler(this.context) {
    final connectivityService = ServiceInjector().connectivityService;
    connectivityService.connectivityEventStream.listen((connectionStatus) {
      if (connectionStatus == ConnectivityResult.none) {
        showNoInternetConnectionFlushbar(connectivityService);
      } else {
        popFlushbars(context);
      }
    });
  }

  void showNoInternetConnectionFlushbar(
      ConnectivityService connectivityService) {
    final texts = AppLocalizations.of(context)!;
    popFlushbars(context);
    showFlushbar(
      context,
      position: FlushbarPosition.TOP,
      icon: Icon(
        Icons.warning_amber_outlined,
        size: 28.0,
        color: Theme.of(context).errorColor,
      ),
      messageWidget: Text(
        texts.no_connection_flushbar_title,
        style: theme.snackBarStyle,
        textAlign: TextAlign.center,
      ),
      isDismissible: false,
      duration: Duration.zero,
    );
  }
}
