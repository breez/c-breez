import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WithdrawFundsAvailableBtc extends StatelessWidget {
  const WithdrawFundsAvailableBtc();

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final textStyle = themeData.primaryTextTheme.headline3!.copyWith(
      color: BreezColors.white[500],
    );

    return Row(
      children: [
        Text(
          texts.withdraw_funds_balance,
          style: textStyle,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3.0),
          child: BlocBuilder<AccountBloc, AccountState>(
            builder: (context, account) {
              return BlocBuilder<CurrencyBloc, CurrencyState>(
                builder: (context, currencyState) {
                  return Text(
                    currencyState.bitcoinCurrency.format(account.walletBalance),
                    style: textStyle,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
