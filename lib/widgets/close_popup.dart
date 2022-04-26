import 'dart:io';

import 'package:c_breez/widgets/error_dialog.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

WillPopCallback willPopCallback(
  BuildContext context, {
  bool immediateExit = false,
  String? title,
  String? message,
  required Function canCancel,
}) {
  final texts = AppLocalizations.of(context)!;
  return () async {
    if (canCancel()) return true;
    return promptAreYouSure(
      context,
      title ?? texts.close_popup_title,
      Text(message ?? texts.close_popup_message),
    ).then((ok) {
      if (ok == true && immediateExit) {
        exit(0);
      }
      return ok == true;
    });
  };
}
