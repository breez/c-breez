import 'package:auto_size_text/auto_size_text.dart';
import 'package:c_breez/utils/utils.dart';
import 'package:flutter/material.dart';

class SimpleSwitch extends StatelessWidget {
  final String text;
  final bool switchValue;
  final Widget? trailing;
  final AutoSizeGroup? group;
  final GestureTapCallback? onTap;
  final ValueChanged<bool>? onChanged;

  const SimpleSwitch({
    super.key,
    required this.text,
    required this.switchValue,
    this.trailing,
    this.group,
    this.onTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: AutoSizeText(
        text,
        style: const TextStyle(color: Colors.white),
        maxLines: 1,
        minFontSize: MinFontSize(context).minFontSize,
        stepGranularity: 0.1,
        group: group,
      ),
      trailing: trailing ?? Switch(value: switchValue, activeColor: Colors.white, onChanged: onChanged),
      onTap: onTap,
    );
  }
}
