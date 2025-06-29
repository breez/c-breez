import 'package:c_breez/models/models.dart';
import 'package:c_breez/routes/withdraw/widgets/fee_chooser/widgets/fee_breakdown.dart';
import 'package:c_breez/routes/withdraw/widgets/fee_chooser/widgets/fee_chooser_header.dart';
import 'package:c_breez/routes/withdraw/widgets/fee_chooser/widgets/processing_speed_wait_time.dart';
import 'package:flutter/material.dart';

class FeeChooser extends StatefulWidget {
  final int amountSat;
  final List<FeeOption> feeOptions;
  final int selectedFeeIndex;
  final Function(int) onSelect;

  const FeeChooser({
    required this.amountSat,
    required this.feeOptions,
    required this.selectedFeeIndex,
    required this.onSelect,
    super.key,
  });

  @override
  State<FeeChooser> createState() => _FeeChooserState();
}

class _FeeChooserState extends State<FeeChooser> {
  @override
  Widget build(BuildContext context) {
    final selectedFeeOption = widget.feeOptions.elementAt(widget.selectedFeeIndex);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FeeChooserHeader(
            amountSat: widget.amountSat,
            feeOptions: widget.feeOptions,
            selectedFeeIndex: widget.selectedFeeIndex,
            onSelect: (index) => widget.onSelect(index),
          ),
          const SizedBox(height: 12.0),
          ProcessingSpeedWaitTime(selectedFeeOption.processingSpeed.waitingTime),
          const SizedBox(height: 36.0),
          FeeBreakdown(widget.amountSat, selectedFeeOption),
        ],
      ),
    );
  }
}
