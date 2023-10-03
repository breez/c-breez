import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/backup/backup_bloc.dart';
import 'package:c_breez/bloc/backup/backup_state.dart';
import 'package:c_breez/routes/home/widgets/animated_loader_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BackupInProgressDialog extends StatefulWidget {
  const BackupInProgressDialog();

  @override
  createState() => BackupInProgressDialogState();
}

class BackupInProgressDialogState extends State<BackupInProgressDialog> {
  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    return BlocListener<BackupBloc, BackupState?>(
        listener: (context, state) {
          if (state?.status != BackupStatus.INPROGRESS) {
            Navigator.of(context).pop();
          }
        },
        child: createAnimatedLoaderDialog(context, texts.backup_in_progress));
  }
}
