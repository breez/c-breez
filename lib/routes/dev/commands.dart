import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

bool allowRebroadcastRefunds = false;

class Choice {
  const Choice({required this.title, required this.icon, required this.function});

  final String title;
  final IconData icon;
  final Function(BuildContext context) function;
}

class DevelopersView extends StatelessWidget {
  const DevelopersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).appBarTheme.iconTheme,
          backgroundColor: Theme.of(context).canvasColor,
          leading: const back_button.BackButton(),
          elevation: 0.0,
          actions: <Widget>[
            PopupMenuButton<Choice>(
              onSelected: (c) => c.function(context),
              color: Theme.of(context).backgroundColor,
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).iconTheme.color,
              ),
              itemBuilder: (BuildContext context) {
                return _getChoices().map((Choice choice) {
                  return PopupMenuItem<Choice>(
                    value: choice,
                    child: Text(choice.title, style: Theme.of(context).textTheme.button),
                  );
                }).toList();
              },
            ),
          ],
          title: Text(
            "Developers",
            style: Theme.of(context).appBarTheme.toolbarTextStyle,
          ),
        ),
        body: Container());
  }

  List<Choice> _getChoices() {
    return [
      Choice(title: 'Export Keys', icon: Icons.phone_android, function: _exportKeys),      
    ];
  }

  void _exportKeys(BuildContext context) async {    
    var accBloc = context.read<AccountBloc>();
    Directory tempDir = await getTemporaryDirectory();
    var keysDir = tempDir.createTempSync("keys");    
    await accBloc.exportKeyFiles(keysDir);

    var encoder = ZipFileEncoder();
    var zipFilePath = '${tempDir.path}/keys.zip';
    encoder.create(zipFilePath);
    keysDir.listSync().forEach((keyFile) {
      encoder.addFile(keyFile as File);
    });
    encoder.close();
    ShareExtend.share(zipFilePath, "file");
  }
}
