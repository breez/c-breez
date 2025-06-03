import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/widgets/warning_box.dart';
import 'package:flutter/material.dart';

class PaymentOptionWarning extends StatelessWidget {
  const PaymentOptionWarning({super.key});

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return WarningBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            texts.payment_options_fee_warning,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
