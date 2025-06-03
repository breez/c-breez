import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/models/currency.dart';
import 'package:c_breez/utils/min_font_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SenderAmount extends StatelessWidget {
  final int amountSat;

  const SenderAmount({required this.amountSat, super.key});

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final minFont = MinFontSize(context);

    return ListTile(
      title: AutoSizeText(
        texts.sweep_all_coins_label_send,
        maxLines: 1,
        minFontSize: minFont.minFontSize,
        stepGranularity: 0.1,
      ),
      trailing: BlocBuilder<CurrencyBloc, CurrencyState>(
        builder: (context, currency) {
          final fiatConversion = currency.fiatConversion();

          return AutoSizeText(
            fiatConversion == null
                ? texts.sweep_all_coins_amount_no_fiat(BitcoinCurrency.SAT.format(amountSat))
                : texts.sweep_all_coins_amount_with_fiat(
                    BitcoinCurrency.SAT.format(amountSat),
                    fiatConversion.formatSat(amountSat),
                  ),
            style: TextStyle(color: themeData.colorScheme.error),
            maxLines: 1,
            minFontSize: minFont.minFontSize,
            stepGranularity: 0.1,
          );
        },
      ),
    );
  }
}
