import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/models/currency.dart';
import 'package:c_breez/utils/utils.dart';
import 'package:flutter/material.dart';

class TransactionFee extends StatelessWidget {
  final int txFeeSat;

  const TransactionFee({super.key, required this.txFeeSat});

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final minFont = MinFontSize(context);

    return ListTile(
      title: AutoSizeText(
        texts.sweep_all_coins_label_transaction_fee,
        style: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
        maxLines: 1,
        minFontSize: minFont.minFontSize,
        stepGranularity: 0.1,
      ),
      trailing: AutoSizeText(
        texts.sweep_all_coins_fee(BitcoinCurrency.SAT.format(txFeeSat)),
        style: TextStyle(color: themeData.colorScheme.error.withValues(alpha: 0.4)),
        maxLines: 1,
        minFontSize: minFont.minFontSize,
        stepGranularity: 0.1,
      ),
    );
  }
}
