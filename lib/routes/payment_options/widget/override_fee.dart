import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/payment_options/payment_options_bloc.dart';
import 'package:c_breez/bloc/payment_options/payment_options_state.dart';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _log = Logger("OverrideFee");

class OverrideFee extends StatelessWidget {
  const OverrideFee({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return BlocBuilder<PaymentOptionsBloc, PaymentOptionsState>(
      builder: (context, state) {
        return CheckboxListTile(
          activeColor: Colors.white,
          checkColor: themeData.canvasColor,
          controlAffinity: ListTileControlAffinity.leading,
          value: state.overrideFeeEnabled,
          onChanged: (value) {
            _log.info("onChanged: $value");
            if (value != null) {
              context.read<PaymentOptionsBloc>().setOverrideFeeEnabled(value);
            }
          },
          title: Text(
            texts.payment_options_fee_override_enable,
            style: themeData.primaryTextTheme.displaySmall?.copyWith(
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
