import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WarningAction extends StatelessWidget {
  final void Function() onPressed;

  const WarningAction({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return IconButton(
      iconSize: 45.0,
      padding: EdgeInsets.zero,
      icon: SizedBox(
        width: 45.0,
        child: SvgPicture.asset(
          "src/icon/warning.svg",
          color: themeData.appBarTheme.actionsIconTheme?.color,
        ),
      ),
      tooltip: texts.account_required_actions_backup,
      onPressed: onPressed,
    );
  }
}
