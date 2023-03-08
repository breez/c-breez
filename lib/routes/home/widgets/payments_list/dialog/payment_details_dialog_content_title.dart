import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/utils/extensions/payment_extensions.dart';
import 'package:flutter/material.dart';

class PaymentDetailsDialogContentTitle extends StatefulWidget {
  final Payment paymentInfo;

  const PaymentDetailsDialogContentTitle({
    super.key,
    required this.paymentInfo,
  });

  @override
  State<PaymentDetailsDialogContentTitle> createState() => _PaymentDetailsDialogContentTitleState();
}

class _PaymentDetailsDialogContentTitleState extends State<PaymentDetailsDialogContentTitle> {
  PaymentExtensions? paymentExtensions;

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final paymentExtensions = this.paymentExtensions ??= PaymentExtensions(widget.paymentInfo, texts);

    final title = paymentExtensions.title();
    if (title.isEmpty) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: 8,
      ),
      child: AutoSizeText(
        title,
        style: themeData.primaryTextTheme.titleLarge,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}
