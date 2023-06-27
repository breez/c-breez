import 'dart:async';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/backup/backup_state.dart';
import 'package:c_breez/routes/home/widgets/annimated_loader_dialog.dart';
import 'package:flutter/material.dart';

class BackupInProgressDialog extends StatefulWidget {
  final Stream<BackupState?> backupBlocStream;

  const BackupInProgressDialog(this.backupBlocStream);

  @override
  createState() => BackupInProgressDialogState();
}

class BackupInProgressDialogState extends State<BackupInProgressDialog> {
  late StreamSubscription<BackupState?> _stateSubscription;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _stateSubscription = widget.backupBlocStream.listen(
      (state) {
        if (state?.status != BackupStatus.INPROGRESS) {
          dispose();
          Navigator.of(context).pop();
        }
      },
    );
  }

  @override
  void dispose() {
    _stateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    return createAnimatedLoaderDialog(context, texts.backup_in_progress);
  }
}
