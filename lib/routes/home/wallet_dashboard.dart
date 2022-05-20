import 'dart:math';

import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_state.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/models/currency.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/fiat_conversion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _kBalanceOffsetTransition = 60.0;

class WalletDashboard extends StatelessWidget {
  final double _height;
  final double _offsetFactor;

  const WalletDashboard(
    this._height,
    this._offsetFactor, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrencyBloc, CurrencyState>(
      builder: (context, currencyState) {
        return BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, userProfileState) {
            return BlocBuilder<AccountBloc, AccountState>(
              builder: (context, accountState) {
                return _build(
                  context,
                  currencyState,
                  userProfileState,
                  accountState,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _build(
    BuildContext context,
    CurrencyState currencyState,
    UserProfileState userProfileState,
    AccountState accountState,
  ) {
    const balanceAmountTextStyle = theme.balanceAmountTextStyle;
    final profileSettings = userProfileState.profileSettings;

    double startHeaderSize = balanceAmountTextStyle.fontSize!;
    double endHeaderFontSize = startHeaderSize - 8.0;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: _height,
            decoration: BoxDecoration(
              color: theme.customData[theme.themeId]!.dashboardBgColor,
            ),
          ),
          Positioned(
            top: 60 - _kBalanceOffsetTransition * _offsetFactor,
            child: Center(
              child: !accountState.initial
                  ? TextButton(
                      style: _balanceStyle(),
                      onPressed: () {
                        if (profileSettings.hideBalance == true) {
                          _onPrivacyChanged(context, false);
                          return;
                        }
                        final list = BitcoinCurrency.currencies;
                        final index = list.indexOf(
                          BitcoinCurrency.fromTickerSymbol(
                            currencyState.bitcoinTicker,
                          ),
                        );
                        final nextCurrencyIndex = (index + 1) % list.length;
                        if (nextCurrencyIndex == 1) {
                          _onPrivacyChanged(context, true);
                        }
                        context.read<CurrencyBloc>().setBitcoinTicker(
                              list[nextCurrencyIndex].tickerSymbol,
                            );
                      },
                      child: profileSettings.hideBalance
                          ? _balanceHide(
                              context,
                              startHeaderSize,
                              endHeaderFontSize,
                            )
                          : _balanceRichText(
                              context,
                              currencyState,
                              accountState,
                              startHeaderSize,
                              endHeaderFontSize,
                            ),
                    )
                  : const SizedBox(),
            ),
          ),
          Positioned(
            top: 100 - _kBalanceOffsetTransition * _offsetFactor,
            child: Center(
              child: currencyState.fiatEnabled &&
                      isAboveMinAmount(currencyState, accountState) &&
                      !profileSettings.hideBalance
                  ? _fiatButton(context, currencyState, accountState)
                  : const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  ButtonStyle _balanceStyle() {
    return ButtonStyle(
      overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
        final customData = theme.customData[theme.themeId];
        if (customData == null) return null;
        if (states.contains(MaterialState.focused)) {
          return customData.paymentListBgColor;
        }
        if (states.contains(MaterialState.hovered)) {
          return customData.paymentListBgColor;
        }
        return null;
      }),
    );
  }

  Widget _balanceRichText(
    BuildContext context,
    CurrencyState currencyState,
    AccountState accountState,
    double startHeaderSize,
    double endHeaderFontSize,
  ) {
    final themeData = Theme.of(context);
    final balanceAmountTextStyle = theme.balanceAmountTextStyle
        .copyWith(color: themeData.colorScheme.onSecondary);
    final balanceCurrencyTextStyle = theme.balanceCurrencyTextStyle
        .copyWith(color: themeData.colorScheme.onSecondary);

    return RichText(
      text: TextSpan(
        style: balanceAmountTextStyle.copyWith(
          fontSize: startHeaderSize -
              (startHeaderSize - endHeaderFontSize) * _offsetFactor,
        ),
        text: currencyState.bitcoinCurrency.format(
          accountState.balance,
          removeTrailingZeros: true,
          includeDisplayName: false,
        ),
        children: [
          TextSpan(
            text: ' ${currencyState.bitcoinCurrency.displayName}',
            style: balanceCurrencyTextStyle.copyWith(
              fontSize: startHeaderSize * 0.6 -
                  (startHeaderSize * 0.6 - endHeaderFontSize) * _offsetFactor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _balanceHide(
    BuildContext context,
    double startHeaderSize,
    double endHeaderFontSize,
  ) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    return Text(
      texts.wallet_dashboard_balance_hide,
      style: theme.balanceAmountTextStyle.copyWith(
        color: themeData.colorScheme.onSecondary,
        fontSize: startHeaderSize -
            (startHeaderSize - endHeaderFontSize) * _offsetFactor,
      ),
    );
  }

  Widget _fiatButton(
    BuildContext context,
    CurrencyState currencyState,
    AccountState accountState,
  ) {
    final themeData = Theme.of(context);
    const fiatConversionTextStyle = theme.balanceFiatConversionTextStyle;

    return TextButton(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
          final customData = theme.customData[theme.themeId];
          if (customData == null) return null;
          if (states.contains(MaterialState.focused)) {
            return customData.paymentListBgColor;
          }
          if (states.contains(MaterialState.hovered)) {
            return customData.paymentListBgColor;
          }
          return null;
        }),
      ),
      onPressed: () {
        final newFiatConversion = nextValidFiatConversion(
          currencyState,
          accountState,
        );
        if (newFiatConversion != null) {
          context.read<CurrencyBloc>().setFiatShortName(
                newFiatConversion.currencyData.shortName,
              );
        }
      },
      child: Text(
        currencyState.fiatConversion()?.format(accountState.balance) ?? "",
        style: fiatConversionTextStyle.copyWith(
          color: themeData.colorScheme.onSecondary.withOpacity(
            pow(1.00 - _offsetFactor, 2).toDouble(),
          ),
        ),
      ),
    );
  }

  FiatConversion? nextValidFiatConversion(
    CurrencyState currencyState,
    AccountState accountState,
  ) {
    final currencies = currencyState.preferredCurrencies;
    final currentIndex = currencies.indexOf(currencyState.fiatShortName);
    for (var i = 1; i < currencies.length; i++) {
      final nextIndex = (i + currentIndex) % currencies.length;
      if (isAboveMinAmount(currencyState, accountState)) {
        final conversion = currencyState.fiatByShortName(currencies[nextIndex]);
        final exchangeRate = currencyState.fiatExchangeRate;
        if (conversion != null && exchangeRate != null) {
          return FiatConversion(conversion, exchangeRate);
        }
      }
    }
    return null;
  }

  bool isAboveMinAmount(
    CurrencyState currencyState,
    AccountState accountState,
  ) {
    final fiatConversion = currencyState.fiatConversion();
    if (fiatConversion == null) return false;

    double fiatValue = fiatConversion.satToFiat(accountState.balance);
    int fractionSize = fiatConversion.currencyData.fractionSize;
    double minimumAmount = 1 / (pow(10, fractionSize));

    return fiatValue > minimumAmount;
  }

  void _onPrivacyChanged(
    BuildContext context,
    bool hideBalance,
  ) {
    context.read<UserProfileBloc>().updateProfile(hideBalance: hideBalance);
  }
}
