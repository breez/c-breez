import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:flutter/material.dart';

class WithdrawFundsConfirmationSpeedChooserItem extends StatelessWidget {
  final FeeratePreset transactionCostSpeed;
  final FeeratePreset currentSpeed;
  final Function(FeeratePreset) onSpeedSelected;

  const WithdrawFundsConfirmationSpeedChooserItem(
    this.transactionCostSpeed,
    this.currentSpeed,
    this.onSpeedSelected, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    return Expanded(
      child: TextButton(
        onPressed: () => onSpeedSelected(transactionCostSpeed),
        child: AutoSizeText(
          transactionCostSpeed == FeeratePreset.Economy
              ? texts.fee_chooser_option_economy
              : transactionCostSpeed == FeeratePreset.Regular
                  ? texts.fee_chooser_option_regular
                  : texts.fee_chooser_option_priority,
          maxLines: 1,
          textAlign: TextAlign.center,
          style: themeData.textTheme.button!.copyWith(
            color: currentSpeed == transactionCostSpeed ? themeData.canvasColor : themeData.primaryColor,
          ),
        ),
      ),
    );
  }
}
