import 'package:auto_size_text/auto_size_text.dart';
import 'package:c_breez/utils/min_font_size.dart';
import 'package:flutter/material.dart';

class DepositErrorMessage extends StatelessWidget {
  final String errorMessage;

  const DepositErrorMessage({
    super.key,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 360,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: AutoSizeText(
              errorMessage,
              textAlign: TextAlign.justify,
              minFontSize: MinFontSize(context).minFontSize,
            ),
          ),
        ),
      ),
    );
  }
}
