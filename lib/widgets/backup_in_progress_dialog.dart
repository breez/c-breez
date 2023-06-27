import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/backup/backup_state.dart';
import 'package:c_breez/widgets/loading_animated_text.dart';
import 'package:flutter/material.dart';

class BackupInProgressDialog extends StatefulWidget {
  final BackupState backupState;

  const BackupInProgressDialog(this.backupState) : super();

  @override
  State<StatefulWidget> createState() => _BackupInProgressDialogState();
}

class _BackupInProgressDialogState extends State<BackupInProgressDialog> {
  _BackupInProgressDialogState();

  @override
  void initState() {
    super.initState();
    /*if (widget.backupState.status == BackupStatus.SUCCESS) {
      _pop();
    }*/
  }

  @override
  void dispose() {
    super.dispose();
  }

  /*_pop() {
    Navigator.of(context).pop();
  }*/

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    return LoadingAnimatedText(texts.backup_in_progress);
  }
}
