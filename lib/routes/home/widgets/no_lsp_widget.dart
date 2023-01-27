import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

class NoLSPWidget extends StatelessWidget {
  const NoLSPWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final foregroundColor = themeData.textTheme.labelLarge!.color!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Text(
            texts.no_lsp_widget_message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: foregroundColor,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 24.0,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  side: BorderSide(
                    color: foregroundColor,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Text(
                  texts.no_lsp_widget_action_select,
                  style: TextStyle(
                    fontSize: 12.3,
                    color: foregroundColor,
                  ),
                ),
                onPressed: () => Navigator.of(context).pushNamed("/select_lsp"),
              ),
            )
          ],
        )
      ],
    );
  }
}
