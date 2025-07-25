// Color(0xFF121212) values are tbd
import 'package:c_breez/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'breez_colors.dart';

final ThemeData breezDarkTheme = ThemeData(
  useMaterial3: false,
  colorScheme: const ColorScheme.dark().copyWith(
    primary: Colors.white,
    secondary: Colors.white,
    onSecondary: Colors.white,
    error: const Color(0xFFeddc97),
    surface: const Color(0xFF00091c),
  ),
  primaryColor: const Color(0xFF0085fb),
  primaryColorDark: const Color(0xFF00081C),
  primaryColorLight: const Color(0xFF0085fb),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF0085fb),
    sizeConstraints: BoxConstraints(minHeight: 64, minWidth: 64),
  ),
  canvasColor: const Color(0xFF00091c),
  bottomAppBarTheme: const BottomAppBarTheme(elevation: 0, color: Color(0xFF0085fb)),
  appBarTheme: AppBarTheme(
    centerTitle: false,
    backgroundColor: const Color(0xFF00091c),
    iconTheme: const IconThemeData(color: Colors.white),
    toolbarTextStyle: toolbarTextStyle,
    titleTextStyle: titleTextStyle,
    elevation: 0.0,
    actionsIconTheme: const IconThemeData(color: Colors.white),
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark, // iOS
      statusBarIconBrightness: Brightness.light, // Android
      systemStatusBarContrastEnforced: false,
      systemNavigationBarColor: Color(0xFF00091c),
      systemNavigationBarContrastEnforced: false,
    ),
  ),
  dialogTheme: const DialogThemeData(
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20.5, letterSpacing: 0.25),
    contentTextStyle: TextStyle(color: Colors.white70, fontSize: 16.0, height: 1.5),
    backgroundColor: Color.fromRGBO(10, 20, 40, 1),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
  ),
  dividerColor: const Color(0x337aa5eb),
  cardColor: const Color(0xFF121212), // will be replaced with CardTheme.color
  cardTheme: const CardThemeData(color: Color(0xFF121212)),
  highlightColor: const Color(0xFF0085fb),
  textTheme: const TextTheme(
    titleSmall: TextStyle(color: Colors.white, fontSize: 14.3, letterSpacing: 0.2),
    headlineSmall: TextStyle(color: Colors.white, fontSize: 26.0),
    labelLarge: TextStyle(color: Colors.white, fontSize: 14.3, letterSpacing: 1.25),
    headlineMedium: TextStyle(color: Color(0xffffe685), fontSize: 18.0),
    titleLarge: TextStyle(
      color: Colors.white,
      fontSize: 12.3,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.22,
    ),
  ),
  primaryTextTheme: TextTheme(
    headlineMedium: const TextStyle(
      color: Colors.white,
      fontSize: 14.0,
      letterSpacing: 0.0,
      height: 1.28,
      fontWeight: FontWeight.w500,
      fontFamily: 'IBMPlexSans',
    ),
    displaySmall: const TextStyle(color: Colors.white, fontSize: 14.0, letterSpacing: 0.0, height: 1.28),
    headlineSmall: const TextStyle(
      color: Colors.white,
      fontSize: 24.0,
      letterSpacing: 0.0,
      height: 1.28,
      fontWeight: FontWeight.w500,
      fontFamily: 'IBMPlexSans',
    ),
    bodyMedium: const TextStyle(
      color: Colors.white,
      fontSize: 16.4,
      letterSpacing: 0.15,
      fontWeight: FontWeight.w500,
      fontFamily: 'IBMPlexSans',
    ),
    labelLarge: const TextStyle(color: Colors.white, fontSize: 14.3, letterSpacing: 1.25),
    titleSmall: TextStyle(color: BreezColors.white[500], fontSize: 10.0, letterSpacing: 0.09),
    bodySmall: TextStyle(color: BreezColors.white[400], fontSize: 12.0),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    selectionColor: Color.fromRGBO(255, 255, 255, 0.5),
    selectionHandleColor: Color(0xFF0085fb),
  ),
  primaryIconTheme: const IconThemeData(color: Colors.white),
  fontFamily: 'IBMPlexSans',
  textButtonTheme: const TextButtonThemeData(),
  outlinedButtonTheme: const OutlinedButtonThemeData(),
  elevatedButtonTheme: const ElevatedButtonThemeData(),
  radioTheme: RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      return Colors.white;
    }),
  ),
  chipTheme: const ChipThemeData(backgroundColor: Color(0xFF0085fb)),
  datePickerTheme: calendarDarkTheme,
);

final DatePickerThemeData calendarDarkTheme = DatePickerThemeData(
  yearBackgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
    if (states.contains(WidgetState.selected)) {
      return const Color(0xFF0085fb);
    }
    return Colors.transparent;
  }),
  yearForegroundColor: WidgetStateProperty.resolveWith<Color>((states) {
    if (states.contains(WidgetState.disabled)) {
      return Colors.white38;
    }
    return Colors.white;
  }),
  dayBackgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
    if (states.contains(WidgetState.selected)) {
      return const Color(0xFF0085fb);
    }
    return Colors.transparent;
  }),
  dayForegroundColor: WidgetStateProperty.resolveWith<Color>((states) {
    if (states.contains(WidgetState.disabled)) {
      return Colors.white38;
    }
    return Colors.white;
  }),
  todayBackgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
    if (states.contains(WidgetState.selected)) {
      return const Color(0xFF0085fb);
    }
    return Colors.transparent;
  }),
  todayForegroundColor: WidgetStateProperty.resolveWith<Color>((states) {
    if (states.contains(WidgetState.selected)) {
      return Colors.white;
    }
    if (states.contains(WidgetState.disabled)) {
      return Colors.white38;
    }
    return const Color(0xFF0085fb);
  }),
  todayBorder: const BorderSide(color: Color(0xFF0085fb)),
  headerBackgroundColor: const Color(0xFF0085fb),
  headerForegroundColor: Colors.white,
  backgroundColor: const Color.fromRGBO(10, 20, 40, 1),
  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
  cancelButtonStyle: ButtonStyle(
    foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.disabled)) {
        return Colors.white38;
      }

      return const Color(0xFF0085fb);
    }),
  ),
  confirmButtonStyle: ButtonStyle(
    foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.disabled)) {
        return Colors.white38;
      }

      return const Color(0xFF0085fb);
    }),
  ),
);
