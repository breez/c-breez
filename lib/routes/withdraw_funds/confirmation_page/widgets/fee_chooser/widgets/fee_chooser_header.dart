import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/withdraw/withdraw_funds_state.dart';
import 'package:c_breez/routes/withdraw_funds/confirmation_page/widgets/fee_chooser/widgets/fee_option_button.dart';
import 'package:flutter/material.dart';

class FeeChooserHeader extends StatefulWidget {
  final int walletBalance;
  final List<FeeOption> feeOptions;
  final int selectedFeeIndex;
  final Function(int) onSelect;

  const FeeChooserHeader({
    required this.walletBalance,
    required this.feeOptions,
    required this.selectedFeeIndex,
    required this.onSelect,
    Key? key,
  }) : super(key: key);

  @override
  State<FeeChooserHeader> createState() => _FeeChooserHeaderState();
}

class _FeeChooserHeaderState extends State<FeeChooserHeader> {
  late List<FeeOptionButton> feeOptionButtons;
  double? _offset;

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    // TODO: Refactor UI to generate FeeOptionButtons with ListView.builder() while maintaining TweenAnimation
    feeOptionButtons = List<FeeOptionButton>.generate(
      widget.feeOptions.length,
      (index) => FeeOptionButton(
        text: widget.feeOptions.elementAt(index).getDisplayName(texts),
        isAffordable: widget.feeOptions.elementAt(index).isAffordable(widget.walletBalance),
        isSelected: widget.selectedFeeIndex == index,
        onSelect: () => widget.onSelect(index),
      ),
    );

    return SizedBox(
      height: 60,
      child: Stack(children: [
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
              final offset = third * widget.selectedFeeIndex;

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
                    color: themeData.colorScheme.background,
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(children: feeOptionButtons),
        ),
      ]),
    );
  }
}
