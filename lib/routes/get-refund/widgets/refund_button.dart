import 'package:breez_sdk/sdk.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/refund/refund_bloc.dart';
import 'package:c_breez/utils/utils.dart';
import 'package:c_breez/widgets/error_dialog.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RefundButton extends StatelessWidget {
  final RefundRequest req;

  const RefundButton({super.key, required this.req});

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return SingleButtonBottomBar(
      text: texts.sweep_all_coins_action_confirm,
      onPressed: () => _refund(context),
    );
  }

  Future _refund(BuildContext context) async {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final refundBloc = context.read<RefundBloc>();

    final navigator = Navigator.of(context);
    var loaderRoute = createLoaderRoute(context);
    navigator.push(loaderRoute);
    try {
      await refundBloc.refund(req: req);
      navigator.popUntil((route) => route.settings.name == "/");
    } catch (e) {
      navigator.pop(loaderRoute);
      if (!context.mounted) return;
      promptError(
        context,
        null,
        Text(ExceptionHandler.extractMessage(e, texts), style: themeData.dialogTheme.contentTextStyle),
      );
    }
  }
}
