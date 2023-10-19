import 'package:breez_sdk/bridge_generated.dart' as sdk;
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/network/network_settings_bloc.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/utils/blockchain_explorer_utils.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/link_launcher.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReverseSwapInprogress extends StatelessWidget {
  final sdk.ReverseSwapInfo reverseSwap;

  const ReverseSwapInprogress({
    required this.reverseSwap,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final lockTxID = context.watch<sdk.ReverseSwapInfo>().lockupTxid;

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ContentWrapper(
          content: Text(texts.swap_in_progress_message_waiting_confirmation, textAlign: TextAlign.center),
          top: 50.0,
        ),
        if (lockTxID != null) ...[
          _ContentWrapper(
            content: _TxLink(txid: lockTxID),
          ),
        ]
      ],
    );
  }
}

class _TxLink extends StatelessWidget {
  final String txid;

  const _TxLink({required this.txid});

  @override
  Widget build(BuildContext context) {
    final text = context.texts();
    final networkSettingsBloc = context.read<NetworkSettingsBloc>();

    return FutureBuilder(
      future: networkSettingsBloc.mempoolInstance,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Loader();
        }

        final transactionUrl =
            BlockChainExplorerUtils().formatTransactionUrl(mempoolInstance: snapshot.data!, txid: txid);

        return LinkLauncher(
          linkName: txid,
          linkAddress: transactionUrl,
          onCopy: () {
            ServiceInjector().device.setClipboardText(txid);
            showFlushbar(
              context,
              message: text.add_funds_transaction_id_copied,
              duration: const Duration(seconds: 3),
            );
          },
        );
      },
    );
  }
}

class _ContentWrapper extends StatelessWidget {
  final Widget content;
  final double top;

  const _ContentWrapper({required this.content, this.top = 30.0});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: top,
        left: 30.0,
        right: 30.0,
      ),
      child: content,
    );
  }
}
