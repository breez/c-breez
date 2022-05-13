// Color(0xFF121212) values are tbd
import 'package:c_breez/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'breez_colors.dart';

final ThemeData breezDarkTheme = ThemeData(
  colorScheme: const ColorScheme.dark().copyWith(
    primary: Colors.white,
    secondary: Colors.white,
    error: const Color(0xFFeddc97),
  ),
  primaryColor: const Color(0xFF7aa5eb),
  primaryColorDark: const Color(0xFF00081C),
  primaryColorLight: const Color(0xFF4B89EB),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF4B89EB),
    sizeConstraints: BoxConstraints(minHeight: 64, minWidth: 64),
  ),
  canvasColor: const Color(0xFF0c2031),
  backgroundColor: const Color(0xFF152a3d),
  bottomAppBarTheme:
      const BottomAppBarTheme(elevation: 0, color: Color(0xff4D88EC)),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFF0c2031),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    toolbarTextStyle: toolbarTextStyle,
    titleTextStyle: titleTextStyle,
    elevation: 0.0,
    actionsIconTheme: const IconThemeData(color: Colors.white),
    systemOverlayStyle: SystemUiOverlayStyle.light,
  ),
  dialogTheme: const DialogTheme(
      titleTextStyle:
          TextStyle(color: Colors.white, fontSize: 20.5, letterSpacing: 0.25),
      contentTextStyle:
          TextStyle(color: Colors.white70, fontSize: 16.0, height: 1.5),
      backgroundColor: Color(0xFF152a3d),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)))),
  dialogBackgroundColor: Colors.transparent,
  dividerColor: const Color(0x337aa5eb),
  cardColor: const Color(0xFF121212), // will be replaced with CardTheme.color
  cardTheme: const CardTheme(color: Color(0xFF121212)),
  highlightColor: const Color(0xFF81acf1),
  textTheme: const TextTheme(
      subtitle2:
          TextStyle(color: Colors.white, fontSize: 14.3, letterSpacing: 0.2),
      headline5: TextStyle(color: Colors.white, fontSize: 26.0),
      button:
          TextStyle(color: Colors.white, fontSize: 14.3, letterSpacing: 1.25),
      headline4: TextStyle(
        color: Color(0xffffe685),
        fontSize: 18.0,
      ),
      headline6: TextStyle(
          color: Colors.white,
          fontSize: 12.3,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          height: 1.22)),
  primaryTextTheme: TextTheme(
    headline4: const TextStyle(
        color: Colors.white,
        fontSize: 14.0,
        letterSpacing: 0.0,
        height: 1.28,
        fontWeight: FontWeight.w500,
        fontFamily: 'IBMPlexSans'),
    headline3: const TextStyle(
        color: Colors.white, fontSize: 14.0, letterSpacing: 0.0, height: 1.28),
    headline5: const TextStyle(
        color: Colors.white,
        fontSize: 24.0,
        letterSpacing: 0.0,
        height: 1.28,
        fontWeight: FontWeight.w500,
        fontFamily: 'IBMPlexSans'),
    bodyText2: const TextStyle(
        color: Colors.white,
        fontSize: 16.4,
        letterSpacing: 0.15,
        fontWeight: FontWeight.w500,
        fontFamily: 'IBMPlexSans'),
    button: const TextStyle(
        color: Color(0xFF7aa5eb), fontSize: 14.3, letterSpacing: 1.25),
    subtitle2: TextStyle(
        color: BreezColors.white[500], fontSize: 10.0, letterSpacing: 0.09),
    caption: TextStyle(color: BreezColors.white[400], fontSize: 12.0),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    selectionColor: Color.fromRGBO(255, 255, 255, 0.5),
    selectionHandleColor: Color(0xff4D88EC),
  ),
  primaryIconTheme: const IconThemeData(color: Color(0xFF7aa5eb)),
  fontFamily: 'IBMPlexSans',
  textButtonTheme: const TextButtonThemeData(),
  outlinedButtonTheme: const OutlinedButtonThemeData(),
  elevatedButtonTheme: const ElevatedButtonThemeData(),
  radioTheme: RadioThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) {
      return Colors.white;
    }),
  ),
  chipTheme: const ChipThemeData(backgroundColor: Color(0xff4D88EC)),
);

final ThemeData calendarDarkTheme = ThemeData.dark().copyWith(
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF4B89EB), // header bg color
    onPrimary: Colors.white, // header text color
    onSurface: Colors.white, // body text color
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(primary: const Color(0xFF7aa5eb)),
  ),
  dialogTheme: const DialogTheme(
    backgroundColor: Color(0xFF152a3d),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(12.0),
      ),
    ),
  ),
);