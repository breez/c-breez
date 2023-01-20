import 'package:auto_size_text/auto_size_text.dart';
import 'package:c_breez/theme/theme_provider.dart';
import 'package:flutter/material.dart';

class FeeOptionButton extends StatelessWidget {
  final String text;
  final bool isAffordable;
  final bool isSelected;
  final Function onSelect;

  const FeeOptionButton({
    Key? key,
    required this.text,
    required this.isAffordable,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Expanded(
      child: TextButton(
        onPressed: isAffordable ? () => onSelect() : null,
        child: AutoSizeText(
          text,
          maxLines: 1,
          textAlign: TextAlign.center,
          style: themeData.textTheme.button!.copyWith(
            color: !isAffordable
                ? themeData.primaryColor.withOpacity(0.4)
                : themeData.isLightTheme
                    ? isSelected
                        ? themeData.canvasColor
                        : themeData.primaryColor
                    : Colors.white,
          ),
        ),
      ),
    );
  }
}
