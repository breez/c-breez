import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/logger.dart';
import 'package:c_breez/routes/ui_test/ui_test_page.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:c_breez/widgets/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_extend/share_extend.dart';

import 'commands_list.dart';

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
            color: themeData.backgroundColor,
            icon: Icon(
              Icons.more_vert,
              color: themeData.iconTheme.color,
            ),
            itemBuilder: (context) {
              return _getChoices(context).map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Text(
                    choice.title,
                    style: themeData.textTheme.button,
                  ),
                );
              }).toList();
            },
          ),
        ],
        title: const Text("Developers"),
      ),
      body: CommandsList(scaffoldKey: scaffoldKey),
    );
  }

  List<Choice> _getChoices(BuildContext context) {
    return [
      Choice(
        title: 'Export Keys',
        icon: Icons.phone_android,
        function: _exportKeys,
      ),
      Choice(
        title: 'Test UI Widgets',
        icon: Icons.phone_android,
        function: (_) => Navigator.push(
          context,
          FadeInRoute(
            builder: (_) => const UITestPage(),
          ),
        ),
      ),
      Choice(
        title: 'Share Logs',
        icon: Icons.share,
        function: (_) => shareLog(),
      )
    ];
  }

  void _exportKeys(BuildContext context) async {
    final accBloc = context.read<AccountBloc>();
    final credentialsFilePath = await accBloc.exportCredentialsFile();
    ShareExtend.share(credentialsFilePath, "file");
  }
}
