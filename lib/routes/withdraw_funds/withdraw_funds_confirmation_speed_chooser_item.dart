import 'package:auto_size_text/auto_size_text.dart';
import 'package:c_breez/bloc/withdraw/withdraw_funds_state.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/theme/theme_provider.dart';
import 'package:flutter/material.dart';

class WithdrawFundsConfirmationSpeedChooserItem extends StatelessWidget {
  final TransactionCost transactionCostSpeed;
  final TransactionCost currentCost;
  final Function(TransactionCost) onCostChanged;

  const WithdrawFundsConfirmationSpeedChooserItem(
    this.transactionCostSpeed,
    this.currentCost,
    this.onCostChanged, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    return Expanded(
      child: TextButton(
        onPressed: () => onCostChanged(transactionCostSpeed),
        child: AutoSizeText(
          transactionCostSpeed.kind == TransactionCostKind.economy
              ? texts.fee_chooser_option_economy
              : transactionCostSpeed.kind == TransactionCostKind.regular
                  ? texts.fee_chooser_option_regular
                  : texts.fee_chooser_option_priority,
          maxLines: 1,
          textAlign: TextAlign.center,
          style: themeData.textTheme.button!.copyWith(
            color: themeData.isLightTheme
                ? currentCost == transactionCostSpeed
                    ? themeData.canvasColor
                    : themeData.primaryColor
                : Colors.white,
          ),
        ),
      ),
    );
  }
}
