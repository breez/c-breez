import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/handlers/handler.dart';
import 'package:c_breez/handlers/handler_context_provider.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger("NodeConnectivityHandler");

class NodeConnectivityHandler extends Handler {
  StreamSubscription<AccountState>? _subscription;
  Flushbar? _flushbar;

  @override
  void init(HandlerContextProvider<StatefulWidget> contextProvider) {
    super.init(contextProvider);
    _subscription = contextProvider
        .getBuildContext()!
        .read<AccountBloc>()
        .stream
        .distinct((previous, next) =>
            previous.connectionStatus == next.connectionStatus ||
            next.connectionStatus == ConnectionStatus.CONNECTING)
        .listen((a) => _listen(a.connectionStatus));
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
    _subscription = null;
    _flushbar = null;
  }

  void _listen(ConnectionStatus? connectionStatus) async {
    _log.info("Received accountState $connectionStatus");
    if (connectionStatus == ConnectionStatus.DISCONNECTED) {
      showDisconnectedFlushbar();
    } else if (connectionStatus == ConnectionStatus.CONNECTED) {
      dismissFlushbarIfNeed();
    }
  }

  void showDisconnectedFlushbar() {
    dismissFlushbarIfNeed();
    final context = contextProvider?.getBuildContext();
    if (context == null) {
      _log.info("Skipping connection flushbar as context is null");
      return;
    }
    _flushbar = _getDisconnectedFlushbar(context);
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

  Flushbar? _getDisconnectedFlushbar(BuildContext context) {
    return Flushbar(
      isDismissible: false,
      flushbarPosition: FlushbarPosition.TOP,
      icon: Icon(
        Icons.warning_amber_outlined,
        size: 28.0,
        color: Theme.of(context).colorScheme.error,
      ),
      messageText: Text(
        context.texts().handler_channel_connection_message,
        style: theme.snackBarStyle,
        textAlign: TextAlign.center,
      ),
      mainButton: SizedBox(
        width: 64,
        child: StreamBuilder<AccountState>(
          stream: context.read<AccountBloc>().stream,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data?.connectionStatus == ConnectionStatus.CONNECTING) {
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
                final accountBloc = context.read<AccountBloc>();
                Future.delayed(const Duration(milliseconds: 500), () async {
                  try {
                    await accountBloc.connect();
                  } catch (error) {
                    _log.severe("Failed to reconnect");
                    rethrow;
                  }
                });
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
