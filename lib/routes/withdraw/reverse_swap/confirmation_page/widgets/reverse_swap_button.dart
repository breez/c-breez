import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/reverse_swap/reverse_swap_bloc.dart';
import 'package:c_breez/utils/utils.dart';
import 'package:c_breez/widgets/error_dialog.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReverseSwapButton extends StatelessWidget {
  final String recipientAddress;
  final PrepareOnchainPaymentResponse prepareOnchainPaymentResponse;

  const ReverseSwapButton({
    super.key,
    required this.recipientAddress,
    required this.prepareOnchainPaymentResponse,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return SingleButtonBottomBar(
      text: texts.sweep_all_coins_action_confirm,
      onPressed: () => _payOnchain(context),
    );
  }

  Future _payOnchain(BuildContext context) async {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final reverseSwapBloc = context.read<ReverseSwapBloc>();

    final navigator = Navigator.of(context);
    var loaderRoute = createLoaderRoute(context);
    navigator.push(loaderRoute);
    try {
      await reverseSwapBloc.payOnchain(
        recipientAddress: recipientAddress,
        prepareRes: prepareOnchainPaymentResponse,
      );
      navigator.pushNamedAndRemoveUntil("/", (Route<dynamic> route) => false);
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
