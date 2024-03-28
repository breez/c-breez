import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WithdrawFundsAvailableBtc extends StatelessWidget {
  const WithdrawFundsAvailableBtc();

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return Padding(
      padding: const EdgeInsets.only(top: 36.0),
      child: BlocBuilder<AccountBloc, AccountState>(builder: (context, account) {
        return Row(
          children: [
            Text(
              texts.withdraw_funds_balance,
              style: theme.textStyle,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 3.0),
              child: BlocBuilder<CurrencyBloc, CurrencyState>(
                builder: (context, currencyState) {
                  return Text(
                    currencyState.bitcoinCurrency.format(account.balance),
                    style: theme.textStyle,
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
