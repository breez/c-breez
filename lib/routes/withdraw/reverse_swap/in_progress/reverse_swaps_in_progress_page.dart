import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/routes/withdraw/reverse_swap/in_progress/reverse_swap_in_progress.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
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
