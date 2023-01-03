import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/routes/subswap/swap/get_refund/send_onchain.dart';
import 'package:c_breez/routes/subswap/swap/get_refund/wait_broadcast_dialog.dart';
import 'package:c_breez/widgets/route.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';

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
              () => _refundTransaction(context),
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
          swapInfo.confirmedSats,
          (destAddress, feeRate) => _showWaitToBroadcastDialog(
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
    final texts = context.texts();

    return showDialog<bool>(
      useRootNavigator: false,
      context: context,
      barrierDismissible: false,
      builder: (_) => WaitBroadcastDialog(
        swapInfo.bitcoinAddress,
        destAddress,
        feeRate,
      ),
    ).then((ok) {
      Navigator.of(context).pop();
      // TODO: Do not return null
      return ok != null ? null : Future.error(texts.get_refund_failed);
    });
  }
}
