import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:flutter/material.dart';

class ProcessingPaymentTitle extends StatelessWidget {
  const ProcessingPaymentTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return Container(
      height: 64.0,
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
      child: Text(
        texts.processing_payment_dialog_processing_payment,
        style: themeData.dialogTheme.titleTextStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}
