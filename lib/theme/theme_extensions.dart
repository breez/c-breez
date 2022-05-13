import 'dart:ui';

import 'package:flutter/material.dart';

import 'breez_colors.dart';

class FieldTextStyle {
  FieldTextStyle._();

  static TextStyle textStyle = TextStyle(
      color: BreezColors.white[500], fontSize: 16.4, letterSpacing: 0.15);
  static TextStyle labelStyle =
      TextStyle(color: BreezColors.white[200], letterSpacing: 0.4);
}

final toolbarTextStyle = const TextTheme(
  headline6:
      TextStyle(color: Colors.white, fontSize: 18.0, letterSpacing: 0.22),
).bodyText2;
final titleTextStyle = const TextTheme(
  headline6:
  TextStyle(color: Colors.white, fontSize: 18.0, letterSpacing: 0.22),
).headline6;
const TextStyle drawerItemTextStyle =
    TextStyle(height: 1.2, letterSpacing: 0.25, fontSize: 14.3);
const TextStyle bottomAppBarBtnStyle = TextStyle(
    color: Colors.white,
    fontSize: 13.5,
    letterSpacing: 1.2,
    fontWeight: FontWeight.w600,
    height: 1.24,
    fontFamily: 'IBMPlexSans');
const TextStyle bottomSheetTextStyle = TextStyle(
    fontFamily: 'IBMPlexSans',
    fontSize: 15,
    letterSpacing: 1.2,
    fontWeight: FontWeight.w400,
    height: 1.30);
final TextStyle bottomSheetMenuItemStyle = TextStyle(
    color: BreezColors.white[400], fontSize: 14.3, letterSpacing: 0.55);
final TextStyle blueLinkStyle =
    TextStyle(color: BreezColors.blue[500], fontSize: 16.0, height: 1.5);
final TextStyle textStyle =
    TextStyle(color: BreezColors.white[400], fontSize: 16.0);
const TextStyle navigationDrawerHandleStyle = TextStyle(
    fontSize: 16.0,
    letterSpacing: 0.2,
    color: Color.fromRGBO(255, 255, 255, 0.6));
const TextStyle warningStyle = TextStyle(color: errorColor, fontSize: 16.0);
const TextStyle validatorStyle =
    TextStyle(color: Color(0xFFe3b42f), fontSize: 12.0, height: 1.25);
final TextStyle welcomeTextStyle =
    TextStyle(color: BreezColors.white[500], fontSize: 16.0, height: 1.1);
final TextStyle buttonStyle = TextStyle(
    color: BreezColors.blue[500], fontSize: 14.3, letterSpacing: 1.25);
final TextStyle whiteButtonStyle = TextStyle(
    color: BreezColors.white[500], fontSize: 14.3, letterSpacing: 1.25);
final TextStyle cancelButtonStyle = TextStyle(
    color: BreezColors.red[600],
    letterSpacing: 1.25,
    height: 1.16,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    fontFamily: 'IBMPlexSans');
final TextStyle restoreLinkStyle = TextStyle(
    color: BreezColors.white[300],
    fontSize: 12.0,
    letterSpacing: 0.4,
    height: 1.2,
    decoration: TextDecoration.underline);
final TextStyle snackBarStyle = TextStyle(
    color: BreezColors.white[500],
    fontSize: 14.0,
    letterSpacing: 0.25,
    height: 1.2);
final TextStyle fiatConversionTitleStyle = TextStyle(
    color: BreezColors.white[500],
    fontSize: 16.3,
    letterSpacing: 0.25,
    height: 1.2);
final TextStyle fiatConversionDescriptionStyle =
    TextStyle(color: BreezColors.white[200], fontSize: 14.3);
final Color snackBarBackgroundColor = BreezColors.blue[300]!;
final Color sessionAvatarBackgroundColor = BreezColors.white[500]!;
const Color marketplaceButtonColor = Color.fromRGBO(229, 238, 251, 0.09);
const Color errorColor = Color(0xffffe685);
final Color circularLoaderColor = BreezColors.blue[200]!.withOpacity(0.7);
const Color warningBoxColor = Color.fromRGBO(251, 233, 148, 0.1);
final BorderSide greyBorderSide = BorderSide(color: BreezColors.grey[500]!);
