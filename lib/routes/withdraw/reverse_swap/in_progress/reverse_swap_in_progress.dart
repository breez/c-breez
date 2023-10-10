import 'package:breez_sdk/bridge_generated.dart' as sdk;
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/config.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/link_launcher.dart';
import 'package:flutter/material.dart';

class ReverseSwapInprogress extends StatelessWidget {
  final sdk.ReverseSwapInfo reverseSwap;

  const ReverseSwapInprogress({
    required this.reverseSwap,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ContentWrapper(
          content: Text(texts.swap_in_progress_message_waiting_confirmation, textAlign: TextAlign.center),
          top: 50.0,
        ),
        // TODO add _TxLink when claimtxid is avaliable.
      ],
    );
  }
}

class _TxLink extends StatelessWidget {
  final String? txid;

  _TxLink({required this.txid});

  late Future<Config> _config;
  initState() async {
    _config = Config.instance();
  }

  @override
  Widget build(BuildContext context) {
    final text = context.texts();

    return FutureBuilder(
      future: _config,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && !snapshot.hasError) {
          final blockExplorer = snapshot.data!.defaultMempoolUrl;

          if (txid != null) {
            return LinkLauncher(
              linkName: txid,
              linkAddress: "$blockExplorer/tx/$txid",
              onCopy: () {
                ServiceInjector().device.setClipboardText(txid!);
                showFlushbar(
                  context,
                  message: text.add_funds_transaction_id_copied,
                  duration: const Duration(seconds: 3),
                );
              },
            );
          }
        }
        return Container();
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
