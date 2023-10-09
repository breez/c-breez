import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/routes/subswap/swap/get_refund/send_onchain.dart';
import 'package:c_breez/routes/subswap/swap/get_refund/wait_broadcast_dialog.dart';
import 'package:c_breez/widgets/route.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';

final _log = Logger("RefundItemAction");

class RefundItemAction extends StatelessWidget {
  final SwapInfo swapInfo;

  const RefundItemAction(
    this.swapInfo, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 36.0,
            width: 145.0,
            child: SubmitButton(
              texts.get_refund_action_continue,
              swapInfo.refundTxIds.isEmpty ? () => _refundTransaction(context) : null,
            ),
          ),
        ),
      ],
    );
  }

  _refundTransaction(BuildContext context) async {
    final ids = swapInfo.confirmedTxIds;
    String? originalTransaction;
    if (ids.isNotEmpty) {
      originalTransaction = ids[ids.length - 1];
    }

    await Navigator.push(
      context,
      FadeInRoute(
        builder: (_) => SendOnchain(
          amount: swapInfo.confirmedSats,
          onBroadcast: (destAddress, feeRate) => _showWaitToBroadcastDialog(
            context,
            destAddress,
            feeRate,
          ),
          originalTransaction: originalTransaction,
        ),
      ),
    );
  }

  Future<String?> _showWaitToBroadcastDialog(
    BuildContext context,
    String destAddress,
    int feeRate,
  ) {
    _log.fine("showWaitToBroadcastDialog destAddress: $destAddress feeRate: $feeRate");
    final texts = context.texts();

    return showDialog<String>(
      useRootNavigator: false,
      context: context,
      barrierDismissible: false,
      builder: (_) => WaitBroadcastDialog(
        swapInfo.bitcoinAddress,
        destAddress,
        feeRate,
      ),
    ).then((txId) {
      Navigator.of(context).pop();
      return txId != null ? Future.value(txId) : Future.error(texts.get_refund_failed);
    });
  }
}
