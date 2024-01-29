import 'package:c_breez/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class DrawerThemeSwitch extends StatelessWidget {
  const DrawerThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return GestureDetector(
      onTap: () => ThemeProvider.controllerOf(context).nextTheme(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
              right: 16.0,
            ),
            child: Container(
              width: 64,
              padding: const EdgeInsets.all(4),
              decoration: const ShapeDecoration(
                shape: StadiumBorder(),
                color: themeSwitchBgColor,
              ),
              child: Row(
                children: [
                  Image.asset(
                    "src/icon/ic_lightmode.png",
                    height: 24,
                    width: 24,
                    color: themeData.lightThemeSwitchIconColor,
                  ),
                  const SizedBox(
                    height: 20,
                    width: 8,
                    child: VerticalDivider(
                      color: Colors.white30,
                    ),
                  ),
                  ImageIcon(
                    const AssetImage("src/icon/ic_darkmode.png"),
                    color: themeData.darkThemeSwitchIconColor,
                    size: 24.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
