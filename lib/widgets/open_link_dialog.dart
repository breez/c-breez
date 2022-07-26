import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OpenLinkDialog extends StatefulWidget {
  final String url;
  final Function() onComplete;

  const OpenLinkDialog(
    this.url, {
    required this.onComplete,
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
    final texts = AppLocalizations.of(context)!;
    final dialogTheme = Theme.of(context).dialogTheme;

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
                return Theme.of(context)
                    .textTheme
                    .button!
                    .color!; // Defer to the widget's default.
              },
            ),
          ),
          child: Text(
            texts.qr_action_button_open_link_confirmation_no,
            style: Theme.of(context).primaryTextTheme.button,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.transparent;
                }
                return Theme.of(context)
                    .textTheme
                    .button!
                    .color!; // Defer to the widget's default.
              },
            ),
          ),
          child: Text(
            texts.qr_action_button_open_link_confirmation_yes,
            style: Theme.of(context).primaryTextTheme.button,
          ),
          onPressed: () async {
            final navigator = Navigator.of(context);
            await launchUrlString(widget.url);
            navigator.pop();
            widget.onComplete();
          },
        ),
      ],
    );
  }
}
