import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/theme/theme_provider.dart';
import 'package:c_breez/utils/min_font_size.dart';
import 'package:c_breez/widgets/loading_animated_text.dart';
import 'package:flutter/material.dart';

class StatusText extends StatelessWidget {
  final String? message;
  final bool isConnecting;

  const StatusText({
    Key? key,
    this.message,
    this.isConnecting = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isConnecting || message != null) {
      return LoadingAnimatedText(isConnecting ? "" : message!);
    } else {
      final texts = context.texts();
      final themeData = Theme.of(context);

      return AutoSizeText(
        texts.status_text_ready,
        style: themeData.textTheme.bodyMedium?.copyWith(
          color: themeData.isLightTheme
              ? BreezColors.grey[600]
              : themeData.colorScheme.onSecondary,
        ),
        textAlign: TextAlign.center,
        minFontSize: MinFontSize(context).minFontSize,
        stepGranularity: 0.1,
      );
    }
  }
}
