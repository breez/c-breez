import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/utils/extensions/payment_extensions.dart';
import 'package:flutter/material.dart';

class PaymentDetailsDialogDescription extends StatefulWidget {
  final Payment paymentInfo;

  const PaymentDetailsDialogDescription({
    super.key,
    required this.paymentInfo,
  });

  @override
  State<PaymentDetailsDialogDescription> createState() => _PaymentDetailsDialogDescriptionState();
}

class _PaymentDetailsDialogDescriptionState extends State<PaymentDetailsDialogDescription> {
  PaymentExtensions? paymentExtensions;

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final paymentExtensions = this.paymentExtensions ??= PaymentExtensions(widget.paymentInfo, texts);

    final description = paymentExtensions.description();
    if (description.isEmpty) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: 54,
          minWidth: double.infinity,
        ),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: AutoSizeText(
              description,
              style: themeData.primaryTextTheme.headlineMedium,
              textAlign:
                  description.length > 40 && !description.contains("\n") ? TextAlign.start : TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
