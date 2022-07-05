import 'package:c_breez/bloc/withdraw/withdraw_funds_bloc.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/widgets/error_dialog.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WithdrawFundsConfirmationConfirmButton extends StatelessWidget {
  const WithdrawFundsConfirmationConfirmButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: SubmitButton(
        texts.sweep_all_coins_action_confirm,
        () async {
          final navigator = Navigator.of(context);
          navigator.push(createLoaderRoute(context));
          context.read<WithdrawFudsBloc>().withdraw().then(
            (_) => navigator.popUntil((route) => route.settings.name == "/"),
            onError: (e) {
              navigator.pop();
              promptError(
                context,
                null,
                Text(
                  e.toString(),
                  style: themeData.dialogTheme.contentTextStyle,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
