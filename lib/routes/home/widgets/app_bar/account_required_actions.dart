import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/backup/backup_bloc.dart';
import 'package:c_breez/bloc/backup/backup_state.dart';
import 'package:c_breez/bloc/ext/block_builder_extensions.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_state.dart';
import 'package:c_breez/bloc/refund/refund_bloc.dart';
import 'package:c_breez/bloc/sdk_connectivity/sdk_connectivity_cubit.dart';
import 'package:c_breez/bloc/sdk_connectivity/sdk_connectivity_state.dart';
import 'package:c_breez/bloc/security/security_bloc.dart';
import 'package:c_breez/bloc/security/security_state.dart';
import 'package:c_breez/routes/get-refund/get_refund_page.dart';
import 'package:c_breez/routes/home/widgets/app_bar/warning_action.dart';
import 'package:c_breez/routes/home/widgets/enable_backup_dialog.dart';
import 'package:c_breez/routes/home/widgets/rotator.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/widgets/backup_in_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import '../../../initial_walkthrough/mnemonics/mnemonics_confirmation_page.dart';

final _log = Logger("AccountRequiredActionsIndicator");

class AccountRequiredActionsIndicator extends StatelessWidget {
  const AccountRequiredActionsIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SdkConnectivityCubit, SdkConnectivityState>(
      builder: (context, sdkConnectivityState) {
        return BlocBuilder3<AccountBloc, AccountState, LSPBloc, LspState?, BackupBloc, BackupState?>(
          builder: (context, accState, lspState, backupState) {
            _log.fine("Building with: accState: $accState lspState: $lspState backupState: $backupState");
            final navigatorState = Navigator.of(context);

            List<Widget> warnings = [];
            int walletBalanceSat = accState.walletBalanceSat;

            if (walletBalanceSat > 0) {
              _log.info('Adding unexpected funds warning.');
              warnings.add(
                WarningAction(
                  () => navigatorState.pushNamed("/unexpected_funds", arguments: walletBalanceSat),
                ),
              );
            }

            if (sdkConnectivityState != SdkConnectivityState.connecting &&
                lspState != null &&
                lspState.selectedLspId == null) {
              _log.info('Adding missing LSP warning.');
              warnings.add(WarningAction(() => navigatorState.pushNamed("/select_lsp")));
            }

            final MnemonicStatus mnemonicStatus = context.select<SecurityBloc, MnemonicStatus>(
              (SecurityBloc cubit) => cubit.state.mnemonicStatus,
            );
            if (mnemonicStatus != MnemonicStatus.verified) {
              _log.info('Adding mnemonic verification warning.');
              warnings.add(const VerifyMnemonicWarningAction());
            }

            if (backupState != null && backupState.status == BackupStatus.INPROGRESS) {
              _log.info('Adding backup in progress warning.');
              warnings.add(const BackupInProgressWarningAction());
            }

            if (backupState?.status == BackupStatus.FAILED) {
              _log.info('Adding backup error warning.');
              warnings.add(const BackupFailedWarningAction());
            }

            final refundBloc = context.read<RefundBloc>();
            final refundState = refundBloc.state;
            if (refundState.refundables != null && refundState.refundables!.isNotEmpty) {
              _log.info('Adding non-refunded refundables warning.');
              warnings.add(
                WarningAction(() {
                  navigatorState.push(
                    MaterialPageRoute(builder: (_) => GetRefundPage(refundBloc: refundBloc)),
                  );
                }),
              );
            }

            if (warnings.isEmpty) {
              return const SizedBox.shrink();
            }

            _log.info('Total # of warnings: ${warnings.length}');

            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: warnings,
            );
          },
        );
      },
    );
  }
}

class BackupInProgressWarningAction extends StatelessWidget {
  static final Logger _logger = Logger('BackupInProgressWarningAction');

  const BackupInProgressWarningAction({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return WarningAction(
      () {
        _logger.info('Display backup in progress dialog.');
        showDialog(
          useRootNavigator: false,
          useSafeArea: false,
          context: context,
          builder: (_) => const BackupInProgressDialog(),
        );
      },
      iconWidget: Rotator(
        child: Image(
          image: const AssetImage('src/icon/sync.png'),
          color: themeData.appBarTheme.actionsIconTheme!.color!,
        ),
      ),
    );
  }
}

class VerifyMnemonicWarningAction extends StatelessWidget {
  static final Logger _logger = Logger('VerifyMnemonicWarningAction');

  const VerifyMnemonicWarningAction({super.key});

  @override
  Widget build(BuildContext context) {
    return WarningAction(() async {
      _logger.info('Redirecting user to mnemonics confirmation page.');
      final String? accountMnemonic = await ServiceInjector().credentialsManager.restoreMnemonic();
      if (context.mounted && accountMnemonic != null) {
        Navigator.pushNamed(context, MnemonicsConfirmationPage.routeName, arguments: accountMnemonic);
      }
    });
  }
}

class BackupFailedWarningAction extends StatelessWidget {
  static final Logger _logger = Logger('BackupFailedWarningAction');

  const BackupFailedWarningAction({super.key});

  @override
  Widget build(BuildContext context) {
    return WarningAction(() {
      _logger.info('Display enable backup dialog.');
      showDialog(
        useRootNavigator: false,
        useSafeArea: false,
        context: context,
        builder: (_) => const EnableBackupDialog(),
      );
    });
  }
}
