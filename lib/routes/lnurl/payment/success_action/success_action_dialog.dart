import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:c_breez/utils/external_browser.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:flutter/material.dart';

class SuccessActionDialog extends StatefulWidget {
  final SuccessAction successAction;

  const SuccessActionDialog(this.successAction);

  @override
  State<StatefulWidget> createState() {
    return SuccessActionDialogState();
  }
}

class SuccessActionDialogState extends State<SuccessActionDialog> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();
    final successAction = widget.successAction;
    return AlertDialog(
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (successAction is SuccessAction_Message) ...[
              Message(successAction.field0.message)
            ],
            if (successAction is SuccessAction_Url) ...[
              Message(successAction.field0.description),
              URLText(successAction.field0.url)
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.transparent;
              }
              // Defer to the widget's default.
              return themeData.textTheme.labelLarge!.color!;
            }),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            texts.lnurl_withdraw_dialog_action_close,
            style: themeData.primaryTextTheme.labelLarge,
          ),
        ),
        if (successAction is SuccessAction_Url) ...[
          TextButton(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.transparent;
                  }
                  // Defer to the widget's default.
                  return themeData.textTheme.labelLarge!.color!;
                },
              ),
            ),
            child: Text(
              "OPEN LINK",
              style: themeData.primaryTextTheme.labelLarge,
            ),
            onPressed: () async {
              final navigator = Navigator.of(context);
              try {
                await launchLinkOnExternalBrowser(
                  context,
                  linkAddress: successAction.field0.url,
                );
                navigator.pop();
              } catch (e) {
                navigator.pop();
                showFlushbar(context, message: extractExceptionMessage(e));
              }
            },
          )
        ]
      ],
    );
  }
}

class Message extends StatelessWidget {
  final String message;

  const Message(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: 200,
          minWidth: double.infinity,
        ),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: AutoSizeText(
              message,
              style: themeData.primaryTextTheme.displaySmall!
                  .copyWith(fontSize: 16),
              textAlign: message.length > 40 && !message.contains("\n")
                  ? TextAlign.start
                  : TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class URLText extends StatelessWidget {
  final String url;

  const URLText(this.url, {super.key});

  @override
  Widget build(BuildContext context) {
    var dialogTheme = Theme.of(context).dialogTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            url,
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
            "Are you sure you want to open this link?",
            style: dialogTheme.contentTextStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
