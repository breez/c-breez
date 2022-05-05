import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/widgets/error_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void showProviderErrorDialog(BuildContext context, Function() onSelect) {
  String message = "In order to activate Breez, please ";
  message =
      "There was an error connecting to the selected provider. " + message;
  promptError(
    context,
    "Connection Error",
    RichText(
      text: TextSpan(
          style: Theme.of(context).dialogTheme.contentTextStyle,
          text: message,
          children: <TextSpan>[
            TextSpan(
                text: "select ",
                style: theme.blueLinkStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    Navigator.of(context).pop();
                    onSelect();
                  }),
            TextSpan(
                text: "a provider.",
                style: Theme.of(context).dialogTheme.contentTextStyle),
          ]),
    ),
  );
}
