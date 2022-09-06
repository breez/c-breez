import 'dart:async';

import 'package:c_breez/services/connectivity_service.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<bool?> showNoConnectionDialog(
    BuildContext context, ConnectivityService connectivityService) async {
  bool isDialogBeingShown =
      await connectivityService.c10yDialogEventStream.first;
  if (!isDialogBeingShown) {
    return showDialog<bool>(
      useRootNavigator: false,
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => NoConnectionDialog(
        connectivityService: connectivityService,
      ),
    ).whenComplete(() => connectivityService.c10yDialogEventSink.add(false));
  }
  return null;
}

class NoConnectionDialog extends StatefulWidget {
  final ConnectivityService connectivityService;

  const NoConnectionDialog({
    Key? key,
    required this.connectivityService,
  }) : super(key: key);

  @override
  State<NoConnectionDialog> createState() => _NoConnectionDialogState();
}

class _NoConnectionDialogState extends State<NoConnectionDialog> {
  late StreamSubscription c10yResultSubscription;

  @override
  void initState() {
    super.initState();
    widget.connectivityService.c10yDialogEventSink.add(true);
    listenConnectivityChanges();
  }

  listenConnectivityChanges() {
    c10yResultSubscription = widget.connectivityService.connectivityEventStream
        .listen((connectionStatus) {
      if (connectionStatus != ConnectivityResult.none) {
        widget.connectivityService.c10yDialogEventSink.add(false);
        Navigator.of(context).pop(false);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.connectivityService.c10yDialogEventSink.add(false);
    c10yResultSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final dialogTheme = themeData.dialogTheme;
    final texts = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);

    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      title: Text(texts.no_connection_dialog_title),
      content: SingleChildScrollView(
        child: RichText(
          text: TextSpan(
            text: texts.no_connection_dialog_tip_begin,
            style: dialogTheme.contentTextStyle,
            // This text style applies to children
            children: [
              TextSpan(text: texts.no_connection_dialog_tip_airplane),
              TextSpan(text: texts.no_connection_dialog_tip_wifi),
              TextSpan(text: texts.no_connection_dialog_tip_signal),
              const TextSpan(text: "• "),
              TextSpan(
                text: texts.no_connection_dialog_log_view_action,
                style: theme.blueLinkStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    // ShareExtend.share(
                    //   await ServiceInjector().breezBridge.getLogPath(),
                    //   "file",
                    // );
                  },
              ),
              TextSpan(text: texts.no_connection_dialog_log_view_message),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            texts.no_connection_dialog_action_cancel,
            style: themeData.primaryTextTheme.button,
          ),
          onPressed: () => navigator.pop(false),
        ),
        TextButton(
          child: Text(
            texts.no_connection_dialog_action_try_again,
            style: themeData.primaryTextTheme.button,
          ),
          onPressed: () => navigator.pop(true),
        ),
      ],
    );
  }
}
