import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

class HeaderFee extends StatelessWidget {
  const HeaderFee({super.key});

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Text(
              texts.payment_options_fee_header,
              style: themeData.primaryTextTheme.displaySmall?.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
