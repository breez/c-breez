import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/models/fee_options/fee_option.dart';
import 'package:c_breez/routes/withdraw/widgets/fee_chooser/widgets/fee_option_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeeChooserHeader extends StatefulWidget {
  final int amountSat;
  final List<FeeOption> feeOptions;
  final int selectedFeeIndex;
  final Function(int) onSelect;

  const FeeChooserHeader({
    required this.amountSat,
    required this.feeOptions,
    required this.selectedFeeIndex,
    required this.onSelect,
    super.key,
  });

  @override
  State<FeeChooserHeader> createState() => _FeeChooserHeaderState();
}

class _FeeChooserHeaderState extends State<FeeChooserHeader> {
  late List<FeeOptionButton> feeOptionButtons;

  @override
  Widget build(BuildContext context) {
    final account = context.read<AccountBloc>().state;
    final texts = context.texts();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: List<FeeOptionButton>.generate(
            widget.feeOptions.length,
            (index) {
              var feeOption = widget.feeOptions.elementAt(index);
              return FeeOptionButton(
                index: index,
                text: feeOption.getDisplayName(texts),
                isAffordable: feeOption.isAffordable(
                  balanceSat: account.balanceSat,
                  walletBalanceSat: account.walletBalanceSat,
                  amountSat: widget.amountSat,
                ),
                isSelected: widget.selectedFeeIndex == index,
                onSelect: () => widget.onSelect(index),
              );
            },
          ),
        ),
      ],
    );
  }
}
