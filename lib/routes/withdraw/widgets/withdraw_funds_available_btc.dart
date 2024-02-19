import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger("WithdrawFundsAvailableBtc");

class WithdrawFundsAvailableBtc extends StatelessWidget {
  final int? maxSendableAmount;

  const WithdrawFundsAvailableBtc({this.maxSendableAmount});

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final textStyle = themeData.primaryTextTheme.displaySmall!.copyWith(
      color: BreezColors.white[500],
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Text(texts.withdraw_funds_balance, style: textStyle),
          Padding(
            padding: const EdgeInsets.only(left: 3.0),
            child: BlocBuilder<AccountBloc, AccountState>(
              builder: (context, account) {
                _log.info(
                  "Building with wallet balance: ${account.walletBalance} balance: ${account.balance} maxSendableAmount: $maxSendableAmount",
                );
                return BlocBuilder<CurrencyBloc, CurrencyState>(
                  builder: (context, currencyState) {
                    return Text(
                      currencyState.bitcoinCurrency.format(maxSendableAmount ?? account.balance),
                      style: textStyle,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
