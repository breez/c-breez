import 'package:auto_size_text/auto_size_text.dart';
import 'package:c_breez/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class TaglineText extends StatelessWidget {
  const TaglineText({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      // TODO(erdemyerebasmaz): Add message to Breez-Translations
      'Lightning Made Easy',
      textAlign: TextAlign.center,
      style: welcomeTextStyle.copyWith(fontSize: 21.0),
    );
  }
}
