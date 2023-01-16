import 'package:c_breez/bloc/refund/refund_bloc.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/theme/theme_provider.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

class WaitBroadcastDialog extends StatelessWidget {
  final String _fromAddress;
  final String _toAddress;
  final int _feeRate;

  const WaitBroadcastDialog(
    this._fromAddress,
    this._toAddress,
    this._feeRate,
  );

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final refundBloc = context.read<RefundBloc>();

    return Theme(
      data: themeData.copyWith(
        unselectedWidgetColor: themeData.canvasColor,
        colorScheme: ColorScheme.dark(
          secondary: themeData.canvasColor,
        ),
      ),
      child: FutureBuilder(
        future: refundBloc.refund(
          swapAddress: _fromAddress,
          toAddress: _toAddress,
          satPerVbyte: _feeRate,
        ),
        builder: (context, snapshot) {
          final txId = snapshot.data;
          final error = snapshot.error;
          return AlertDialog(
            title: Text(
              _getTitleText(context, error: error),
              style: themeData.dialogTheme.titleTextStyle,
              textAlign: TextAlign.center,
            ),
            content: getContent(
              context,
              txId: txId,
              error: error,
            ),
            actions: _buildWaitBroadcastActions(
              context,
              txId: txId,
              error: error,
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildWaitBroadcastActions(
    BuildContext context, {
    String? txId,
    Object? error,
  }) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    return txId == null && error == null
        ? []
        : [
            TextButton(
              onPressed: () => Navigator.of(context).pop(txId),
              child: Text(
                texts.waiting_broadcast_dialog_action_close,
                style: themeData.primaryTextTheme.button,
              ),
            ),
          ];
  }

  String _getTitleText(
    BuildContext context, {
    Object? error,
  }) {
    final texts = context.texts();
    if (error != null) {
      return texts.waiting_broadcast_dialog_dialog_title_error;
    }
    return texts.waiting_broadcast_dialog_dialog_title;
  }

  Widget getContent(
    BuildContext context, {
    String? txId,
    Object? error,
  }) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    if (error != null) {
      return Text(
        texts.waiting_broadcast_dialog_content_error(
          extractExceptionMessage(error),
        ),
        style: themeData.dialogTheme.contentTextStyle,
        textAlign: TextAlign.center,
      );
    }
    if (txId == null) {
      return const WaitingBroadcastContent();
    }
    return BroadcastResultContent(txId: txId);
  }
}

class WaitingBroadcastContent extends StatelessWidget {
  const WaitingBroadcastContent({
    Key? key,
  }) : super(key: key);

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
    Key? key,
    required this.txId,
  }) : super(key: key);

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
    Key? key,
    required this.txId,
  }) : super(key: key);

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
            style: themeData.primaryTextTheme.headline4,
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
    Key? key,
    required this.txId,
  }) : super(key: key);

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
              color: themeData.primaryTextTheme.button!.color!,
              icon: const Icon(
                IconData(
                  0xe90b,
                  fontFamily: "icomoon",
                ),
              ),
              onPressed: () => ServiceInjector().device.setClipboardText(txId),
            ),
            IconButton(
              alignment: Alignment.topRight,
              padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0),
              tooltip: texts.waiting_broadcast_dialog_action_share,
              iconSize: 16.0,
              color: themeData.primaryTextTheme.button!.color!,
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
    Key? key,
    required this.txId,
  }) : super(key: key);

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
              style: themeData.primaryTextTheme.headline3!.copyWith(
                fontSize: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
