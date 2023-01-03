import 'dart:async';

import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:share_extend/share_extend.dart';

class WaitBroadcastDialog extends StatefulWidget {
  final String _fromAddress;
  final String _toAddress;
  final int _feeRate;

  const WaitBroadcastDialog(
    this._fromAddress,
    this._toAddress,
    this._feeRate,
  );

  @override
  State<StatefulWidget> createState() {
    return _WaitBroadcastDialog();
  }
}

class _WaitBroadcastDialog extends State<WaitBroadcastDialog> {
  // TODO: Placeholder stream variables - Remove during integrating new API
  final _broadcastRefundRequestController =
      StreamController<dynamic>.broadcast();

  Sink<dynamic> get broadcastRefundRequestSink =>
      _broadcastRefundRequestController.sink;

  final _broadcastRefundResponseController =
      StreamController<dynamic>.broadcast();

  Stream<dynamic> get broadcastRefundResponseStream =>
      _broadcastRefundResponseController.stream;

  dynamic _response; //BroadcastRefundResponseModel _response;
  Object? _error;
  late StreamSubscription<dynamic>
      _broadcastSubscription; //StreamSubscription<BroadcastRefundResponseModel> _broadcastSubscription;

  // TODO: Remove _broadcastSubscription from initState and remove _error & _response variables
  @override
  void initState() {
    super.initState();
    _broadcastSubscription = broadcastRefundResponseStream.listen((response) {
      setState(() {
        _error = null;
        _response = response;
      });
    }, onError: (e) {
      setState(() {
        _error = e;
      });
    });

    var broadcastModel = BroadcastRefundRequestModel(
      widget._fromAddress,
      widget._toAddress,
      widget._feeRate,
    );
    broadcastRefundRequestSink.add(broadcastModel);
  }

  @override
  void dispose() {
    _broadcastSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Theme(
      data: themeData.copyWith(
        unselectedWidgetColor: themeData.canvasColor,
        colorScheme: ColorScheme.dark(
          secondary: themeData.canvasColor,
        ),
      ),
      child: AlertDialog(
        title: Text(
          _getTitleText(context),
          style: themeData.dialogTheme.titleTextStyle,
          textAlign: TextAlign.center,
        ),
        content: getContent(context),
        actions: _buildWaitBroadcastActions(),
      ),
    );
  }

  List<Widget> _buildWaitBroadcastActions() {
    final themeData = Theme.of(context);
    final texts = context.texts();

    return _response == null && _error == null
        ? []
        : [
            TextButton(
              onPressed: () => Navigator.of(context).pop(
                _error != null && _response?.txID?.isNotEmpty == true,
              ),
              child: Text(
                texts.waiting_broadcast_dialog_action_close,
                style: themeData.primaryTextTheme.button,
              ),
            ),
          ];
  }

  String _getTitleText(BuildContext context) {
    final texts = context.texts();
    if (_error != null) {
      return texts.waiting_broadcast_dialog_dialog_title_error;
    }
    return texts.waiting_broadcast_dialog_dialog_title;
  }

  Widget getContent(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    if (_error != null) {
      return Text(
        texts.waiting_broadcast_dialog_content_error(_error.toString()),
        style: themeData.dialogTheme.contentTextStyle,
        textAlign: TextAlign.center,
      );
    }
    if (_response == null) {
      return const WaitingBroadcastContent();
    }
    return BroadcastResultContent(response: _response);
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
  final dynamic _response;

  const BroadcastResultContent({
    Key? key,
    required response,
  })  : _response = response,
        super(key: key);

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
        _TransactionDetails(response: _response),
        _TransactionID(response: _response),
      ],
    );
  }
}

class _TransactionDetails extends StatelessWidget {
  final dynamic _response;

  const _TransactionDetails({
    Key? key,
    required response,
  })  : _response = response,
        super(key: key);

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
        _ShareAndCopyTxID(response: _response),
      ],
    );
  }
}

class _ShareAndCopyTxID extends StatelessWidget {
  final dynamic _response;

  const _ShareAndCopyTxID({
    Key? key,
    required response,
  })  : _response = response,
        super(key: key);

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
              onPressed: () =>
                  ServiceInjector().device.setClipboardText(_response.txID),
            ),
            IconButton(
              alignment: Alignment.topRight,
              padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0),
              tooltip: texts.waiting_broadcast_dialog_action_share,
              iconSize: 16.0,
              color: themeData.primaryTextTheme.button!.color!,
              icon: const Icon(Icons.share),
              onPressed: () => ShareExtend.share(
                _response.txID,
                "text",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionID extends StatelessWidget {
  final dynamic _response;

  const _TransactionID({
    Key? key,
    required response,
  })  : _response = response,
        super(key: key);

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
              _response.txID,
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

class BroadcastRefundRequestModel {
  final String fromAddress;
  final String toAddress;
  final int feeRate;

  const BroadcastRefundRequestModel(
    this.fromAddress,
    this.toAddress,
    this.feeRate,
  );
}

class BroadcastRefundResponseModel {
  final BroadcastRefundRequestModel request;
  final String txID;

  const BroadcastRefundResponseModel(
    this.request,
    this.txID,
  );
}
