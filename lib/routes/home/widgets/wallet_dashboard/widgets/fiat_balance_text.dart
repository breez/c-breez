import 'dart:math';

import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FiatBalanceText extends StatelessWidget {
  final bool hiddenBalance;
  final CurrencyState currencyState;
  final AccountState accountState;
  final double offsetFactor;

  const FiatBalanceText({
    super.key,
    required this.hiddenBalance,
    required this.currencyState,
    required this.accountState,
    required this.offsetFactor,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    if (!currencyState.fiatEnabled || hiddenBalance || !isAboveMinAmount(currencyState, accountState)) {
      return const SizedBox.shrink();
    }

    return TextButton(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.focused)) {
            return themeData.customData.paymentListBgColor;
          }
          if (states.contains(WidgetState.hovered)) {
            return themeData.customData.paymentListBgColor;
          }
          return null;
        }),
      ),
      onPressed: () {
        final newFiatConversion = nextValidFiatConversion(currencyState, accountState);
        if (newFiatConversion != null) {
          context.read<CurrencyBloc>().setFiatId(newFiatConversion.currencyData.id);
        }
      },
      child: accountState.balanceSat > 0
          ? Text(
              currencyState.fiatConversion()?.format(accountState.balanceSat) ?? "",
              style: theme.balanceFiatConversionTextStyle.copyWith(
                color: themeData.colorScheme.onSecondary.withValues(
                  alpha: pow(1.00 - offsetFactor, 2).toDouble(),
                ),
              ),
            )
          : Container(),
    );
  }

  FiatConversion? nextValidFiatConversion(CurrencyState currencyState, AccountState accountState) {
    final currencies = currencyState.preferredCurrencies;
    final currentIndex = currencies.indexOf(currencyState.fiatId);
    for (var i = 1; i < currencies.length; i++) {
      final nextIndex = (i + currentIndex) % currencies.length;
      if (isAboveMinAmount(currencyState, accountState)) {
        final conversion = currencyState.fiatById(currencies[nextIndex]);
        final exchangeRate = currencyState.fiatExchangeRate;
        if (conversion != null && exchangeRate != null) {
          return FiatConversion(conversion, exchangeRate);
        }
      }
    }
    return null;
  }

  bool isAboveMinAmount(CurrencyState currencyState, AccountState accountState) {
    final fiatConversion = currencyState.fiatConversion();
    if (fiatConversion == null) return false;

    double fiatValue = fiatConversion.satToFiat(accountState.balanceSat);
    int fractionSize = fiatConversion.currencyData.info.fractionSize;
    double minimumAmount = 1 / (pow(10, fractionSize));

    return fiatValue > minimumAmount;
  }
}
