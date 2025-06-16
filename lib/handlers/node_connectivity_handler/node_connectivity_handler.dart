import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/sdk_connectivity/sdk_connectivity_cubit.dart';
import 'package:c_breez/bloc/sdk_connectivity/sdk_connectivity_state.dart';
import 'package:c_breez/handlers/handlers.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger("NodeConnectivityHandler");

class NodeConnectivityHandler extends Handler {
  StreamSubscription<SdkConnectivityState>? _subscription;
  Flushbar? _flushbar;

  @override
  void init(HandlerContextProvider<StatefulWidget> contextProvider) {
    super.init(contextProvider);
    _subscription = contextProvider
        .getBuildContext()!
        .read<SdkConnectivityCubit>()
        .stream
        .distinct((previous, next) => previous == next || next == SdkConnectivityState.connecting)
        .listen((a) => _listen(a));
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
    _subscription = null;
    _flushbar = null;
  }

  void _listen(SdkConnectivityState? connectionStatus) async {
    _log.info("Received accountState $connectionStatus");
    if (connectionStatus == SdkConnectivityState.disconnected) {
      showDisconnectedFlushbar();
    } else if (connectionStatus == SdkConnectivityState.connected) {
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

  void dismissFlushbarIfNeed() async {
    final flushbar = _flushbar;
    if (flushbar == null) return;

    if (flushbar.flushbarRoute != null && flushbar.flushbarRoute!.isActive) {
      final context = contextProvider?.getBuildContext();
      if (context == null) {
        _log.info("Skipping dismissing node connectivity flushbar as context is null");
        return;
      }
      Navigator.of(context).removeRoute(flushbar.flushbarRoute!);
    }
    _flushbar = null;
  }

  Flushbar? _getDisconnectedFlushbar(BuildContext context) {
    return Flushbar(
      isDismissible: false,
      flushbarPosition: FlushbarPosition.TOP,
      icon: Icon(Icons.warning_amber_outlined, size: 28.0, color: Theme.of(context).colorScheme.error),
      messageText: Text(
        context.texts().handler_channel_connection_message,
        style: theme.snackBarStyle,
        textAlign: TextAlign.center,
      ),
      mainButton: SizedBox(
        width: 64,
        child: StreamBuilder<SdkConnectivityState>(
          stream: context.read<SdkConnectivityCubit>().stream,
          builder: (context, snapshot) {
            var themeData = Theme.of(context);
            if (snapshot.hasData && snapshot.data == SdkConnectivityState.connecting) {
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
                final SdkConnectivityCubit sdkConnectivityCubit = context.read<SdkConnectivityCubit>();
                Future.delayed(const Duration(milliseconds: 500), () async {
                  try {
                    await sdkConnectivityCubit.reconnect();
                  } catch (error) {
                    _log.severe("Failed to reconnect");
                    rethrow;
                  }
                });
              },
              child: Text(
                context.texts().no_connection_flushbar_action_retry,
                style: theme.snackBarStyle.copyWith(color: themeData.colorScheme.error),
              ),
            );
          },
        ),
      ),
      backgroundColor: theme.snackBarBackgroundColor,
    );
  }
}
