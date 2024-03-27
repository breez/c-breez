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

class ReverseSwapInProgress extends StatelessWidget {
  final String lockupTxid;

  const ReverseSwapInProgress({required this.lockupTxid});

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

        final transactionUrl = BlockChainExplorerUtils().formatTransactionUrl(
          mempoolInstance: snapshot.data!,
          txid: lockupTxid,
        );

        return LinkLauncher(
          linkName: lockupTxid,
          linkAddress: transactionUrl,
          onCopy: () {
            ServiceInjector().device.setClipboardText(lockupTxid);
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
