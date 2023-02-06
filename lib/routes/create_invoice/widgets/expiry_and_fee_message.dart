import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/theme/theme_extensions.dart';
import 'package:c_breez/widgets/warning_box.dart';
import 'package:flutter/material.dart';

class ExpiryAndFeeMessage extends StatelessWidget {
  const ExpiryAndFeeMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return WarningBox(
      boxPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      contentPadding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
      backgroundColor: themeData.isLightTheme ? const Color(0xFFf3f8fc) : null,
      borderColor: themeData.isLightTheme ? const Color(0xFF0085fb) : null,
      child: Text(
        texts.qr_code_dialog_warning_message,
        textAlign: TextAlign.center,
        style: themeData.primaryTextTheme.bodySmall,
      ),
    );
  }
}
