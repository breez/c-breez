import 'package:breez_translations/breez_translations_locales.dart';
import 'package:breez_translations/generated/breez_translations.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/models.dart';

class BalanceText extends StatefulWidget {
  final bool hiddenBalance;
  final CurrencyState currencyState;
  final AccountState accountState;
  final double offsetFactor;

  const BalanceText({
    super.key,
    required this.hiddenBalance,
    required this.currencyState,
    required this.accountState,
    required this.offsetFactor,
  });

  @override
  State<BalanceText> createState() => _BalanceTextState();
}

class _BalanceTextState extends State<BalanceText> {
  double get startSize => theme.balanceAmountTextStyle.fontSize!;
  double get endSize => startSize - 8.0;

  @override
  Widget build(BuildContext context) {
    final BreezTranslations texts = context.texts();
    final ThemeData themeData = Theme.of(context);

    return TextButton(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (<WidgetState>{WidgetState.focused, WidgetState.hovered}.any(states.contains)) {
            return themeData.customData.paymentListBgColor;
          }
          return null;
        }),
      ),
      onPressed: () async => await _changeBtcCurrency(context),
      child: widget.hiddenBalance
          ? Text(
              texts.wallet_dashboard_balance_hide,
              style: theme.balanceAmountTextStyle.copyWith(
                color: themeData.colorScheme.onSecondary,
                fontSize: startSize - (startSize - endSize) * widget.offsetFactor,
              ),
            )
          : RichText(
              text: TextSpan(
                style: theme.balanceAmountTextStyle.copyWith(
                  color: themeData.colorScheme.onSecondary,
                  fontSize: startSize - (startSize - endSize) * widget.offsetFactor,
                ),
                text: widget.currencyState.bitcoinCurrency.format(
                  widget.accountState.balanceSat,
                  removeTrailingZeros: true,
                  includeDisplayName: false,
                ),
                children: [
                  TextSpan(
                    text: " ${widget.currencyState.bitcoinCurrency.displayName}",
                    style: theme.balanceCurrencyTextStyle.copyWith(
                      color: themeData.colorScheme.onSecondary,
                      fontSize: startSize * 0.6 - (startSize * 0.6 - endSize) * widget.offsetFactor,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _changeBtcCurrency(BuildContext context) async {
    final UserProfileBloc userProfileCubit = context.read<UserProfileBloc>();
    final CurrencyBloc currencyCubit = context.read<CurrencyBloc>();
    final CurrencyState currencyState = currencyCubit.state;

    if (widget.hiddenBalance == true) {
      userProfileCubit.updateProfile(hideBalance: false);
      return;
    }
    final List<BitcoinCurrency> list = BitcoinCurrency.currencies;
    final int index = list.indexOf(BitcoinCurrency.fromTickerSymbol(currencyState.bitcoinTicker));
    final int nextCurrencyIndex = (index + 1) % list.length;
    if (nextCurrencyIndex == 1) {
      userProfileCubit.updateProfile(hideBalance: true);
    }
    currencyCubit.setBitcoinTicker(list[nextCurrencyIndex].tickerSymbol);
  }
}
