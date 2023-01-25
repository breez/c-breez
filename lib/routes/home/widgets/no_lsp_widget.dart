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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              texts.no_lsp_widget_message,
            )
          ],
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
                    color: themeData.textTheme.labelLarge!.color!,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Text(
                  texts.no_lsp_widget_action_select,
                  style: TextStyle(
                    fontSize: 12.3,
                    color: themeData.textTheme.labelLarge!.color!,
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
