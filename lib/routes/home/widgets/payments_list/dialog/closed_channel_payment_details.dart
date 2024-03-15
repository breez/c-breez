import 'package:breez_sdk/sdk.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/network/network_settings_bloc.dart';
import 'package:c_breez/models/payment_minutiae.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/tx_widget.dart';
import 'package:c_breez/utils/blockchain_explorer_utils.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClosedChannelPaymentDetailsWidget extends StatelessWidget {
  final PaymentMinutiae paymentMinutiae;

  const ClosedChannelPaymentDetailsWidget({
    super.key,
    required this.paymentMinutiae,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();
    final networkSettingsBloc = context.read<NetworkSettingsBloc>();

    return FutureBuilder<String>(
      future: networkSettingsBloc.mempoolInstance,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Loader();
        }

        final mempoolInstance = snapshot.data!;
        if (paymentMinutiae.status == PaymentStatus.Complete) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: TextSpan(
                  style: themeData.dialogTheme.contentTextStyle,
                  text: texts.payment_details_dialog_closed_channel_local_wallet,
                ),
              ),
              if (paymentMinutiae.paymentType == PaymentType.ClosedChannel &&
                  paymentMinutiae.closingTxid != null) ...[
                TxWidget(
                  txURL: BlockChainExplorerUtils().formatTransactionUrl(
                      txid: paymentMinutiae.closingTxid!, mempoolInstance: mempoolInstance),
                  txID: paymentMinutiae.closingTxid!,
                ),
              ],
            ],
          );
        }
        // TODO pendingExpirationHeight
        // TODO hoursToExpire
        String estimation = texts.payment_details_dialog_closed_channel_transfer_no_estimation;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              text: TextSpan(
                style: themeData.dialogTheme.contentTextStyle,
                text: estimation,
              ),
            ),
            if (paymentMinutiae.fundingTxid != null) ...[
              TxWidget(
                txURL: BlockChainExplorerUtils().formatTransactionUrl(
                    txid: paymentMinutiae.fundingTxid!, mempoolInstance: mempoolInstance),
                txID: paymentMinutiae.fundingTxid!,
              ),
            ],
            if (paymentMinutiae.closingTxid != null) ...[
              TxWidget(
                txURL: BlockChainExplorerUtils().formatTransactionUrl(
                    txid: paymentMinutiae.closingTxid!, mempoolInstance: mempoolInstance),
                txID: paymentMinutiae.closingTxid!,
              ),
            ]
          ],
        );
      },
    );
  }
}
