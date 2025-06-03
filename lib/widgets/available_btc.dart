import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AvailableBTC extends StatelessWidget {
  final int confirmedSats;

  const AvailableBTC(this.confirmedSats);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final currencyState = context.read<CurrencyBloc>().state;
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Text(
            texts.get_refund_amount(currencyState.bitcoinCurrency.format(confirmedSats)),
            style: theme.FieldTextStyle.textStyle,
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}
