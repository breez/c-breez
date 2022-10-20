import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:share_extend/share_extend.dart';

class SwapDialog extends StatelessWidget {
  final String backupJson;

  const SwapDialog({
    Key? key,
    required this.backupJson,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 4.0),
      content: RichText(
        text: TextSpan(
          text: texts.invoice_btc_address_on_chain_begin,
          style: themeData.dialogTheme.contentTextStyle,
          children: [
            TextSpan(
              text: texts.invoice_btc_address_on_chain_here,
              style: const TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  final RenderBox? box =
                      context.findRenderObject() as RenderBox?;
                  ShareExtend.share(
                    backupJson,
                    "text",
                    sharePositionOrigin:
                        box!.localToGlobal(Offset.zero) & box.size,
                  );
                },
            ),
            TextSpan(text: texts.invoice_btc_address_on_chain_end),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            texts.invoice_btc_address_on_chain_action_ok,
            style: themeData.primaryTextTheme.button,
          ),
        ),
      ],
    );
  }
}
