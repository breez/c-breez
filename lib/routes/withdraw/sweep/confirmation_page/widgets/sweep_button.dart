import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/sweep/sweep_bloc.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:c_breez/widgets/error_dialog.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SweepButton extends StatelessWidget {
  final String toAddress;
  final int feeRateSatsPerVbyte;

  const SweepButton({
    super.key,
    required this.toAddress,
    required this.feeRateSatsPerVbyte,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return SingleButtonBottomBar(
      text: texts.sweep_all_coins_action_confirm,
      onPressed: () => _sweep(context),
    );
  }

  Future _sweep(BuildContext context) async {
    final texts = context.texts();
    final sweepBloc = context.read<SweepBloc>();

    final navigator = Navigator.of(context);
    var loaderRoute = createLoaderRoute(context);
    navigator.push(loaderRoute);
    try {
      await sweepBloc.sweep(
        toAddress: toAddress,
        feeRateSatsPerVbyte: feeRateSatsPerVbyte,
      );
      navigator.popUntil((route) => route.settings.name == "/");
    } catch (e) {
      // ignore: use_build_context_synchronously
      final themeData = Theme.of(context);
      navigator.pop(loaderRoute);
      // ignore: use_build_context_synchronously
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
