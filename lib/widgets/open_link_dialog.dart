import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/utils/external_browser.dart';
import 'package:flutter/material.dart';

class OpenLinkDialog extends StatefulWidget {
  final String url;

  const OpenLinkDialog(
    this.url, {
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OpenLinkDialogState();
  }
}

class OpenLinkDialogState extends State<OpenLinkDialog> {
  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final dialogTheme = themeData.dialogTheme;
    final navigator = Navigator.of(context);

    return AlertDialog(
      scrollable: true,
      title: Container(
        height: 64.0,
        padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
        child: Text(
          texts.qr_action_button_open_link,
          textAlign: TextAlign.center,
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.url,
                style: dialogTheme.contentTextStyle!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                width: 0.0,
                height: 16.0,
              ),
              Text(
                texts.qr_action_button_open_link_confirmation,
                style: dialogTheme.contentTextStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.transparent;
                }
                // Defer to the widget's default.
                return themeData.textTheme.button!.color!;
              },
            ),
          ),
          child: Text(
            texts.qr_action_button_open_link_confirmation_no,
            style: themeData.primaryTextTheme.button,
          ),
          onPressed: () => navigator.pop(),
        ),
        TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.transparent;
                }
                // Defer to the widget's default.
                return themeData.textTheme.button!.color!;
              },
            ),
          ),
          child: Text(
            texts.qr_action_button_open_link_confirmation_yes,
            style: themeData.primaryTextTheme.button,
          ),
          onPressed: () async {
            await launchLinkOnExternalBrowser(
              context,
              linkAddress: widget.url,
            );
            navigator.pop();
          },
        ),
      ],
    );
  }
}
