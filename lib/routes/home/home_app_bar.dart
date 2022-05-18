import 'package:c_breez/routes/home/account_required_actions.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class HomeAppBar extends AppBar {
  HomeAppBar({
    Key? key,
    required ThemeData themeData,
    required GlobalKey<ScaffoldState> scaffoldKey,
  }) : super(
          key: key,
          centerTitle: false,
          actions: [
            const Padding(
              padding: EdgeInsets.all(14.0),
              child: AccountRequiredActionsIndicator(),
            ),
          ],
          leading: IconButton(
            icon: SvgPicture.asset(
              "src/icon/hamburger.svg",
              height: 24.0,
              width: 24.0,
              color: themeData.appBarTheme.actionsIconTheme?.color,
            ),
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
          ),
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
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
          ),
          iconTheme: const IconThemeData(
            color: Color.fromARGB(255, 0, 133, 251),
          ),
          backgroundColor: theme.customData[theme.themeId]?.dashboardBgColor,
          systemOverlayStyle: theme.themeId == "BLUE"
              ? SystemUiOverlayStyle.dark
              : SystemUiOverlayStyle.light,
        );
}
