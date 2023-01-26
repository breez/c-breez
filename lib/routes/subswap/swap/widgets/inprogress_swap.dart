import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/link_launcher.dart';
import 'package:flutter/material.dart';

class SwapInprogress extends StatelessWidget {
  final SwapInfo swap;

  const SwapInprogress({
    required this.swap,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();    
    final List<String> swapTransactions = [];
    swapTransactions.addAll(swap.unconfirmedTxIds);
    swapTransactions.addAll(swap.unconfirmedTxIds);

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 50.0,
            left: 30.0,
            right: 30.0,
          ),
          child: Text(
            texts.add_funds_error_withdraw,
            textAlign: TextAlign.center,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (swapTransactions.isNotEmpty) Padding(
              padding: const EdgeInsets.only(
                top: 30.0,
                left: 30.0,
                right: 30.0,
              ),
              child: _linkLauncher(context, swapTransactions[0]),
            ),
          ],
        )
      ],
    );
  }

  Widget _linkLauncher(BuildContext context, String unconfirmedTxID) {
    final texts = context.texts();
    return LinkLauncher(
      linkName: unconfirmedTxID,
      linkAddress: "https://blockstream.info/tx/$unconfirmedTxID",
      onCopy: () {
        ServiceInjector().device.setClipboardText(unconfirmedTxID);
        showFlushbar(
          context,
          message: texts.add_funds_transaction_id_copied,
          duration: const Duration(seconds: 3),
        );
      },
    );
  }
}
