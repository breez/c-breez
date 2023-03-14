import 'package:breez_translations/breez_translations_locales.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';

final _log = FimberLog("OverrideFee");

class OverrideFee extends StatelessWidget {
  const OverrideFee({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return CheckboxListTile(
      activeColor: Colors.white,
      checkColor: themeData.canvasColor,
      controlAffinity: ListTileControlAffinity.leading,
      // TODO real implementation
      value: true,
      // TODO real implementation
      onChanged: (value) {
        _log.v("onChanged: $value");
      },
      title: Text(
        texts.payment_options_fee_override_enable,
        style: themeData.primaryTextTheme.displaySmall?.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}
