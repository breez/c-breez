import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'account_required_actions.dart';

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
              colorFilter: ColorFilter.mode(
                themeData.appBarTheme.actionsIconTheme!.color!,
                BlendMode.srcATop,
              ),
            ),
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
          ),
          title: IconButton(
            padding: EdgeInsets.zero,
            icon: SvgPicture.asset(
              "src/images/cloud-logo-color.svg",
              colorFilter: ColorFilter.mode(
                themeData.appBarTheme.actionsIconTheme!.color!,
                BlendMode.srcATop,
              ),
            ),
            iconSize: 128,
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
          ),
          iconTheme: const IconThemeData(
            color: Color.fromARGB(255, 0, 133, 251),
          ),
          backgroundColor: themeData.customData.dashboardBgColor,
          systemOverlayStyle: themeData.isLightTheme ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
        );
}
