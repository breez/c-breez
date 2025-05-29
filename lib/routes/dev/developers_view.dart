import 'dart:io';

import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/credentials_manager.dart';
import 'package:c_breez/bloc/reverse_swap/reverse_swap_bloc.dart';
import 'package:c_breez/config.dart';
import 'package:c_breez/models/bug_report_behavior.dart';
import 'package:c_breez/routes/dev/command_line_interface.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/services/wallet_archive_service.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:c_breez/utils/overlay_manager.dart';
import 'package:c_breez/utils/preferences.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:c_breez/widgets/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:share_plus/share_plus.dart';

final Logger _logger = Logger("DevelopersView");

bool allowRebroadcastRefunds = false;

class Choice {
  const Choice({
    required this.title,
    required this.icon,
    required this.function,
  });

  final String title;
  final IconData icon;
  final Function(BuildContext context) function;
}

class DevelopersView extends StatefulWidget {
  const DevelopersView({
    super.key,
  });

  @override
  State<DevelopersView> createState() => _DevelopersViewState();
}

class _DevelopersViewState extends State<DevelopersView> {
  final OverlayManager _overlayManager = OverlayManager();

  final _preferences = const Preferences();
  var bugReportBehavior = BugReportBehavior.PROMPT;

  @override
  void initState() {
    super.initState();
    _preferences
        .getBugReportBehavior()
        .then((value) => bugReportBehavior = value, onError: (e) => _logger.warning(e));
  }

  @override
  void dispose() {
    _overlayManager.removeLoadingOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    final texts = getSystemAppLocalizations();
    final themeData = Theme.of(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const back_button.BackButton(),
        title: Text(texts.home_drawer_item_title_developers),
        actions: [
          PopupMenuButton<Choice>(
            onSelected: (c) => c.function(context),
            color: themeData.colorScheme.surface,
            icon: Icon(
              Icons.more_vert,
              color: themeData.iconTheme.color,
            ),
            itemBuilder: (context) => [
              if (kDebugMode)
                Choice(
                  title: "Export Keys",
                  icon: Icons.phone_android,
                  function: _exportKeys,
                ),
              Choice(
                title: "Share Logs",
                icon: Icons.share,
                function: _shareLogs,
              ),
              Choice(
                title: "Export static backup",
                icon: Icons.charging_station,
                function: _exportStaticBackup,
              ),
              Choice(
                title: "Rescan Swaps",
                icon: Icons.radar,
                function: _rescanSwaps,
              ),
              if (bugReportBehavior != BugReportBehavior.PROMPT)
                Choice(
                  title: "Enable Failure Prompt",
                  icon: Icons.bug_report,
                  function: (_) {
                    _preferences.setBugReportBehavior(BugReportBehavior.PROMPT).then(
                        (value) => setState(() {
                              bugReportBehavior = BugReportBehavior.PROMPT;
                            }),
                        onError: (e) => _logger.warning(e));
                  },
                ),
            ]
                .map((choice) => PopupMenuItem<Choice>(
                      value: choice,
                      child: Text(
                        choice.title,
                        style: themeData.textTheme.labelLarge,
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
      body: CommandLineInterface(scaffoldKey: scaffoldKey),
    );
  }

  /// Exports wallet keys and credentials to a zip file
  Future<void> _exportKeys(BuildContext context) async {
    _overlayManager.showLoadingOverlay(context);

    try {
      if (kDebugMode) {
        final String keysZipPath = await WalletArchiveService.createKeysArchive();

        final ShareParams shareParams = ShareParams(
          title: 'Keys',
          files: <XFile>[XFile(keysZipPath)],
        );
        SharePlus.instance.share(shareParams);
      } else {
        final CredentialsManager credentialsManager = ServiceInjector().credentialsManager;
        final List<File> credentialFile = await credentialsManager.exportCredentials();

        final ShareParams shareParams = ShareParams(
          title: 'Keys',
          files: <XFile>[XFile(credentialFile.first.path)],
        );
        SharePlus.instance.share(shareParams);
      }
    } catch (e) {
      _logger.severe('Failed to export keys: $e');

      if (context.mounted) {
        showFlushbar(context, message: 'Failed to export keys: ${e.toString()}');
      }
    } finally {
      _overlayManager.removeLoadingOverlay();
    }
  }

  /// Share application logs
  Future<void> _shareLogs(BuildContext context) async {
    _overlayManager.showLoadingOverlay(context);

    try {
      final String zipPath = await WalletArchiveService.createLogsArchive();
      final ShareParams shareParams = ShareParams(
        title: 'Logs',
        files: <XFile>[XFile(zipPath)],
      );
      SharePlus.instance.share(shareParams);
    } catch (e) {
      _logger.severe('Failed to share logs: $e');

      if (context.mounted) {
        showFlushbar(context, message: 'Failed to share logs: ${e.toString()}');
      }
    } finally {
      _overlayManager.removeLoadingOverlay();
    }
  }

  void _exportStaticBackup(BuildContext context) async {
    final texts = getSystemAppLocalizations();
    final accBloc = context.read<AccountBloc>();
    const name = "scb.recover";
    final staticBackup = await accBloc.exportStaticChannelBackup();

    if (staticBackup.backup != null) {
      final backup = staticBackup.backup;

      final emergencyList = backup!.toString();

      Config config = await Config.instance();
      String workingDir = config.sdkConfig.workingDir;
      String filePath = '$workingDir/$name';
      File file = File(filePath);
      await file.writeAsString(emergencyList, flush: true);
      final ShareParams shareParams = ShareParams(
        title: 'Static Backup',
        files: <XFile>[XFile(filePath)],
      );
      SharePlus.instance.share(shareParams);
    } else {
      if (!context.mounted) return;
      showFlushbar(context, title: texts.backup_export_static_error_data_missing);
    }
  }

  Future<void> _rescanSwaps(BuildContext context) async {
    final texts = getSystemAppLocalizations();
    final revSwapBloc = context.read<ReverseSwapBloc>();

    try {
      return await revSwapBloc.rescanSwaps();
    } catch (error) {
      if (!context.mounted) return;
      showFlushbar(context, title: extractExceptionMessage(error, texts));
    }
  }
}
