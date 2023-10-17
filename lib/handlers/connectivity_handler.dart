import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/connectivity/connectivity_bloc.dart';
import 'package:c_breez/bloc/connectivity/connectivity_state.dart';
import 'package:c_breez/handlers/handler.dart';
import 'package:c_breez/handlers/handler_context_provider.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _log = Logger("ConnectivityHandler");

class ConnectivityHandler extends Handler {
  StreamSubscription<ConnectivityState>? _subscription;
  Flushbar? _flushbar;

  @override
  void init(HandlerContextProvider<StatefulWidget> contextProvider) {
    super.init(contextProvider);
    _subscription = contextProvider
        .getBuildContext()!
        .read<ConnectivityBloc>()
        .stream
        .distinct((previous, next) => previous.lastStatus == next.lastStatus)
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
    _log.info("Received connectivityState $connectivityState");
    if (connectivityState.lastStatus == ConnectivityResult.none) {
      showNoInternetConnectionFlushbar();
    } else {
      dismissFlushbarIfNeed();
    }
  }

  void showNoInternetConnectionFlushbar() {
    dismissFlushbarIfNeed();
    final context = contextProvider?.getBuildContext();
    if (context == null) {
      _log.info("Skipping connection flushbar as context is null");
      return;
    }
    _flushbar = _getNoConnectionFlushbar(context);
    _flushbar?.show(context);
  }

  void dismissFlushbarIfNeed() {
    final flushbar = _flushbar;
    if (flushbar == null) return;

    if (flushbar.isShowing() || flushbar.isAppearing()) {
      flushbar.dismiss(true);
    }
    _flushbar = null;
  }

  Flushbar? _getNoConnectionFlushbar(BuildContext context) {
    return Flushbar(
      isDismissible: false,
      flushbarPosition: FlushbarPosition.TOP,
      icon: Icon(
        Icons.warning_amber_outlined,
        size: 28.0,
        color: Theme.of(context).colorScheme.error,
      ),
      messageText: Text(
        context.texts().no_connection_flushbar_title,
        style: theme.snackBarStyle,
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
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              );
            }
            return TextButton(
              onPressed: () {
                context.read<ConnectivityBloc>().setIsConnecting(true);
                Future.delayed(
                  const Duration(seconds: 1),
                  () => context
                      .read<ConnectivityBloc>()
                      .checkConnectivity()
                      .whenComplete(() => context.read<ConnectivityBloc>().setIsConnecting(false))
                      .onError((error, stackTrace) {
                    context.read<ConnectivityBloc>().setIsConnecting(false);
                    throw error.toString();
                  }),
                );
              },
              child: Text(
                context.texts().no_connection_flushbar_action_retry,
                style: theme.snackBarStyle.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            );
          },
        ),
      ),
      backgroundColor: theme.snackBarBackgroundColor,
    );
  }
}
