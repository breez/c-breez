import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:c_breez/utils/min_font_size.dart';
import 'package:flutter/material.dart';

class SwapErrorMessage extends StatelessWidget {
  final String errorMessage;

  const SwapErrorMessage({
    super.key,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 360,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: AutoSizeText(
              extractExceptionMessage(errorMessage, texts),
              textAlign: TextAlign.justify,
              minFontSize: MinFontSize(context).minFontSize,
            ),
          ),
        ),
      ),
    );
  }
}
