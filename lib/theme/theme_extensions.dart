import 'dart:ui';

import 'package:c_breez/theme/vendor_theme.dart';
import 'package:flutter/material.dart';

import 'breez_colors.dart';

class FieldTextStyle {
  FieldTextStyle._();

  static TextStyle textStyle = TextStyle(
      color: BreezColors.white[500], fontSize: 16.4, letterSpacing: 0.15);
  static TextStyle labelStyle =
      TextStyle(color: BreezColors.white[200], letterSpacing: 0.4);
}

extension CustomStyles on TextTheme {
  TextStyle get itemTitleStyle =>
      TextStyle(color: BreezColors.white[500], fontSize: 16.4);

  TextStyle get itemPriceStyle => TextStyle(
      color: BreezColors.white[500], letterSpacing: 0.5, fontSize: 14.3);
}

extension CustomIconThemes on IconThemeData {
  IconThemeData get deleteBadgeIconTheme =>
      IconThemeData(color: BreezColors.grey[500], size: 20.0);
}

final toolbarTextStyle = const TextTheme(
  headline6:
      TextStyle(color: Colors.white, fontSize: 18.0, letterSpacing: 0.22),
).bodyText2;
const TextStyle drawerItemTextStyle =
    TextStyle(height: 1.2, letterSpacing: 0.25, fontSize: 14.3);
final TextStyle notificationTextStyle = TextStyle(
    color: BreezColors.grey[500],
    fontSize: 10.0,
    letterSpacing: 0.06,
    height: 1.10);
final TextStyle addFundsBtnStyle = TextStyle(
    color: BreezColors.white[400], fontSize: 16.0, letterSpacing: 1.25);
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
final TextStyle addFundsItemsStyle = TextStyle(
    color: BreezColors.white[500],
    fontSize: 14.3,
    letterSpacing: 1.25,
    height: 1.16,
    fontWeight: FontWeight.w500,
    fontFamily: 'IBMPlexSans');
final TextStyle bottomSheetMenuItemStyle = TextStyle(
    color: BreezColors.white[400], fontSize: 14.3, letterSpacing: 0.55);
const TextStyle autoCompleteStyle =
    TextStyle(color: Colors.black, fontSize: 14.0);
final TextStyle blueLinkStyle =
    TextStyle(color: BreezColors.blue[500], fontSize: 16.0, height: 1.5);
final TextStyle avatarDialogStyle = TextStyle(
    color: BreezColors.blue[900],
    fontSize: 16.4,
    letterSpacing: 0.15,
    fontWeight: FontWeight.w500,
    fontFamily: 'IBMPlexSans');
const TextStyle errorStyle = TextStyle(color: errorColor, fontSize: 12.0);
final TextStyle textStyle =
    TextStyle(color: BreezColors.white[400], fontSize: 16.0);
const TextStyle navigationDrawerHandleStyle = TextStyle(
    fontSize: 16.0,
    letterSpacing: 0.2,
    color: Color.fromRGBO(255, 255, 255, 0.6));
const TextStyle warningStyle = TextStyle(color: errorColor, fontSize: 16.0);
final TextStyle instructionStyle =
    TextStyle(color: BreezColors.white[400], fontSize: 14.3);
const TextStyle validatorStyle =
    TextStyle(color: Color(0xFFe3b42f), fontSize: 12.0, height: 1.25);
final TextStyle welcomeTextStyle =
    TextStyle(color: BreezColors.white[500], fontSize: 16.0, height: 1.1);
final TextStyle skipStyle = TextStyle(
    color: BreezColors.white[500], fontSize: 16.0, letterSpacing: 1.25);
final TextStyle buttonStyle = TextStyle(
    color: BreezColors.blue[500], fontSize: 14.3, letterSpacing: 1.25);
final TextStyle whiteButtonStyle = TextStyle(
    color: BreezColors.white[500], fontSize: 14.3, letterSpacing: 1.25);
final TextStyle appBarLogoStyle = TextStyle(
    color: BreezColors.logo[2],
    fontSize: 23.5,
    letterSpacing: 0.15,
    fontFamily: 'Breez Logo',
    height: 0.9);
final TextStyle posTransactionTitleStyle = TextStyle(
    color: BreezColors.white[500],
    fontSize: 14.4,
    letterSpacing: 0.44,
    height: 1.28);
final TextStyle transactionTitleStyle = TextStyle(
    color: BreezColors.white[500],
    fontSize: 14.3,
    letterSpacing: 0.25,
    height: 1.2);
final TextStyle transactionSubtitleStyle = TextStyle(
    color: BreezColors.white[200],
    fontSize: 12.3,
    letterSpacing: 0.4,
    height: 1.16);
final TextStyle transactionAmountStyle = TextStyle(
    color: BreezColors.white[500],
    fontSize: 16.4,
    letterSpacing: 0.5,
    height: 1.28,
    fontWeight: FontWeight.w500,
    fontFamily: 'IBMPlexSans');
const TextStyle posWithdrawalTransactionTitleStyle = TextStyle(
    color: Color.fromRGBO(255, 255, 255, 0.7),
    fontSize: 14.4,
    letterSpacing: 0.44,
    height: 1.28);
