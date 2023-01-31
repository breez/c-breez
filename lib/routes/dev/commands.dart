import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/logger.dart';
import 'package:c_breez/routes/dev/commands_list.dart';
import 'package:c_breez/routes/ui_test/ui_test_page.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:c_breez/widgets/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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

class DevelopersView extends StatelessWidget {
  const DevelopersView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final themeData = Theme.of(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: const back_button.BackButton(),
        actions: [
          PopupMenuButton<Choice>(
            onSelected: (c) => c.function(context),
            color: themeData.colorScheme.background,
            icon: Icon(
              Icons.more_vert,
              color: themeData.iconTheme.color,
            ),
            itemBuilder: (context) => [
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
        title: const Text("Developers"),
      ),
      body: CommandsList(scaffoldKey: scaffoldKey),
    );
  }

  void _exportKeys(BuildContext context) async {
    final accBloc = context.read<AccountBloc>();
    final appDir = await getApplicationDocumentsDirectory();
    // create zip file
    final encoder = ZipFileEncoder();
    final zipFilePath = "${appDir.path}/c-breez-keys.zip";
    encoder.create(zipFilePath);
    // create credentials file and add it to zip
    // TODO: return list of File; that contains seed and credential files
    /*
    final List<File> credentialFiles = await accBloc.exportCredentialFiles();
    for(var credentialsFile in credentialFiles) {
      encoder.addFile(credentialsFile);
    }*/
    final credentialsFilePath = await accBloc.exportCredentialsFile();
    final credentialsFile = File(credentialsFilePath);
    encoder.addFile(credentialsFile);
    // add storage file to zip
    final storageFilePath = "${appDir.path}/storage.sql";
    final storageFile = File(storageFilePath);
    encoder.addFile(storageFile);
    encoder.close();
    final zipFile = XFile(zipFilePath);
    Share.shareXFiles([zipFile]);
  }
}
