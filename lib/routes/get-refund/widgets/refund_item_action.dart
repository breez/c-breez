import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/network/network_settings_bloc.dart';
import 'package:c_breez/routes/get-refund/refund_page.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/tx_widget.dart';
import 'package:c_breez/utils/blockchain_explorer_utils.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:c_breez/widgets/route.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final networkSettingsBloc = context.read<NetworkSettingsBloc>();
    final ids = widget.swapInfo.confirmedTxIds;
    final refundTxIds = widget.swapInfo.refundTxIds;

    final txID = _extractRefundTxid(refundTxIds) ?? ids[ids.length - 1];

    return FutureBuilder(
      future: networkSettingsBloc.mempoolInstance,
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Loader();
        }
        final mempoolInstance = snapshot.data!;

        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TxWidget(
              txURL: BlockChainExplorerUtils().formatTransactionUrl(
                mempoolInstance: mempoolInstance,
                txid: txID,
              ),
              txID: txID,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 36.0,
                width: 145.0,
                child: SubmitButton(
                    widget.swapInfo.refundTxIds.isEmpty
                        ? texts.get_refund_action_continue
                        : texts.get_refund_action_broadcasted,
                    widget.swapInfo.refundTxIds.isEmpty
                        ? () {
                            Navigator.of(context).push(
                              FadeInRoute(
                                builder: (_) => RefundPage(widget.swapInfo),
                              ),
                            );
                          }
                        : null,
                    enabled: widget.swapInfo.refundTxIds.isEmpty),
              ),
            ),
          ],
        );
      },
    );
  }
}

String? _extractRefundTxid(List<String> refundTxIds) =>
    refundTxIds.isEmpty ? null : refundTxIds[refundTxIds.length - 1];
