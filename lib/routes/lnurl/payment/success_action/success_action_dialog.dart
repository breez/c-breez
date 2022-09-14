import 'package:auto_size_text/auto_size_text.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/routes/lnurl/payment/success_action/success_action_data.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SuccessActionDialog extends StatefulWidget {
  final SuccessActionData successActionData;

  const SuccessActionDialog(this.successActionData);

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

    return AlertDialog(
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Message(widget.successActionData.message),
            if (widget.successActionData.url != null) ...[
              URLText(widget.successActionData.url!)
            ]
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
              return Theme.of(context).textTheme.button!.color!;
            }),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            texts.lnurl_withdraw_dialog_action_close,
            style: themeData.primaryTextTheme.button,
          ),
        ),
        if (widget.successActionData.url != null) ...[
          TextButton(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.transparent;
                  }
                  // Defer to the widget's default.
                  return Theme.of(context).textTheme.button!.color!;
                },
              ),
            ),
            child: Text(
              "OPEN LINK",
              style: Theme.of(context).primaryTextTheme.button,
            ),
            onPressed: () async {
              final navigator = Navigator.of(context);
              if (await canLaunchUrlString(widget.successActionData.url!)) {
                await launchUrlString(widget.successActionData.url!);
                navigator.pop();
              } else {
                navigator.pop();
                showFlushbar(context, message: "Can't launch url.");
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
              style:
                  themeData.primaryTextTheme.headline3!.copyWith(fontSize: 16),
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
