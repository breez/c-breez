import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/routes/home/warning_action.dart';
import 'package:c_breez/widgets/build_context_flushbar.dart';
import 'package:flutter/material.dart';

class AccountRequiredActionsIndicator extends StatelessWidget {
  const AccountRequiredActionsIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        WarningAction(
          onPressed: () => context.flushbar(texts.app_name),
        ),
      ],
    );
  }
}
