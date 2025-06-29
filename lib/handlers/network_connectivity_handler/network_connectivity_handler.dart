import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/connectivity/connectivity_bloc.dart';
import 'package:c_breez/bloc/connectivity/connectivity_state.dart';
import 'package:c_breez/handlers/handlers.dart';
import 'package:c_breez/theme/theme_extensions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('NetworkConnectivityHandler');

class NetworkConnectivityHandler extends Handler {
  StreamSubscription<ConnectivityState>? _subscription;
  Flushbar<dynamic>? _flushbar;

  @override
  void init(HandlerContextProvider<StatefulWidget> contextProvider) {
    super.init(contextProvider);
    _subscription = contextProvider
        .getBuildContext()!
        .read<ConnectivityBloc>()
        .stream
        .distinct(
          (ConnectivityState previous, ConnectivityState next) => previous.lastStatus == next.lastStatus,
        )
        .listen(_listen);
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
    _subscription = null;
    _flushbar = null;
  }

  void _listen(ConnectivityState connectivityState) async {
    _logger.info("Received connectivityState $connectivityState");
    if (connectivityState.lastStatus != null &&
        connectivityState.lastStatus!.contains(ConnectivityResult.none)) {
      showNoInternetConnectionFlushbar();
    } else {
      dismissFlushbarIfNeed();
    }
  }

  void showNoInternetConnectionFlushbar() {
    dismissFlushbarIfNeed();
    final BuildContext? context = contextProvider?.getBuildContext();
    if (context == null) {
      _logger.info('Skipping connection flushbar as context is null');
      return;
    }
    _flushbar = _getNoConnectionFlushbar(context);
    _flushbar?.show(context);
  }

  void dismissFlushbarIfNeed() async {
    final Flushbar<dynamic>? flushbar = _flushbar;
    if (flushbar == null) {
      return;
    }

    if (flushbar.flushbarRoute != null && flushbar.flushbarRoute!.isActive) {
      final BuildContext? context = contextProvider?.getBuildContext();
      if (context == null) {
        _logger.info('Skipping dismissing connection flushbar as context is null');
        return;
      }
      Navigator.of(context).removeRoute(flushbar.flushbarRoute!);
    }
    _flushbar = null;
  }

  Flushbar<dynamic>? _getNoConnectionFlushbar(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Flushbar<dynamic>(
      isDismissible: false,
      flushbarPosition: FlushbarPosition.TOP,
      icon: Icon(Icons.warning_amber_outlined, size: 28.0, color: themeData.colorScheme.error),
      messageText: Text(
        context.texts().no_connection_flushbar_title,
        style: snackBarStyle,
        textAlign: TextAlign.center,
      ),
      mainButton: SizedBox(
        width: 64,
        child: StreamBuilder<ConnectivityState>(
          stream: context.read<ConnectivityBloc>().stream,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data?.isConnecting == true) {
              return Center(
                child: SizedBox(
                  height: 24.0,
                  width: 24.0,
                  child: CircularProgressIndicator(color: themeData.colorScheme.error),
                ),
              );
            }
            return TextButton(
              onPressed: () {
                final connectivityBloc = context.read<ConnectivityBloc>();
                connectivityBloc.setIsConnecting(true);
                Future.delayed(
                  const Duration(seconds: 1),
                  () => connectivityBloc
                      .checkConnectivity()
                      .whenComplete(() => connectivityBloc.setIsConnecting(false))
                      .onError((error, stackTrace) {
                        connectivityBloc.setIsConnecting(false);
                        throw error.toString();
                      }),
                );
              },
              child: Text(
                context.texts().no_connection_flushbar_action_retry,
                style: snackBarStyle.copyWith(color: themeData.colorScheme.error),
              ),
            );
          },
        ),
      ),
      backgroundColor: snackBarBackgroundColor,
    );
  }
}
