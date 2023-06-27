import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/theme/theme_provider.dart';
import 'package:c_breez/widgets/loading_animated_text.dart';
import 'package:flutter/material.dart';

AlertDialog createAnimatedLoaderDialog(
  BuildContext context,
  String text, {
  bool withOKButton = true,
}) {
  final themeData = Theme.of(context);
  final texts = context.texts();
  final navigator = Navigator.of(context);

  return AlertDialog(
    contentPadding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
    content: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        LoadingAnimatedText(
          text,
          textStyle: themeData.dialogTheme.contentTextStyle,
          textAlign: TextAlign.center,
        ),
        Image.asset(
          themeData.isLightTheme ? 'src/images/breez_loader_blue.gif' : 'src/images/breez_loader_dark.gif',
          height: 64.0,
          gaplessPlayback: true,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: withOKButton
              ? [
                  TextButton(
                    child: Text(
                      texts.backup_in_progress_action_confirm,
                      style: themeData.primaryTextTheme.labelLarge,
                    ),
                    onPressed: () => navigator.pop(),
                  ),
                ]
              : [],
        ),
      ],
    ),
  );
}
