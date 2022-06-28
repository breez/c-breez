import 'package:c_breez/bloc/transaction/transaction_state.dart';
import 'package:c_breez/routes/withdraw_funds/withdraw_funds_confirmation_speed_chooser_item.dart';
import 'package:flutter/material.dart';

class WithdrawFundsConfirmationSpeedChooser extends StatelessWidget {
  final WithdrawFudsInfoState transaction;

  const WithdrawFundsConfirmationSpeedChooser(
    this.transaction, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final speed = transaction.selectedSpeed;

    return SizedBox(
      height: 60,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: themeData.highlightColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final third = constraints.maxWidth / 3;
                final offset = third * speed.index; // TODO animation
                return Row(
                  children: [
                    Container(
                      width: offset,
                    ),
                    Container(
                      width: third,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: themeData.backgroundColor,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: const [
                WithdrawFundsConfirmationSpeedChooserItem(
                  TransactionCostSpeed.economy,
                ),
                WithdrawFundsConfirmationSpeedChooserItem(
                  TransactionCostSpeed.regular,
                ),
                WithdrawFundsConfirmationSpeedChooserItem(
                  TransactionCostSpeed.priority,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
