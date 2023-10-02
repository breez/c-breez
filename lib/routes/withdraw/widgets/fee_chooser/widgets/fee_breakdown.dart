import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/models/currency.dart';
import 'package:c_breez/utils/min_font_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeeBreakdown extends StatelessWidget {
  final int total;
  final int fee;
  final int? boltzFees;

  const FeeBreakdown(
    this.total,
    this.fee, {
    Key? key,
    this.boltzFees,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final minFont = MinFontSize(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        border: Border.all(
          color: themeData.colorScheme.onSurface.withOpacity(0.4),
        ),
      ),
      child: Column(
        children: [
          ListTile(
            title: AutoSizeText(
              texts.sweep_all_coins_label_send,
              maxLines: 1,
              minFontSize: minFont.minFontSize,
              stepGranularity: 0.1,
            ),
            trailing: AutoSizeText(
              BitcoinCurrency.SAT.format(total),
              style: TextStyle(
                color: themeData.colorScheme.error,
              ),
              maxLines: 1,
              minFontSize: minFont.minFontSize,
              stepGranularity: 0.1,
            ),
          ),
          if (boltzFees != null) ...[
            ListTile(
              title: AutoSizeText(
                texts.reverse_swap_confirmation_boltz_fee,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                ),
                maxLines: 1,
                minFontSize: minFont.minFontSize,
                stepGranularity: 0.1,
              ),
              trailing: AutoSizeText(
                texts.reverse_swap_confirmation_boltz_fee_value(
                  BitcoinCurrency.SAT.format(boltzFees!),
                ),
                style: TextStyle(
                  color: themeData.colorScheme.error.withOpacity(0.4),
                ),
                maxLines: 1,
                minFontSize: minFont.minFontSize,
                stepGranularity: 0.1,
              ),
            ),
          ],
          ListTile(
            title: AutoSizeText(
              texts.sweep_all_coins_label_transaction_fee,
              style: TextStyle(color: Colors.white.withOpacity(0.4)),
              maxLines: 1,
              minFontSize: minFont.minFontSize,
              stepGranularity: 0.1,
            ),
            trailing: AutoSizeText(
              texts.sweep_all_coins_fee(
                BitcoinCurrency.SAT.format(fee),
              ),
              style: TextStyle(
                color: themeData.colorScheme.error.withOpacity(0.4),
              ),
              maxLines: 1,
              minFontSize: minFont.minFontSize,
              stepGranularity: 0.1,
            ),
          ),
          ListTile(
            title: AutoSizeText(
              texts.sweep_all_coins_label_receive,
              style: const TextStyle(
                color: Colors.white,
              ),
              maxLines: 1,
              minFontSize: minFont.minFontSize,
              stepGranularity: 0.1,
            ),
            trailing: BlocBuilder<CurrencyBloc, CurrencyState>(
              builder: (context, currency) {
                final fiatConversion = currency.fiatConversion();
                int receive = total - fee;
                if (boltzFees != null) {
                  receive -= boltzFees!;
                }
                return AutoSizeText(
                  fiatConversion == null
                      ? texts.sweep_all_coins_amount_no_fiat(
                          BitcoinCurrency.SAT.format(receive),
                        )
                      : texts.sweep_all_coins_amount_with_fiat(
                          BitcoinCurrency.SAT.format(receive),
                          fiatConversion.format(receive),
                        ),
                  style: TextStyle(
                    color: themeData.colorScheme.error,
                  ),
                  maxLines: 1,
                  minFontSize: minFont.minFontSize,
                  stepGranularity: 0.1,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
