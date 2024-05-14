import 'package:c_breez/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'breez_colors.dart';

final ThemeData breezLightTheme = ThemeData(
  useMaterial3: false,
  colorScheme: const ColorScheme.dark().copyWith(
    primary: Colors.white,
    secondary: Colors.white,
    onSecondary: const Color.fromRGBO(0, 133, 251, 1.0),
    error: const Color(0xffffe685),
    surface: Colors.white,
  ),
  primaryColor: const Color.fromRGBO(255, 255, 255, 1.0),
  primaryColorDark: BreezColors.blue[900],
  primaryColorLight: const Color.fromRGBO(0, 133, 251, 1.0),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color.fromRGBO(0, 133, 251, 1.0),
    sizeConstraints: BoxConstraints(minHeight: 64, minWidth: 64),
  ),
  canvasColor: BreezColors.blue[500],
  bottomAppBarTheme: const BottomAppBarTheme(elevation: 0, color: Color(0xFF0085fb)),
  appBarTheme: AppBarTheme(
    centerTitle: false,
    backgroundColor: BreezColors.blue[500],
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    toolbarTextStyle: toolbarTextStyle,
    titleTextStyle: titleTextStyle,
    elevation: 0.0,
    actionsIconTheme: const IconThemeData(
      color: Color.fromRGBO(0, 120, 253, 1.0),
    ),
    systemOverlayStyle: SystemUiOverlayStyle.light,
  ),
  dialogTheme: DialogTheme(
    titleTextStyle: TextStyle(color: BreezColors.grey[600], fontSize: 20.5, letterSpacing: 0.25),
    contentTextStyle: TextStyle(color: BreezColors.grey[500], fontSize: 16.0, height: 1.5),
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
    ),
  ),
  dialogBackgroundColor: Colors.transparent,
  dividerColor: const Color(0x33ffffff),
  cardColor: BreezColors.blue[500], // will be replaced with CardTheme.color
  cardTheme: CardTheme(color: BreezColors.blue[500]),
  highlightColor: BreezColors.blue[200],
  textTheme: TextTheme(
      titleSmall: TextStyle(color: BreezColors.grey[600], fontSize: 14.3, letterSpacing: 0.2),
      headlineSmall: TextStyle(color: BreezColors.grey[600], fontSize: 26.0),
      labelLarge: TextStyle(color: BreezColors.blue[500], fontSize: 14.3, letterSpacing: 1.25),
      headlineMedium: const TextStyle(
        color: Color(0xffffe685),
        fontSize: 18.0,
      ),
      titleLarge: const TextStyle(
          color: Colors.white,
          fontSize: 12.3,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          height: 1.22)),
  primaryTextTheme: TextTheme(
    headlineMedium: TextStyle(
        color: BreezColors.grey[500],
        fontSize: 14.0,
        letterSpacing: 0.0,
        height: 1.28,
        fontWeight: FontWeight.w500,
        fontFamily: 'IBMPlexSans'),
    displaySmall: TextStyle(color: BreezColors.grey[500], fontSize: 14.0, letterSpacing: 0.0, height: 1.28),
    headlineSmall: TextStyle(
        color: BreezColors.grey[500],
        fontSize: 24.0,
        letterSpacing: 0.0,
        height: 1.28,
        fontWeight: FontWeight.w500,
        fontFamily: 'IBMPlexSans'),
    bodyMedium: TextStyle(
        color: BreezColors.blue[900],
        fontSize: 16.4,
        letterSpacing: 0.15,
        fontWeight: FontWeight.w500,
        fontFamily: 'IBMPlexSans'),
    titleSmall: TextStyle(color: BreezColors.white[500], fontSize: 10.0, letterSpacing: 0.09),
    labelLarge: TextStyle(color: BreezColors.blue[500], fontSize: 14.3, letterSpacing: 1.25),
    bodySmall: TextStyle(color: BreezColors.grey[500], fontSize: 12.0),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    selectionColor: Color.fromRGBO(0, 133, 251, 0.25),
    selectionHandleColor: Color(0xFF0085fb),
  ),
  primaryIconTheme: IconThemeData(color: BreezColors.grey[500]),
  fontFamily: 'IBMPlexSans',
  textButtonTheme: const TextButtonThemeData(),
  outlinedButtonTheme: const OutlinedButtonThemeData(),
  elevatedButtonTheme: const ElevatedButtonThemeData(),
  radioTheme: RadioThemeData(
    fillColor: MaterialStateProperty.resolveWith(
      (states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF0085fb);
        } else {
          return const Color(0x8a000000);
        }
      },
    ),
  ),
  chipTheme: const ChipThemeData(backgroundColor: Color(0xFF0085fb)),
  datePickerTheme: calendarLightTheme,
);

final DatePickerThemeData calendarLightTheme = DatePickerThemeData(
  weekdayStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
  yearBackgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
    if (states.contains(MaterialState.selected)) {
      return const Color.fromRGBO(5, 93, 235, 1.0);
    }
    return Colors.transparent;
  }),
  yearForegroundColor: MaterialStateProperty.resolveWith<Color>((states) {
    if (states.contains(MaterialState.selected)) {
      return Colors.white;
    }
    if (states.contains(MaterialState.disabled)) {
      return Colors.black38;
    }
    return Colors.black;
  }),
  dayBackgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
    if (states.contains(MaterialState.selected)) {
      return const Color.fromRGBO(5, 93, 235, 1.0);
    }
    return Colors.transparent;
  }),
  dayForegroundColor: MaterialStateProperty.resolveWith<Color>((states) {
    if (states.contains(MaterialState.selected)) {
      return Colors.white;
    }
    if (states.contains(MaterialState.disabled)) {
      return Colors.black38;
    }
    return Colors.black;
  }),
  todayBackgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
    if (states.contains(MaterialState.selected)) {
      return const Color.fromRGBO(5, 93, 235, 1.0);
    }
    return Colors.transparent;
  }),
  todayForegroundColor: MaterialStateProperty.resolveWith<Color>((states) {
    if (states.contains(MaterialState.selected)) {
      return Colors.white;
    }
    if (states.contains(MaterialState.disabled)) {
      return Colors.black38;
    }
    return const Color.fromRGBO(5, 93, 235, 1.0);
  }),
  todayBorder: const BorderSide(color: Color.fromRGBO(5, 93, 235, 1.0)),
  headerBackgroundColor: const Color.fromRGBO(5, 93, 235, 1.0),
  headerForegroundColor: Colors.white,
  backgroundColor: Colors.white,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(12.0),
    ),
  ),
  cancelButtonStyle: ButtonStyle(
    foregroundColor: MaterialStateProperty.resolveWith<Color?>(
      (states) {
        if (states.contains(MaterialState.disabled)) {
          return Colors.black38;
        }

        return const Color.fromRGBO(5, 93, 235, 1.0);
      },
    ),
  ),
  confirmButtonStyle: ButtonStyle(
    foregroundColor: MaterialStateProperty.resolveWith<Color?>(
      (states) {
        if (states.contains(MaterialState.disabled)) {
          return Colors.black38;
        }

        return const Color.fromRGBO(5, 93, 235, 1.0);
      },
    ),
  ),
);
