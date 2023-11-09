import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/refund/refund_bloc.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/theme/theme_provider.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

class WaitBroadcastDialog extends StatelessWidget {
  final RefundRequest req;
  final int? feeSat; // TODO: Display the fees on WaitBroadcastDialog

  const WaitBroadcastDialog({
    required this.req,
    this.feeSat,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final refundBloc = context.read<RefundBloc>();
    final texts = context.texts();

    return Theme(
      data: themeData.copyWith(
        unselectedWidgetColor: themeData.canvasColor,
        colorScheme: ColorScheme.dark(
          secondary: themeData.canvasColor,
        ),
      ),
      child: FutureBuilder(
        future: refundBloc.refund(req: req),
        builder: (context, snapshot) {
          final txId = snapshot.data;
          final error = snapshot.error;
          return AlertDialog(
            title: Text(
              (error != null)
                  ? texts.waiting_broadcast_dialog_dialog_title_error
                  : texts.waiting_broadcast_dialog_dialog_title,
              style: themeData.dialogTheme.titleTextStyle,
              textAlign: TextAlign.center,
            ),
            content: (error != null)
                ? Text(
                    texts.waiting_broadcast_dialog_content_error(
                      extractExceptionMessage(error, texts),
                    ),
                    style: themeData.dialogTheme.contentTextStyle,
                    textAlign: TextAlign.center,
                  )
                : (txId == null)
                    ? const WaitingBroadcastContent()
                    : BroadcastResultContent(txId: txId),
            actions: error == null && txId == null
                ? []
                : [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(txId),
                      child: Text(
                        texts.waiting_broadcast_dialog_action_close,
                        style: themeData.primaryTextTheme.labelLarge,
                      ),
                    ),
                  ],
          );
        },
      ),
    );
  }
}

class WaitingBroadcastContent extends StatelessWidget {
  const WaitingBroadcastContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          texts.waiting_broadcast_dialog_content_warning,
          style: themeData.dialogTheme.contentTextStyle,
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Image.asset(
            Theme.of(context).customData.loaderAssetPath,
            gaplessPlayback: true,
          ),
        ),
      ],
    );
  }
}

class BroadcastResultContent extends StatelessWidget {
  final String txId;

  const BroadcastResultContent({
    super.key,
    required this.txId,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  texts.waiting_broadcast_dialog_content_success,
                  style: themeData.dialogTheme.contentTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        _TransactionDetails(txId: txId),
        _TransactionID(txId: txId),
      ],
    );
  }
}

class _TransactionDetails extends StatelessWidget {
  final String txId;

  const _TransactionDetails({
    required this.txId,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            texts.waiting_broadcast_dialog_transaction_id,
            style: themeData.primaryTextTheme.headlineMedium,
          ),
        ),
        _ShareAndCopyTxID(txId: txId),
      ],
    );
  }
}

class _ShareAndCopyTxID extends StatelessWidget {
  final String txId;

  const _ShareAndCopyTxID({
    required this.txId,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return Expanded(
      child: SizedBox(
        height: 36.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              alignment: Alignment.topRight,
              padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0),
              tooltip: texts.waiting_broadcast_dialog_action_copy,
              iconSize: 16.0,
              color: themeData.primaryTextTheme.labelLarge!.color!,
              icon: const Icon(
                IconData(
                  0xe90b,
                  fontFamily: "icomoon",
                ),
              ),
              onPressed: () {
                ServiceInjector().device.setClipboardText(txId);
                showFlushbar(context, message: texts.get_refund_transaction_id_copied);
              },
            ),
            IconButton(
              alignment: Alignment.topRight,
              padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0),
              tooltip: texts.waiting_broadcast_dialog_action_share,
              iconSize: 16.0,
              color: themeData.primaryTextTheme.labelLarge!.color!,
              icon: const Icon(Icons.share),
              onPressed: () => Share.share(txId),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionID extends StatelessWidget {
  final String txId;

  const _TransactionID({
    required this.txId,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 0.0, right: 0.0),
            child: Text(
              txId,
              textAlign: TextAlign.left,
              overflow: TextOverflow.clip,
              maxLines: 4,
              style: themeData.primaryTextTheme.displaySmall!.copyWith(
                fontSize: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
