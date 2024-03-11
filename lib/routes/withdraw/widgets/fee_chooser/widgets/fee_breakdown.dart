import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/models/currency.dart';
import 'package:c_breez/models/fee_options/fee_option.dart';
import 'package:c_breez/utils/min_font_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeeBreakdown extends StatelessWidget {
  final int amountSat;
  final FeeOption feeOption;

  const FeeBreakdown(
    this.amountSat,
    this.feeOption, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    var feeOption = this.feeOption;
    int? boltzServiceFee;
    if (feeOption is ReverseSwapFeeOption) {
      boltzServiceFee = feeOption.pairInfo.totalFees - feeOption.txFeeSat;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        border: Border.all(
          color: themeData.colorScheme.onSurface.withOpacity(0.4),
        ),
      ),
      child: Column(
        children: [
          TotalCost(
            amountSat: (feeOption is ReverseSwapFeeOption)
                ? feeOption.pairInfo.senderAmountSat
                : amountSat + feeOption.txFeeSat,
          ),
          if (boltzServiceFee != null) ...[
            BoltzServiceFee(boltzServiceFee: boltzServiceFee),
          ],
          TransactionFee(txFeeSat: feeOption.txFeeSat),
          // For reverse swapping all funds we subtract the fees from swap amount
          ReceivedAmount(
            amountSat: (feeOption is ReverseSwapFeeOption)
                ? feeOption.pairInfo.recipientAmountSat
                : amountSat - feeOption.txFeeSat,
          )
        ],
      ),
    );
  }
}

class TotalCost extends StatelessWidget {
  final int amountSat;

  const TotalCost({
    required this.amountSat,
    super.key,
  });

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
                ? texts.sweep_all_coins_amount_no_fiat(
                    BitcoinCurrency.SAT.format(amountSat),
                  )
                : texts.sweep_all_coins_amount_with_fiat(
                    BitcoinCurrency.SAT.format(amountSat),
                    fiatConversion.format(amountSat),
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

class BoltzServiceFee extends StatelessWidget {
  final int boltzServiceFee;

  const BoltzServiceFee({
    required this.boltzServiceFee,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final minFont = MinFontSize(context);

    return ListTile(
      title: AutoSizeText(
        texts.reverse_swap_confirmation_boltz_fee,
        style: TextStyle(color: Colors.white.withOpacity(0.4)),
        maxLines: 1,
        minFontSize: minFont.minFontSize,
        stepGranularity: 0.1,
      ),
      trailing: AutoSizeText(
        texts.reverse_swap_confirmation_boltz_fee_value(
          BitcoinCurrency.SAT.format(boltzServiceFee),
        ),
        style: TextStyle(color: themeData.colorScheme.error.withOpacity(0.4)),
        maxLines: 1,
        minFontSize: minFont.minFontSize,
        stepGranularity: 0.1,
      ),
    );
  }
}

class TransactionFee extends StatelessWidget {
  final int txFeeSat;

  const TransactionFee({
    super.key,
    required this.txFeeSat,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final minFont = MinFontSize(context);

    return ListTile(
      title: AutoSizeText(
        texts.sweep_all_coins_label_transaction_fee,
        style: TextStyle(color: Colors.white.withOpacity(0.4)),
        maxLines: 1,
        minFontSize: minFont.minFontSize,
        stepGranularity: 0.1,
      ),
      trailing: AutoSizeText(
        texts.sweep_all_coins_fee(
          BitcoinCurrency.SAT.format(txFeeSat),
        ),
        style: TextStyle(color: themeData.colorScheme.error.withOpacity(0.4)),
        maxLines: 1,
        minFontSize: minFont.minFontSize,
        stepGranularity: 0.1,
      ),
    );
  }
}

class ReceivedAmount extends StatelessWidget {
  final int amountSat;

  const ReceivedAmount({
    super.key,
    required this.amountSat,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final minFont = MinFontSize(context);

    return ListTile(
      title: AutoSizeText(
        texts.sweep_all_coins_label_receive,
        style: const TextStyle(color: Colors.white),
        maxLines: 1,
        minFontSize: minFont.minFontSize,
        stepGranularity: 0.1,
      ),
      trailing: BlocBuilder<CurrencyBloc, CurrencyState>(builder: (context, currency) {
        final fiatConversion = currency.fiatConversion();

        return AutoSizeText(
          fiatConversion == null
              ? texts.sweep_all_coins_amount_no_fiat(
                  BitcoinCurrency.SAT.format(amountSat),
                )
              : texts.sweep_all_coins_amount_with_fiat(
                  BitcoinCurrency.SAT.format(amountSat),
                  fiatConversion.format(amountSat),
                ),
          style: TextStyle(color: themeData.colorScheme.error),
          maxLines: 1,
          minFontSize: minFont.minFontSize,
          stepGranularity: 0.1,
        );
      }),
    );
  }
}
