import 'dart:async';

import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/bloc/input/input_bloc.dart';
import 'package:c_breez/bloc/input/input_state.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/warning_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_extend/share_extend.dart';

import 'widgets/compact_qr_image.dart';

class QrCodeDialog extends StatefulWidget {
  final LNInvoice? _invoice;
  final Object? error;
  final Function(dynamic result) _onFinish;

  const QrCodeDialog(this._invoice, this.error, this._onFinish);

  @override
  State<StatefulWidget> createState() {
    return QrCodeDialogState();
  }
}

class QrCodeDialogState extends State<QrCodeDialog> with SingleTickerProviderStateMixin {
  Animation<double>? _opacityAnimation;
  ModalRoute? _currentRoute;
  AnimationController? _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller!, curve: Curves.ease));
    _controller!.value = 1.0;
    _controller!.addStatusListener((status) async {
      if (status == AnimationStatus.dismissed && mounted) {
        onFinish(true);
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentRoute ??= ModalRoute.of(context);
  }

  @override
  void didUpdateWidget(covariant QrCodeDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._invoice != oldWidget._invoice) {
      context.read<InputBloc>().trackPayment(widget._invoice!.paymentHash).then((value) {
        Timer(const Duration(milliseconds: 1000), () {
          if (mounted) {
            _controller!.reverse();
          }
        });
      }).catchError((e) {
        showFlushbar(context, message: e.toString());
        onFinish(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildQrCodeDialog();
  }

  Widget _buildQrCodeDialog() {
    final texts = context.texts();

    return BlocBuilder<CurrencyBloc, CurrencyState>(builder: (context, currencyState) {
      return BlocBuilder<InputBloc, InputState>(builder: (context, inputState) {
        return FadeTransition(
          opacity: _opacityAnimation!,
          child: SimpleDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(texts.qr_code_dialog_invoice),
                Row(
                  children: <Widget>[
                    Tooltip(
                      message: texts.qr_code_dialog_share,
                      child: IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 2.0, left: 14.0),
                        icon: const Icon(IconData(0xe917, fontFamily: 'icomoon')),
                        color: Theme.of(context).primaryTextTheme.button!.color!,
                        onPressed: () {
                          ShareExtend.share("lightning:${widget._invoice!.bolt11}", "text");
                        },
                      ),
                    ),
                    Tooltip(
                      message: texts.qr_code_dialog_copy,
                      child: IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 14.0, left: 2.0),
                        icon: const Icon(IconData(0xe90b, fontFamily: 'icomoon')),
                        color: Theme.of(context).primaryTextTheme.button!.color!,
                        onPressed: () {
                          ServiceInjector().device.setClipboardText(widget._invoice!.bolt11);
                          showFlushbar(
                            context,
                            message: texts.qr_code_dialog_copied,
                            duration: const Duration(seconds: 3),
                          );
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
            titlePadding: const EdgeInsets.fromLTRB(20.0, 22.0, 0.0, 8.0),
            contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0, bottom: 20.0),
            children: <Widget>[
              AnimatedCrossFade(
                firstChild: buildLoadingOrError(),
                secondChild: widget._invoice == null
                    ? const SizedBox()
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: SizedBox(
                                width: 230.0,
                                height: 230.0,
                                child: CompactQRImage(
                                  data: widget._invoice!.bolt11,
                                ),
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 16.0)),
                          SizedBox(width: MediaQuery.of(context).size.width, child: _buildExpiryAndFeeMessage(currencyState)),
                          const Padding(padding: EdgeInsets.only(top: 16.0)),
                        ],
                      ),
                duration: const Duration(seconds: 1),
                crossFadeState: widget._invoice == null ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              ),
              _buildCloseButton()
            ],
          ),
        );
      });
    });
  }

  Widget buildLoadingOrError() {
    final themeData = Theme.of(context);
    if (widget.error == null) {
      return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 310.0,
          child: Align(
              alignment: const Alignment(0, -0.33),
              child: SizedBox(
                height: 80.0,
                width: 80.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    themeData.primaryTextTheme.button!.color!,
                  ),
                  backgroundColor: themeData.backgroundColor,
                ),
              )));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        displayErrorMessage,
        style: themeData.primaryTextTheme.headline3!.copyWith(fontSize: 16),
      ),
    );
  }

  String get displayErrorMessage {
    final texts = context.texts();
    const osErrorRegex = r'((?<=\(OS Error\: )(.*?)(?=\,))';
    const rpcErrorRegex = r'((?<=message\: \")(.*?)(?=\"))';
    const defaultErrorRegex = r'((?<=message\: )(.*?)(?=\:))';
    final grouped = RegExp('($osErrorRegex|$rpcErrorRegex|$defaultErrorRegex)');

    String? displayMessage = widget.error?.toString();
    if (displayMessage != null) {
      displayMessage = grouped.hasMatch(displayMessage)
          ? grouped.allMatches(displayMessage).last[0]
          : null;
    }
    return displayMessage ??= texts.qr_code_dialog_warning_message_error;
  }

  Widget _buildExpiryAndFeeMessage(CurrencyState currencyState) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    return WarningBox(
      boxPadding: const EdgeInsets.symmetric(horizontal: 20),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      backgroundColor: themeData.isLightTheme ? const Color(0xFFf3f8fc) : null,
      borderColor: themeData.isLightTheme ? const Color(0xFF0085fb) : null,
      child: Text(
        texts.qr_code_dialog_warning_message,
        textAlign: TextAlign.center,
        style: Theme.of(context).primaryTextTheme.caption,
      ),
    );
  }

  Widget _buildCloseButton() {
    final texts = context.texts();
    return TextButton(
      onPressed: (() {
        onFinish(false);
      }),
      child: Text(
        texts.qr_code_dialog_action_close,
        style: Theme.of(context).primaryTextTheme.button,
      ),
    );
  }

  onFinish(dynamic result) {
    if (mounted && _currentRoute != null && _currentRoute!.isCurrent) {
      Navigator.removeRoute(context, _currentRoute!);
    }
    widget._onFinish(result);
  }
}
