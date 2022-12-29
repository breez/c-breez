import 'package:c_breez/bloc/withdraw/withdraw_funds_state.dart';
import 'package:c_breez/routes/withdraw_funds/withdraw_funds_confirmation_speed_chooser_item.dart';
import 'package:flutter/material.dart';

class WithdrawFundsConfirmationSpeedChooser extends StatefulWidget {
  final TransactionCost currentCost;
  final Function(TransactionCost) onCostChanged;
  final TransactionCost economy;
  final TransactionCost regular;
  final TransactionCost priority;

  const WithdrawFundsConfirmationSpeedChooser({
    required this.currentCost,
    required this.onCostChanged,
    required this.economy,
    required this.regular,
    required this.priority,
    Key? key,
  }) : super(key: key);

  @override
  State<WithdrawFundsConfirmationSpeedChooser> createState() => _WithdrawFundsConfirmationSpeedChooserState();
}

class _WithdrawFundsConfirmationSpeedChooserState extends State<WithdrawFundsConfirmationSpeedChooser> {
  double? _offset;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

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
                final offset = third *
                    (widget.currentCost.kind == TransactionCostKind.economy
                        ? 0
                        : widget.currentCost.kind == TransactionCostKind.regular
                            ? 1
                            : 2);

                return TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: _offset ?? offset, end: offset),
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  builder: (context, offset, child) {
                    _offset = offset;
                    return Row(
                      children: [
                        Container(
                          width: offset,
                        ),
                        child!,
                      ],
                    );
                  },
                  child: Container(
                    width: third,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: themeData.backgroundColor,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                WithdrawFundsConfirmationSpeedChooserItem(
                  widget.economy,
                  widget.currentCost,
                  widget.onCostChanged,
                ),
                WithdrawFundsConfirmationSpeedChooserItem(
                  widget.regular,
                  widget.currentCost,
                  widget.onCostChanged,
                ),
                WithdrawFundsConfirmationSpeedChooserItem(
                  widget.priority,
                  widget.currentCost,
                  widget.onCostChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
