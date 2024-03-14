import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:flutter/material.dart';

class SaveDialog extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const SaveDialog({
    required this.formKey,
    super.key,
  });

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
            try {
              formKey.currentState!.save();
              Navigator.pop(context);
              FocusManager.instance.primaryFocus?.unfocus();
              showFlushbar(context, message: "Saved fee settings successfully.");
            } catch (_) {
              showFlushbar(context, message: "Failed to save fee settings.");
            }
          },
        ),
      ],
    );
  }
}
