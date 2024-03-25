import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/account/credentials_manager.dart';
import 'package:c_breez/bloc/backup/backup_bloc.dart';
import 'package:c_breez/bloc/backup/backup_state.dart';
import 'package:c_breez/bloc/ext/block_builder_extensions.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_state.dart';
import 'package:c_breez/bloc/refund/refund_bloc.dart';
import 'package:c_breez/routes/home/widgets/app_bar/warning_action.dart';
import 'package:c_breez/routes/home/widgets/enable_backup_dialog.dart';
import 'package:c_breez/routes/home/widgets/rotator.dart';
import 'package:c_breez/routes/get-refund/get_refund_page.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/widgets/backup_in_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger("AccountRequiredActionsIndicator");

class AccountRequiredActionsIndicator extends StatelessWidget {
  const AccountRequiredActionsIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return BlocBuilder3<AccountBloc, AccountState, LSPBloc, LspState?, BackupBloc, BackupState?>(
      builder: (context, accState, lspState, backupState) {
        _log.fine("Building with: accState: $accState lspState: $lspState backupState: $backupState");
        final navigatorState = Navigator.of(context);
        final refundBloc = context.read<RefundBloc>();
        final refundState = refundBloc.state;

        List<Widget> warnings = [];
        int walletBalance = accState.walletBalance;

        if (walletBalance > 0) {
          warnings.add(
            WarningAction(
              () => navigatorState.pushNamed(
                "/unexpected_funds",
                arguments: walletBalance,
              ),
            ),
          );
        }

        if (accState.connectionStatus != ConnectionStatus.CONNECTING &&
            lspState != null &&
            lspState.selectedLspId == null) {
          warnings.add(
            WarningAction(() => navigatorState.pushNamed("/select_lsp")),
          );
        }

        if (accState.verificationStatus == VerificationStatus.UNVERIFIED) {
          warnings.add(
            WarningAction(
              () async {
                await ServiceInjector().keychain.read(CredentialsManager.accountMnemonic).then(
                      (accountMnemonic) => Navigator.pushNamed(
                        context,
                        '/mnemonics',
                        arguments: accountMnemonic,
                      ),
                    );
              },
            ),
          );
        }

        if (backupState != null && backupState.status == BackupStatus.INPROGRESS) {
          warnings.add(
            WarningAction(
              () {
                showDialog(
                  useRootNavigator: false,
                  useSafeArea: false,
                  context: context,
                  builder: (_) => const BackupInProgressDialog(),
                );
              },
              iconWidget: Rotator(
                child: Image(
                  image: const AssetImage("src/icon/sync.png"),
                  color: themeData.appBarTheme.actionsIconTheme!.color!,
                ),
              ),
            ),
          );
        }

        if (backupState?.status == BackupStatus.FAILED) {
          warnings.add(
            WarningAction(
              () {
                showDialog(
                  useRootNavigator: false,
                  useSafeArea: false,
                  context: context,
                  builder: (_) => const EnableBackupDialog(),
                );
              },
            ),
          );
        }

        if (refundState.refundables != null && refundState.refundables!.isNotEmpty) {
          warnings.add(
            WarningAction(
              () {
                navigatorState.push(
                  MaterialPageRoute(
                    builder: (_) => GetRefundPage(
                      refundBloc: refundBloc,
                    ),
                  ),
                );
              },
            ),
          );
        }

        if (warnings.isEmpty) {}

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: warnings,
        );
      },
    );
  }
}
