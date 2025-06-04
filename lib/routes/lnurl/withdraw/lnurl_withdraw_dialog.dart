import 'package:breez_sdk/bridge_generated.dart' as sdk;
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/routes/lnurl/widgets/lnurl_page_result.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/utils.dart';
import 'package:c_breez/widgets/loading_animated_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger("LNURLWithdrawDialog");

class LNURLWithdrawDialog extends StatefulWidget {
  final Function(LNURLPageResult? result) onFinish;
  final sdk.LnUrlWithdrawRequestData requestData;
  final int amountSat;

  const LNURLWithdrawDialog({
    super.key,
    required this.requestData,
    required this.amountSat,
    required this.onFinish,
  });

  @override
  State<LNURLWithdrawDialog> createState() => _LNURLWithdrawDialogState();
}

class _LNURLWithdrawDialogState extends State<LNURLWithdrawDialog> with SingleTickerProviderStateMixin {
  late Animation<double> _opacityAnimation;
  Future<LNURLPageResult>? _future;
  var finishCalled = false;

  @override
  void initState() {
    super.initState();
    final controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.ease));
    controller.value = 1.0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _future = _withdraw(context).then((result) {
          if (result.error == null && mounted) {
            controller.addStatusListener((status) {
              _log.info("Animation status $status");
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
            _log.info("Building with data $data, error $error");

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                error != null
                    ? Text(
                        texts.lnurl_withdraw_dialog_error(ExceptionHandler.extractMessage(error, texts)),
                        style: themeData.dialogTheme.contentTextStyle,
                        textAlign: TextAlign.center,
                      )
                    : LoadingAnimatedText(
                        loadingMessage: texts.lnurl_withdraw_dialog_wait,
                        textStyle: themeData.dialogTheme.contentTextStyle,
                        textAlign: TextAlign.center,
                      ),
                error != null
                    ? const SizedBox(height: 16.0)
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: Image.asset(themeData.customData.loaderAssetPath, gaplessPlayback: true),
                      ),
                TextButton(
                  onPressed: () => _onFinish(null),
                  child: Text(
                    texts.lnurl_withdraw_dialog_action_close,
                    style: themeData.primaryTextTheme.labelLarge,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<LNURLPageResult> _withdraw(BuildContext context) async {
    _log.info("Withdraw ${widget.amountSat} sats");
    final texts = context.texts();
    final accountBloc = context.read<AccountBloc>();
    final description = widget.requestData.defaultDescription;

    try {
      _log.info(
        "LNURL withdraw of ${widget.amountSat} sats where "
        "min is ${widget.requestData.minWithdrawable} msats "
        "and max is ${widget.requestData.maxWithdrawable} msats.",
      );
      final req = sdk.LnUrlWithdrawRequest(
        amountMsat: widget.amountSat * 1000,
        data: widget.requestData,
        description: description,
      );
      final resp = await accountBloc.lnurlWithdraw(req: req);
      if (resp is sdk.LnUrlWithdrawResult_Ok) {
        final paymentHash = resp.data.invoice.paymentHash;
        _log.info("LNURL withdraw success for $paymentHash");
        return const LNURLPageResult(protocol: LnUrlProtocol.Withdraw);
      } else if (resp is sdk.LnUrlWithdrawResult_ErrorStatus) {
        final reason = resp.data.reason;
        _log.info("LNURL withdraw failed: $reason");
        return LNURLPageResult(protocol: LnUrlProtocol.Withdraw, error: reason);
      } else {
        _log.warning("Unknown response from lnurlWithdraw: $resp");
        return LNURLPageResult(
          protocol: LnUrlProtocol.Withdraw,
          error: texts.lnurl_payment_page_unknown_error,
        );
      }
    } catch (e) {
      _log.warning("Error withdrawing LNURL payment", e);
      return LNURLPageResult(protocol: LnUrlProtocol.Withdraw, error: e);
    }
  }

  void _onFinish(LNURLPageResult? result) {
    if (finishCalled) {
      return;
    }
    finishCalled = true;
    _log.info("Finishing with result $result");
    widget.onFinish(result);
  }
}
