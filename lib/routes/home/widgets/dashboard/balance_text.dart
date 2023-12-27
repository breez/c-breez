import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/bloc/user_profile/user_profile_state.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BalanceText extends StatefulWidget {
  final UserProfileState userProfileState;
  final CurrencyState currencyState;
  final double offsetFactor;

  const BalanceText({
    super.key,
    required this.userProfileState,
    required this.currencyState,
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
    final texts = context.texts();
    final themeData = Theme.of(context);
    final balance = context.watch<AccountBloc>().state.balance;
    return widget.userProfileState.profileSettings.hideBalance
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
                balance,
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
          );
  }
}
