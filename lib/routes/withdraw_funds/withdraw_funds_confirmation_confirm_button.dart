import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/bloc/withdraw/withdraw_funds_bloc.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/widgets/error_dialog.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WithdrawFundsConfirmationConfirmButton extends StatelessWidget {
  final String address;
  final FeeratePreset speed;

  const WithdrawFundsConfirmationConfirmButton(
    this.address,
    this.speed, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: SubmitButton(
        texts.sweep_all_coins_action_confirm,
        () async {
          final navigator = Navigator.of(context);
          navigator.push(createLoaderRoute(context));
          context.read<WithdrawFundsBloc>().sweepAllCoins(address, speed).then(
                (_) => _sweepCoinsFinished(context),
                onError: (e) => _sweepCoinsError(context, e),
              );
        },
      ),
    );
  }

  void _sweepCoinsFinished(BuildContext context) {
    final navigator = Navigator.of(context);
    navigator.popUntil((route) => route.settings.name == "/");
  }

  void _sweepCoinsError(BuildContext context, dynamic e) {
    final navigator = Navigator.of(context);
    final themeData = Theme.of(context);
    navigator.pop();
    promptError(
      context,
      null,
      Text(
        e.toString(),
        style: themeData.dialogTheme.contentTextStyle,
      ),
    );
  }
}
