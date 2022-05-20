import 'package:auto_size_text/auto_size_text.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:flutter/material.dart';

class BottomActionItem extends StatelessWidget {
  final String text;
  final AutoSizeGroup group;
  final String iconAssetPath;
  final Function() onPress;
  final Alignment minimizedAlignment;

  const BottomActionItem({
    Key? key,
    required this.text,
    required this.group,
    required this.iconAssetPath,
    required this.onPress,
    this.minimizedAlignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        onPressed: onPress,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: theme.bottomAppBarBtnStyle.copyWith(
            fontSize: 13.5 / MediaQuery.of(context).textScaleFactor,
          ),
          maxLines: 1,
        ),
      ),
    );
  }
}
