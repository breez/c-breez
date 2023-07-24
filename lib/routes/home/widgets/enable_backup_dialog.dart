import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_sdk/breez_bridge.dart' as bridge;
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/utils/min_font_size.dart';
import 'package:flutter/material.dart';

class EnableBackupDialog extends StatefulWidget {
  final BuildContext context;
  final bridge.BreezSDK breezLib;

  const EnableBackupDialog(this.context, this.breezLib);

  @override
  EnableBackupDialogState createState() {
    return EnableBackupDialogState();
  }
}

class EnableBackupDialogState extends State<EnableBackupDialog> {
  final AutoSizeGroup _autoSizeGroup = AutoSizeGroup();
  @override
  Widget build(BuildContext context) {
    return createEnableBackupDialog(context);
  }

  Widget createEnableBackupDialog(BuildContext context) {
    final texts = context.texts();
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: Theme.of(context).canvasColor,
      ),
      child: AlertDialog(
        titlePadding: const EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 16.0),
        title: Text(
          texts.backup_dialog_title,
          style: Theme.of(context).dialogTheme.titleTextStyle,
        ),
        contentPadding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 24.0),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 12.0),
                child: AutoSizeText(
                  texts.backup_dialog_message_default,
                  style: Theme.of(context).primaryTextTheme.displaySmall?.copyWith(fontSize: 16),
                  minFontSize: MinFontSize(context).minFontSize,
                  stepGranularity: 0.1,
                  group: _autoSizeGroup,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(widget.context),
            child: Text(
              texts.backup_dialog_option_cancel,
              style: Theme.of(context).primaryTextTheme.labelLarge,
              maxLines: 1,
            ),
          ),
          TextButton(
            onPressed: (() {
              Navigator.pop(widget.context);
              widget.breezLib.backup();
            }),
            child: Text(
              texts.backup_dialog_option_ok_default,
              style: Theme.of(context).primaryTextTheme.labelLarge,
              maxLines: 1,
            ),
          )
        ],
      ),
    );
  }
}
