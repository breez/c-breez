import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/reverse_swap/reverse_swap_bloc.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:c_breez/widgets/error_dialog.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReverseSwapButton extends StatelessWidget {
  final int amountSat;
  final String onchainRecipientAddress;
  final String feesHash;
  final int satPerVbyte;

  const ReverseSwapButton({
    Key? key,
    required this.amountSat,
    required this.onchainRecipientAddress,
    required this.feesHash,
    required this.satPerVbyte,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return SingleButtonBottomBar(
      text: texts.sweep_all_coins_action_confirm,
      onPressed: () => _sendOnchain(context),
    );
  }

  Future _sendOnchain(BuildContext context) async {
    final texts = context.texts();
    final reverseSwapBloc = context.read<ReverseSwapBloc>();

    final navigator = Navigator.of(context);
    var loaderRoute = createLoaderRoute(context);
    navigator.push(loaderRoute);
    try {
      await reverseSwapBloc.sendOnchain(
        amountSat: amountSat,
        pairHash: feesHash,
        onchainRecipientAddress: onchainRecipientAddress,
        satPerVbyte: satPerVbyte,
      );

      navigator.pushReplacementNamed("/");
    } catch (e) {
      final themeData = Theme.of(context);
      navigator.pop(loaderRoute);
      promptError(
        context,
        null,
        Text(
          extractExceptionMessage(e, texts),
          style: themeData.dialogTheme.contentTextStyle,
        ),
      );
    }
  }
}
