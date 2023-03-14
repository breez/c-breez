import 'package:breez_translations/breez_translations_locales.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';

final _log = FimberLog("SaveDialog");

class SaveDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return AlertDialog(
      title: Text(
        texts.payment_options_fee_warning_dialog_title,
        style: themeData.dialogTheme.titleTextStyle,
      ),
      content: Text(
        texts.payment_options_fee_warning_dialog_message,
        style: themeData.dialogTheme.contentTextStyle,
      ),
      actions: [
        TextButton(
          child: Text(
            texts.payment_options_fee_action_cancel,
            style: themeData.primaryTextTheme.labelLarge,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text(
            texts.payment_options_fee_action_save,
            style: themeData.primaryTextTheme.labelLarge,
          ),
          onPressed: () {
            // TODO real implementation
            _log.v("onPressed: save");
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
