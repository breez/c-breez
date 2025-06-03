import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/buy_bitcoin/moonpay/moonpay_bloc.dart';
import 'package:c_breez/bloc/buy_bitcoin/moonpay/moonpay_state.dart';
import 'package:c_breez/utils/external_browser.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoonpaySwapInProgress extends StatelessWidget {
  final MoonPayStateSwapInProgress state;

  const MoonpaySwapInProgress({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(child: Container()),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Text(
            state.expired ? texts.moonpay_swap_expired : texts.moonpay_swap_in_progress(state.address),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(child: Container()),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
          child: SubmitButton(
            state.expired ? texts.moonpay_swap_expired_action : texts.moonpay_swap_in_progress_action,
            () {
              if (state.expired) {
                Navigator.of(context).pop();
              } else {
                context.read<MoonPayBloc>().makeExplorerUrl(state.address).then((url) {
                  if (context.mounted) {
                    launchLinkOnExternalBrowser(context, linkAddress: url);
                  }
                });
              }
            },
          ),
        ),
      ],
    );
  }
}
