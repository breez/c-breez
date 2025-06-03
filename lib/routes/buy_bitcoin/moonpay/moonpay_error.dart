import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/buy_bitcoin/moonpay/moonpay_bloc.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoonpayError extends StatelessWidget {
  final String error;

  const MoonpayError({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(child: Container()),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Text(error, textAlign: TextAlign.center),
        ),
        Expanded(child: Container()),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
          child: SubmitButton(
            context.texts().moonpay_retry_button,
            () => context.read<MoonPayBloc>().fetchMoonpayUrl(),
          ),
        ),
      ],
    );
  }
}
