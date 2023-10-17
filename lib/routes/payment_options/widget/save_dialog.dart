import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/payment_options/payment_options_bloc.dart';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _log = Logger("SaveDialog");

class SaveDialog extends StatelessWidget {
  const SaveDialog({
    Key? key,
  }) : super(key: key);

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
            _log.info("onPressed: save");
            context.read<PaymentOptionsBloc>().saveFees();
            Navigator.pop(context);
            FocusManager.instance.primaryFocus?.unfocus();
          },
        ),
      ],
    );
  }
}
