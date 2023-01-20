import 'package:c_breez/bloc/withdraw/withdraw_funds_state.dart';
import 'package:c_breez/routes/withdraw_funds/confirmation_page/widgets/fee_chooser/widgets/fee_breakdown.dart';
import 'package:c_breez/routes/withdraw_funds/confirmation_page/widgets/fee_chooser/widgets/fee_chooser_header.dart';
import 'package:c_breez/routes/withdraw_funds/confirmation_page/widgets/fee_chooser/widgets/processing_speed_wait_time.dart';
import 'package:flutter/material.dart';

class FeeChooser extends StatefulWidget {
  final int walletBalance;
  final List<FeeOption> feeOptions;
  final int selectedFeeIndex;
  final Function(int) onSelect;

  const FeeChooser({
    required this.walletBalance,
    required this.feeOptions,
    required this.selectedFeeIndex,
    required this.onSelect,
    Key? key,
  }) : super(key: key);

  @override
  State<FeeChooser> createState() => _FeeChooserState();
}

class _FeeChooserState extends State<FeeChooser> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FeeChooserHeader(
            walletBalance: widget.walletBalance,
            feeOptions: widget.feeOptions,
            selectedFeeIndex: widget.selectedFeeIndex,
            onSelect: (index) => widget.onSelect(index),
          ),
          const SizedBox(height: 16.0),
          ProcessingSpeedWaitTime(
            context,
            widget.feeOptions.elementAt(widget.selectedFeeIndex).waitingTime,
          ),
          const SizedBox(height: 16.0),
          FeeBreakdown(
            widget.walletBalance,
            widget.feeOptions.elementAt(widget.selectedFeeIndex).fee,
          ),
        ],
      ),
    );
  }
}
