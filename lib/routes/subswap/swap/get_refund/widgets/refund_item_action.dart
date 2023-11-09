import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/refund/refund_bloc.dart';
import 'package:c_breez/routes/subswap/swap/get_refund/send_onchain.dart';
import 'package:c_breez/routes/subswap/swap/get_refund/wait_broadcast_dialog.dart';
import 'package:c_breez/widgets/error_dialog.dart';
import 'package:c_breez/widgets/route.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger("RefundItemAction");

class RefundItemAction extends StatefulWidget {
  final SwapInfo swapInfo;

  const RefundItemAction(
    this.swapInfo, {
    super.key,
  });

  @override
  State<RefundItemAction> createState() => _RefundItemActionState();
}

class _RefundItemActionState extends State<RefundItemAction> {
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
              widget.swapInfo.refundTxIds.isEmpty ? () => _refundTransaction() : null,
            ),
          ),
        ),
      ],
    );
  }

  _refundTransaction() async {
    final ids = widget.swapInfo.confirmedTxIds;
    String? originalTransaction;
    if (ids.isNotEmpty) {
      originalTransaction = ids[ids.length - 1];
    }

    await Navigator.push(
      context,
      FadeInRoute(
        builder: (_) => SendOnchain(
          amount: widget.swapInfo.confirmedSats,
          onBroadcast: (toAddress, satPerVbyte) => _showWaitToBroadcastDialog(toAddress, satPerVbyte),
          originalTransaction: originalTransaction,
        ),
      ),
    );
  }

  Future<String?> _showWaitToBroadcastDialog(String toAddress, int satPerVbyte) async {
    final refundBloc = context.read<RefundBloc>();
    final texts = context.texts();
    _log.info("showWaitToBroadcastDialog toAddress: $toAddress feeRate: $satPerVbyte sat/Vbyte");

    // Prepare refund and display the fees to the user for them to approve
    final prepareRefundReq = PrepareRefundRequest(
      swapAddress: widget.swapInfo.bitcoinAddress,
      toAddress: toAddress,
      satPerVbyte: satPerVbyte,
    );
    return await refundBloc.prepareRefund(req: prepareRefundReq).then((feeSat) async {
      return await promptAreYouSure(
        context,
        texts.get_refund_title,
        // TODO: Decide on the text to be shown for title, content and buttons and add them to Breez-Translations, prepare_refund_title, prepare_refund_action_xxx
        Text(
          "A fee of $feeSat sats will be applied to refund request to ${widget.swapInfo.bitcoinAddress} for ${widget.swapInfo.confirmedSats} sats",
        ),
        okText: texts.payment_request_dialog_action_approve,
        cancelText: texts.payment_request_dialog_action_cancel,
      ).then((ok) async {
        // Once fees are approved, proceed with refund
        if (ok == true) {
          return await _broadcastRefund(toAddress: toAddress, satPerVbyte: satPerVbyte, feeSat: feeSat);
        } else if (ok == false) {
          // TODO: Add text to Breez-Translations
          return Future.error("Refund cancelled");
        } else {
          return Future.error(texts.get_refund_failed);
        }
      });
    }, onError: (e) async {
      // If fees can't be fetched, proceed with refund w/o known fees
      // If prepare refund failing implies refund can't be processed, handle the error gracefully
      _log.warning("PrepareRefund failed, resuming with refund w/o fees.");
      // TODO: If feeSat isn't available, display the error on WaitBroadcastDialog "There was a problem fetching fees", "Fees can't be known at this time" etc.
      return await _broadcastRefund(toAddress: toAddress, satPerVbyte: satPerVbyte);
    });
  }

  Future<String?> _broadcastRefund({
    required String toAddress,
    required int satPerVbyte,
    int? feeSat, // TODO: Display the fees on WaitBroadcastDialog
  }) {
    final texts = context.texts();

    final req = RefundRequest(
      swapAddress: widget.swapInfo.bitcoinAddress,
      toAddress: toAddress,
      satPerVbyte: satPerVbyte,
    );
    return showDialog<String>(
      useRootNavigator: false,
      context: context,
      barrierDismissible: false,
      builder: (_) => WaitBroadcastDialog(req: req, feeSat: feeSat),
    ).then((txId) {
      Navigator.of(context).pop();
      return txId != null ? Future.value(txId) : Future.error(texts.get_refund_failed);
    });
  }
}
