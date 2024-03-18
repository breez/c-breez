import 'package:breez_sdk/sdk.dart';
import 'package:c_breez/routes/withdraw/reverse_swap/in_progress/reverse_swap_in_progress.dart';
import 'package:flutter/material.dart';

class ReverseSwapsInProgressPage extends StatefulWidget {
  final List<ReverseSwapInfo> reverseSwaps;
  const ReverseSwapsInProgressPage({super.key, required this.reverseSwaps});

  @override
  State<ReverseSwapsInProgressPage> createState() => _ReverseSwapsInProgressPageState();
}

class _ReverseSwapsInProgressPageState extends State<ReverseSwapsInProgressPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.reverseSwaps.length,
      itemBuilder: (context, index) {
        ReverseSwapInfo reverseSwap = widget.reverseSwaps[index];

        return ReverseSwapInprogress(reverseSwap: reverseSwap);
      },
    );
  }
}
