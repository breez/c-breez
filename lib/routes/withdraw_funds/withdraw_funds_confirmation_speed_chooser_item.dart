import 'package:auto_size_text/auto_size_text.dart';
import 'package:c_breez/bloc/withdraw/withdraw_funds_bloc.dart';
import 'package:c_breez/bloc/withdraw/withdraw_funds_state.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WithdrawFundsConfirmationSpeedChooserItem extends StatelessWidget {
  final TransactionCostSpeed transactionCostSpeed;

  const WithdrawFundsConfirmationSpeedChooserItem(
    this.transactionCostSpeed, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    return BlocBuilder<WithdrawFudsBloc, WithdrawFudsState>(
      builder: (context, transaction) {
        if (transaction is WithdrawFudsInfoState) {
          final speed = transaction.selectedSpeed;
          return Expanded(
            child: TextButton(
              onPressed: () => context
                  .read<WithdrawFudsBloc>()
                  .selectTransactionSpeed(transactionCostSpeed),
              child: AutoSizeText(
                transactionCostSpeed == TransactionCostSpeed.economy
                    ? texts.fee_chooser_option_economy
                    : transactionCostSpeed == TransactionCostSpeed.regular
                        ? texts.fee_chooser_option_regular
                        : texts.fee_chooser_option_priority,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: themeData.textTheme.button!.copyWith(
                  color: speed == transactionCostSpeed
                      ? themeData.canvasColor
                      : themeData.primaryColor,
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
