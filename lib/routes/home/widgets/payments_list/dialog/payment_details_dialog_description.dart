import 'package:auto_size_text/auto_size_text.dart';
import 'package:c_breez/models/payment_minutiae.dart';
import 'package:flutter/material.dart';

class PaymentDetailsDialogDescription extends StatelessWidget {
  final PaymentMinutiae paymentMinutiae;

  const PaymentDetailsDialogDescription({
    super.key,
    required this.paymentMinutiae,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    final title = paymentMinutiae.title.replaceAll("\n", " ");
    final description = paymentMinutiae.description.trim();
    if (description.isEmpty || title == description) {
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
