import 'package:auto_size_text/auto_size_text.dart';
import 'package:c_breez/utils/min_font_size.dart';
import 'package:c_breez/widgets/warning_box.dart';
import 'package:flutter/material.dart';

class SwapErrorMessage extends StatelessWidget {
  final String errorMessage;

  const SwapErrorMessage({
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
          child: WarningBox(
            boxPadding: EdgeInsets.zero,
            contentPadding: const EdgeInsets.all(8),
            child: AutoSizeText(
              errorMessage,
              maxLines: 2,
              textAlign: TextAlign.center,
              minFontSize: MinFontSize(context).minFontSize,
            ),
          ),
        ),
      ),
    );
  }
}
