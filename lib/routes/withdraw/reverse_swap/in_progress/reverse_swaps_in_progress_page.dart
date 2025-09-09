import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
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
    final texts = context.texts();

    return Padding(
      padding: const EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0),
      child: Column(
        children: [
          Text(texts.swap_in_progress_message_waiting_confirmation, textAlign: TextAlign.center),
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.reverseSwaps.length,
            itemBuilder: (context, index) {
              ReverseSwapInfo reverseSwap = widget.reverseSwaps[index];
              // Lockup tx id is always available at this stage, added null-handling for safety
              final lockupTxid = reverseSwap.lockupTxid;
              return Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: ReverseSwapInProgress(lockupTxid: (lockupTxid != null) ? lockupTxid : ""),
              );
            },
          ),
        ],
      ),
    );
  }
}
