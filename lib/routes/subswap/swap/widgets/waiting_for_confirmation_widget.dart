import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/link_launcher.dart';
import 'package:flutter/material.dart';

class UnconfirmedTxWidget extends StatefulWidget {
  final String unconfirmedTxID;

  const UnconfirmedTxWidget({Key? key, required this.unconfirmedTxID})
      : super(key: key);

  @override
  State<UnconfirmedTxWidget> createState() => _UnconfirmedTxWidgetState();
}

class _UnconfirmedTxWidgetState extends State<UnconfirmedTxWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 30.0,
            left: 30.0,
            right: 30.0,
          ),
          child: LinkLauncher(
            linkName: widget.unconfirmedTxID,
            linkAddress:
                "https://blockstream.info/tx/${widget.unconfirmedTxID}",
            onCopy: () {
              final texts = context.texts();
              ServiceInjector().device.setClipboardText(widget.unconfirmedTxID);
              showFlushbar(
                context,
                message: texts.add_funds_transaction_id_copied,
                duration: const Duration(seconds: 3),
              );
            },
          ),
        ),
      ],
    );
  }
}
