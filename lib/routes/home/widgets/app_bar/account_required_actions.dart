import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/account/credential_manager.dart';
import 'package:c_breez/bloc/backup/backup_bloc.dart';
import 'package:c_breez/bloc/backup/backup_state.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_state.dart';
import 'package:c_breez/routes/backup/backup_now_page.dart';
import 'package:c_breez/routes/home/widgets/app_bar/warning_action.dart';
import 'package:c_breez/routes/home/widgets/rotator.dart';
import 'package:c_breez/routes/withdraw_funds/withdraw_funds_address_page.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/widgets/backup_in_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountRequiredActionsIndicator extends StatelessWidget {
  const AccountRequiredActionsIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return BlocBuilder<AccountBloc, AccountState>(builder: (context, accState) {
      return BlocBuilder<LSPBloc, LspState?>(
        builder: (context, lspState) {
          return BlocBuilder<BackupBloc, BackupState?>(
            builder: (context, backupState) {
              final navigatorState = Navigator.of(context);

              List<Widget> warnings = [];
              int walletBalance = accState.walletBalance;

              if (walletBalance > 0) {
                warnings.add(
                  WarningAction(
                    () => navigatorState.pushNamed(
                      "/withdraw_funds",
                      arguments: WithdrawKind.unexpected_funds,
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

              if (backupState?.status == BackupStatus.INPROGRESS) {
                final backupStateStream = context.watch<BackupBloc>().stream;
                warnings.add(
                  WarningAction(
                    () async {
                      if (backupState?.status != null) {
                        await showDialog(
                          useRootNavigator: false,
                          useSafeArea: false,
                          context: context,
                          builder: (_) => BackupInProgressDialog(backupStateStream),
                        );
                      }
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
                warnings.add(WarningAction(() => const BackupNowPage()));
              }

              if (warnings.isEmpty) {}

              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: warnings,
              );
            },
          );
        },
      );
    });
  }
}
