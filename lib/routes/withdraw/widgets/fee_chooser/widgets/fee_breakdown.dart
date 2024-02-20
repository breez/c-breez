import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/models/currency.dart';
import 'package:c_breez/utils/min_font_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeeBreakdown extends StatelessWidget {
  final int swapAmount;
  final int txFees;
  final int? boltzFees;
  final bool? isMaxValue;

  const FeeBreakdown(
    this.swapAmount,
    this.txFees, {
    super.key,
    this.boltzFees,
    this.isMaxValue,
  });

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
            trailing: BlocBuilder<CurrencyBloc, CurrencyState>(
              builder: (context, currency) {
                final fiatConversion = currency.fiatConversion();

                int sendAmount;
                if (isMaxValue == true) {
                  // For reverse swapping all funds we subtract the fees from swapAmount
                  // txFees is added as boltzFees includes this
                  sendAmount = swapAmount;
                } else {
                  sendAmount = swapAmount;
                  if (boltzFees != null) {
                    sendAmount += boltzFees!;
                  }
                }

                return AutoSizeText(
                  fiatConversion == null
                      ? texts.sweep_all_coins_amount_no_fiat(
                          BitcoinCurrency.SAT.format(sendAmount),
                        )
                      : texts.sweep_all_coins_amount_with_fiat(
                          BitcoinCurrency.SAT.format(sendAmount), fiatConversion.format(sendAmount)),
                  style: TextStyle(color: themeData.colorScheme.error),
                  maxLines: 1,
                  minFontSize: minFont.minFontSize,
                  stepGranularity: 0.1,
                );
              },
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
                  BitcoinCurrency.SAT.format(boltzFees! - txFees),
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
                BitcoinCurrency.SAT.format(txFees),
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
            trailing: BlocBuilder<CurrencyBloc, CurrencyState>(builder: (context, currency) {
              final fiatConversion = currency.fiatConversion();

              int receivedAmount = swapAmount;
              if (isMaxValue == true) {
                // For reverse swapping all funds we subtract the fees from swapAmount
                // txFees is added as boltzFees includes this
                receivedAmount = swapAmount;
                if (boltzFees != null) {
                  receivedAmount -= boltzFees!;
                }
              }

              return AutoSizeText(
                fiatConversion == null
                    ? texts.sweep_all_coins_amount_no_fiat(
                        BitcoinCurrency.SAT.format(receivedAmount),
                      )
                    : texts.sweep_all_coins_amount_with_fiat(
                        BitcoinCurrency.SAT.format(receivedAmount),
                        fiatConversion.format(receivedAmount),
                      ),
                style: TextStyle(color: themeData.colorScheme.error),
                maxLines: 1,
                minFontSize: minFont.minFontSize,
                stepGranularity: 0.1,
              );
            }),
          ),
        ],
      ),
    );
  }
}
