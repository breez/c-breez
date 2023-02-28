import 'package:breez_sdk/bridge_generated.dart' as sdk;
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/routes/lnurl/withdraw/withdraw_response.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/exceptions.dart';
import 'package:c_breez/widgets/loading_animated_text.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _log = FimberLog("LNURLWithdrawDialog");

class LNURLWithdrawDialog extends StatefulWidget {
  final Function(LNURLWithdrawPageResult? result) onFinish;
  final sdk.LnUrlWithdrawRequestData requestData;
  final int amountSats;

  const LNURLWithdrawDialog({
    super.key,
    required this.requestData,
    required this.amountSats,
    required this.onFinish,
  });

  @override
  State<LNURLWithdrawDialog> createState() => _LNURLWithdrawDialogState();
}

class _LNURLWithdrawDialogState extends State<LNURLWithdrawDialog> with SingleTickerProviderStateMixin {
  late Animation<double> _opacityAnimation;
  Future<LNURLWithdrawPageResult>? _future;
  var finishCalled = false;

  @override
  void initState() {
    super.initState();
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.ease,
    ));
    controller.value = 1.0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _future = _withdraw(context).then((result) {
          if (result.error == null && mounted) {
            controller.addStatusListener((status) {
              _log.v("Animation status $status");
              if (status == AnimationStatus.dismissed && mounted) {
                finishCalled = true;
                widget.onFinish(result);
              }
            });
            controller.reverse();
          }
          return result;
        });
      });
    });
  }

  @override
  void dispose() {
    if (!finishCalled) {
      _onFinish(null);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return FadeTransition(
      opacity: _opacityAnimation,
      child: AlertDialog(
        title: Text(
          texts.lnurl_withdraw_dialog_title,
          style: themeData.dialogTheme.titleTextStyle,
          textAlign: TextAlign.center,
        ),
        content: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            final data = snapshot.data;
            final error = snapshot.error ?? data?.error;
            _log.v("Building with data $data, error $error");

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                error != null
                    ? Text(
                        texts.lnurl_withdraw_dialog_error(extractExceptionMessage(error, texts)),
                        style: themeData.dialogTheme.contentTextStyle,
                        textAlign: TextAlign.center,
                      )
                    : LoadingAnimatedText(
                        texts.lnurl_withdraw_dialog_wait,
                        textStyle: themeData.dialogTheme.contentTextStyle,
                        textAlign: TextAlign.center,
                      ),
                error != null
                    ? const SizedBox(height: 16.0)
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: Image.asset(
                          themeData.customData.loaderAssetPath,
                          gaplessPlayback: true,
                        ),
                      ),
                TextButton(
                  onPressed: () => _onFinish(null),
                  child: Text(
                    texts.lnurl_withdraw_dialog_action_close,
                    style: themeData.primaryTextTheme.labelLarge,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Future<LNURLWithdrawPageResult> _withdraw(BuildContext context) async {
    _log.v("Withdraw ${widget.amountSats} sats");
    final texts = context.texts();
    final accountBloc = context.read<AccountBloc>();
    final description = widget.requestData.defaultDescription;

    try {
      _log.v("LNURL withdraw of ${widget.amountSats} sats where "
          "min is ${widget.requestData.minWithdrawable} msats "
          "and max is ${widget.requestData.maxWithdrawable} msats.");
      final resp = await accountBloc.lnurlWithdraw(
        reqData: widget.requestData,
        amountSats: widget.amountSats,
        description: description,
      );
      if (resp is sdk.LnUrlWithdrawCallbackStatus_Ok) {
        _log.v("LNURL withdraw success");
        return LNURLWithdrawPageResult();
      } else if (resp is sdk.LnUrlWithdrawCallbackStatus_ErrorStatus) {
        _log.v("LNURL withdraw failed: ${resp.data.reason}");
        return LNURLWithdrawPageResult(
          error: resp.data.reason,
        );
      } else {
        _log.w("Unknown response from lnurlWithdraw: $resp");
        return LNURLWithdrawPageResult(
          error: texts.lnurl_payment_page_unknown_error,
        );
      }
    } catch (e) {
      _log.w("Error withdrawing LNURL payment", ex: e);
      return LNURLWithdrawPageResult(error: e);
    }
  }

  void _onFinish(LNURLWithdrawPageResult? result) {
    if (finishCalled) {
      return;
    }
    finishCalled = true;
    _log.v("Finishing with result $result");
    widget.onFinish(result);
  }
}
