import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/routes/home/account_required_actions_indicator.dart';
import 'package:c_breez/routes/home/home_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HomePage({
    Key? key,
    this.scaffoldKey = const GlobalObjectKey("HomePage.scaffoldKey"),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: IconButton(
          padding: EdgeInsets.zero,
          icon: SvgPicture.asset(
            "src/images/logo-color.svg",
            height: 23.5,
            width: 62.7,
            color: themeData.appBarTheme.actionsIconTheme?.color,
            colorBlendMode: BlendMode.srcATop,
          ),
          iconSize: 64,
          onPressed: _openDrawer,
        ),
        actions: const [
          AccountRequiredActionsIndicator(),
        ],
        leading: IconButton(
          icon: SvgPicture.asset(
            "src/icon/hamburger.svg",
            height: 24.0,
            width: 24.0,
            color: themeData.appBarTheme.actionsIconTheme?.color,
          ),
          onPressed: _openDrawer,
        ),
      ),
      drawer: const HomeDrawer(),
      body: Center(
        child: Text(
          texts.app_name,
        ),
      ),
    );
  }

  void _openDrawer() => scaffoldKey.currentState?.openDrawer();
}
