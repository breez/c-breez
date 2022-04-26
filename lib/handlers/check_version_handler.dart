import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/theme_data.dart' as theme;
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/no_connection_dialog.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

void checkVersionDialog(
  BuildContext context,
  UserProfileBloc userProfileBloc,
) {
  final texts = AppLocalizations.of(context)!;

  userProfileBloc.checkVersion().catchError((err) {
    if (err.contains('connection error')) {
      showNoConnectionDialog(context).then((retry) {        
        if (retry == true) {
          Future.delayed(const Duration(seconds: 1), () {
            checkVersionDialog(context, userProfileBloc);
          });
        }
      });
    } else if (err.contains('bad version')) {
      showFlushbar(
        context,
        buttonText: texts.handler_check_version_action_update,
        onDismiss: () {
          if (defaultTargetPlatform == TargetPlatform.iOS) {
            launch("https://testflight.apple.com/join/wPju2Du7");
          }
          if (defaultTargetPlatform == TargetPlatform.android) {
            launch("https://play.google.com/apps/testing/com.cBreez.client");
          }
          return false;
        },
        position: FlushbarPosition.TOP,
        duration: Duration.zero,
        messageWidget: Text(
          texts.handler_check_version_message,
          style: theme.snackBarStyle,
          textAlign: TextAlign.center,
        ),
      );
    }
  });
}
