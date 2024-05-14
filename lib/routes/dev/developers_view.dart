import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/reverse_swap/reverse_swap_bloc.dart';
import 'package:c_breez/config.dart';
import 'package:c_breez/logger.dart';
import 'package:c_breez/models/bug_report_behavior.dart';
import 'package:c_breez/routes/dev/command_line_interface.dart';
import 'package:c_breez/routes/ui_test/ui_test_page.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:c_breez/utils/preferences.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

final _log = Logger("DevelopersView");

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
  final _preferences = const Preferences();
  var bugReportBehavior = BugReportBehavior.PROMPT;

  @override
  void initState() {
    super.initState();
    _preferences
        .getBugReportBehavior()
        .then((value) => bugReportBehavior = value, onError: (e) => _log.warning(e));
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
                title: "Test UI Widgets",
                icon: Icons.phone_android,
                function: (_) => Navigator.push(
                  context,
                  FadeInRoute(
                    builder: (_) => const UITestPage(),
                  ),
                ),
              ),
              Choice(
                title: "Share Logs",
                icon: Icons.share,
                function: (_) => shareLog(),
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
                        onError: (e) => _log.warning(e));
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

  void _exportKeys(BuildContext context) async {
    final accBloc = context.read<AccountBloc>();
    final appDir = await getApplicationDocumentsDirectory();
    final encoder = ZipFileEncoder();
    final zipFilePath = "${appDir.path}/c-breez-keys.zip";
    encoder.create(zipFilePath);
    final List<File> credentialFiles = await accBloc.exportCredentialFiles();
    for (var credentialFile in credentialFiles) {
      final bytes = await credentialFile.readAsBytes();
      encoder.addArchiveFile(
        ArchiveFile(basename(credentialFile.path), bytes.length, bytes),
      );
    }
    final storageFilePath = "${appDir.path}/storage.sql";
    final storageFile = File(storageFilePath);
    encoder.addFile(storageFile);
    encoder.close();
    final zipFile = XFile(zipFilePath);
    Share.shareXFiles([zipFile]);
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
      final storageFile = XFile(filePath);
      Share.shareXFiles([storageFile]);
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
