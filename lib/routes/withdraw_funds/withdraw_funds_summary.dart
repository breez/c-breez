import 'package:auto_size_text/auto_size_text.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/models/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fixnum/fixnum.dart';

class WithdrawFundsSummary extends StatelessWidget {
  final Int64 total;
  final Int64 fee;
  final Int64 receive;

  const WithdrawFundsSummary(
    this.total,
    this.fee,
    this.receive, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

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
              style: themeData.primaryTextTheme.titleMedium!.copyWith(
                color: themeData.primaryColor,
              ),
              maxLines: 1,
              minFontSize: 12,
              stepGranularity: 0.1,
            ),
            trailing: AutoSizeText(
              BitcoinCurrency.SAT.format(total),
              style: themeData.primaryTextTheme.titleMedium!.copyWith(
                color: themeData.primaryColor.withOpacity(0.8),
              ),
              maxLines: 1,
              minFontSize: 12,
              stepGranularity: 0.1,
            ),
          ),
          ListTile(
            title: AutoSizeText(
              texts.sweep_all_coins_label_transaction_fee,
              style: themeData.primaryTextTheme.titleMedium!.copyWith(
                color: themeData.primaryColor.withOpacity(0.4),
              ),
              maxLines: 1,
              minFontSize: 12,
              stepGranularity: 0.1,
            ),
            trailing: AutoSizeText(
              texts.sweep_all_coins_fee(
                BitcoinCurrency.SAT.format(fee),
              ),
              style: themeData.primaryTextTheme.titleMedium!.copyWith(
                color: themeData.primaryColor.withOpacity(0.4),
              ),
              maxLines: 1,
              minFontSize: 12,
              stepGranularity: 0.1,
            ),
          ),
          ListTile(
            title: AutoSizeText(
              texts.sweep_all_coins_label_receive,
              style: themeData.primaryTextTheme.titleMedium!.copyWith(
                color: themeData.primaryColor,
              ),
              maxLines: 1,
              minFontSize: 12,
              stepGranularity: 0.1,
            ),
            trailing: BlocBuilder<CurrencyBloc, CurrencyState>(
              builder: (context, currency) {
                final fiatConversion = currency.fiatConversion();
                return AutoSizeText(
                  fiatConversion == null
                      ? texts.sweep_all_coins_amount_no_fiat(
                          BitcoinCurrency.SAT.format(receive),
                        )
                      : texts.sweep_all_coins_amount_with_fiat(
                          BitcoinCurrency.SAT.format(receive),
                          fiatConversion.format(receive),
                        ),
                  style: themeData.primaryTextTheme.titleMedium!.copyWith(
                    color: themeData.primaryColor.withOpacity(0.8),
                  ),
                  maxLines: 1,
                  minFontSize: 12,
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
