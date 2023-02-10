import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_state.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BalanceText extends StatelessWidget {
  final double offset;

  const BalanceText(
    this.offset, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrencyBloc, CurrencyState>(
      builder: (context, currencyState) {
        return BlocBuilder<AccountBloc, AccountState>(
          builder: (context, accountState) {
            return BlocBuilder<UserProfileBloc, UserProfileState>(
              builder: (context, userProfileState) {
                return userProfileState.profileSettings.hideBalance
                    ? _balanceHide(context)
                    : _balanceRichText(context, currencyState, accountState);
              },
            );
          },
        );
      },
    );
  }

  Widget _balanceHide(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    return Text(
      texts.wallet_dashboard_balance_hide,
      style: theme.balanceAmountTextStyle.copyWith(
        color: themeData.colorScheme.onSecondary,
        fontSize: startSize - (startSize - endSize) * offset,
      ),
    );
  }

  Widget _balanceRichText(
    BuildContext context,
    CurrencyState currencyState,
    AccountState accountState,
  ) {
    final themeData = Theme.of(context);

    return RichText(
      text: TextSpan(
        style: theme.balanceAmountTextStyle.copyWith(
          color: themeData.colorScheme.onSecondary,
          fontSize: startSize - (startSize - endSize) * offset,
        ),
        text: currencyState.bitcoinCurrency.format(
          accountState.balance,
          removeTrailingZeros: true,
          includeDisplayName: false,
        ),
        children: [
          TextSpan(
            text: " ${currencyState.bitcoinCurrency.displayName}",
            style: theme.balanceCurrencyTextStyle.copyWith(
              color: themeData.colorScheme.onSecondary,
              fontSize: startSize * 0.6 - (startSize * 0.6 - endSize) * offset,
            ),
          ),
        ],
      ),
    );
  }

  double get startSize => theme.balanceAmountTextStyle.fontSize!;

  double get endSize => startSize - 8.0;
}
