import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:flutter/material.dart';

class WarningBox extends StatelessWidget {
  final EdgeInsets boxPadding;
  final EdgeInsets contentPadding;
  final Widget child;
  final Color? backgroundColor;
  final Color? borderColor;

  const WarningBox({
    Key? key,
    required this.child,
    this.boxPadding = const EdgeInsets.symmetric(
      vertical: 16,
      horizontal: 30,
    ),
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 12.3,
      vertical: 16.2,
    ),
    this.backgroundColor,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: boxPadding,
      child: Container(
        padding: contentPadding,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: _backgroundColor(),
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          border: Border.all(color: borderColor ?? Theme.of(context).warningBoxBorderColor),
        ),
        child: child,
      ),
    );
  }

  Color _backgroundColor() => backgroundColor ?? theme.warningBoxColor;
}
