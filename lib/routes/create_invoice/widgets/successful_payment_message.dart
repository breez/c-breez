import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class SuccessfulPaymentMessage extends StatelessWidget {
  const SuccessfulPaymentMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          texts.successful_payment_received,
          textAlign: TextAlign.center,
          style: themeData.primaryTextTheme.headlineMedium!.copyWith(
            fontSize: 16,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 40),
          child: Container(
            decoration: BoxDecoration(
              color: themeData.dialogTheme.backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Image(
              image: const AssetImage("src/icon/ic_done.png"),
              height: 48.0,
              color: themeData.isLightTheme ? const Color.fromRGBO(0, 133, 251, 1.0) : Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