const TextStyle posWithdrawalTransactionAmountStyle = TextStyle(
    color: Color.fromRGBO(255, 255, 255, 0.7),
    fontSize: 16.4,
    letterSpacing: 0.5,
    height: 1.28,
    fontWeight: FontWeight.w500,
    fontFamily: 'IBMPlexSans');
final TextStyle cancelButtonStyle = TextStyle(
    color: BreezColors.red[600],
    letterSpacing: 1.25,
    height: 1.16,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    fontFamily: 'IBMPlexSans');
final TextStyle backupPhraseInformationTextStyle = TextStyle(
    color: BreezColors.white[500],
    fontSize: 14.3,
    letterSpacing: 0.4,
    height: 1.16);
final TextStyle backupPhraseConfirmationTextStyle = TextStyle(
    color: BreezColors.white[500],
    fontSize: 14.3,
    letterSpacing: 1.25,
    height: 1.16,
    fontWeight: FontWeight.w500,
    fontFamily: 'IBMPlexSans');
final TextStyle mnemonicsTextStyle = TextStyle(
    color: BreezColors.white[400],
    fontSize: 16.4,
    letterSpacing: 0.73,
    height: 1.25);
final TextStyle invoiceMemoStyle = TextStyle(
    color: BreezColors.grey[500],
    fontSize: 12.3,
    height: 1.16,
    letterSpacing: 0.4);
final TextStyle invoiceChargeAmountStyle = TextStyle(
    color: BreezColors.white[500],
    fontSize: 14.3,
    height: 1.16,
    letterSpacing: 1.25);
final TextStyle invoiceAmountStyle = TextStyle(
    color: BreezColors.grey[600],
    fontSize: 18.0,
    height: 1.32,
    letterSpacing: 0.2);
final TextStyle currencyDropdownStyle = TextStyle(
    color: BreezColors.grey[600],
    fontSize: 16.3,
    height: 1.32,
    letterSpacing: 0.15);
final TextStyle numPadNumberStyle = TextStyle(
    color: BreezColors.white[500], fontSize: 20.0, letterSpacing: 0.18);
final TextStyle numPadAdditionStyle = TextStyle(
    color: BreezColors.white[500], fontSize: 32.0, letterSpacing: 0.18);
final TextStyle smallTextStyle = TextStyle(
    color: BreezColors.white[500], fontSize: 10.0, letterSpacing: 0.09);
final TextStyle linkStyle = TextStyle(
    color: BreezColors.white[300],
    fontSize: 12.3,
    letterSpacing: 0.4,
    height: 1.2,
    decoration: TextDecoration.underline);
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
const TextStyle sessionActionBtnStyle = TextStyle(fontSize: 12.3);
const TextStyle sessionNotificationStyle = TextStyle(fontSize: 14.2);
final TextStyle paymentDetailsTitleStyle = TextStyle(
    color: BreezColors.grey[500],
    fontSize: 14.0,
    letterSpacing: 0.0,
    height: 1.28,
    fontWeight: FontWeight.w500,
    fontFamily: 'IBMPlexSans');
final TextStyle paymentDetailsSubtitleStyle = TextStyle(
    color: BreezColors.grey[500],
    fontSize: 14.0,
    letterSpacing: 0.0,
    height: 1.28);
final TextStyle fastbitcoinsTextStyle = TextStyle(
    color: fastbitcoins.textColor,
    fontSize: 11.0,
    letterSpacing: 0.0,
    fontFamily: 'ComfortaaBold');
final TextStyle vendorTitleStyle = TextStyle(
    color: BreezColors.white[500],
    fontSize: 36.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.1,
    fontFamily: 'Roboto');
final TextStyle fiatConversionTitleStyle = TextStyle(
    color: BreezColors.white[500],
    fontSize: 16.3,
    letterSpacing: 0.25,
    height: 1.2);
final TextStyle fiatConversionDescriptionStyle =
    TextStyle(color: BreezColors.white[200], fontSize: 14.3);
final BoxDecoration boxDecoration = BoxDecoration(
    border:
        Border(bottom: BorderSide(color: BreezColors.white[500]!, width: 1.5)));
final BoxDecoration autoCompleteBoxDecoration = BoxDecoration(
    color: BreezColors.white[500], borderRadius: BorderRadius.circular(3.0));
final Color whiteColor = BreezColors.white[500]!;
final Color snackBarBackgroundColor = BreezColors.blue[300]!;
final Color avatarBackgroundColor = BreezColors.blue[500]!;
final Color sessionAvatarBackgroundColor = BreezColors.white[500]!;
const Color pulseAnimationColor = Color.fromRGBO(100, 155, 230, 1.0);
const Color marketplaceButtonColor = Color.fromRGBO(229, 238, 251, 0.09);
const Color errorColor = Color(0xffffe685);
final Color circularLoaderColor = BreezColors.blue[200]!.withOpacity(0.7);
const Color warningBoxColor = Color.fromRGBO(251, 233, 148, 0.1);
final BorderSide greyBorderSide = BorderSide(color: BreezColors.grey[500]!);
