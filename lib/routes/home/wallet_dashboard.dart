import 'dart:math';

import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/models/currency.dart';
import 'package:c_breez/models/user_profile.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/fiat_conversion.dart';
import 'package:flutter/material.dart';

class WalletDashboard extends StatefulWidget {
  final CurrencyState _currencyState;
  final AccountState _accountState;
  final UserProfileSettings _userModel;
  final double _height;
  final double _offsetFactor;
  final Function(String bitcoinCurrencyTicker) _onCurrencyChange;
  final Function(String fiatShortName) _onFiatCurrencyChange;
  final Function(bool hideBalance) _onPrivacyChange;

  const WalletDashboard(
      this._userModel,
      this._accountState,
      this._currencyState,
      this._height,
      this._offsetFactor,
      this._onCurrencyChange,
      this._onFiatCurrencyChange,
      this._onPrivacyChange);

  @override
  State<StatefulWidget> createState() {
    return WalletDashboardState();
  }
}

class WalletDashboardState extends State<WalletDashboard> {
  static const BALANCE_OFFSET_TRANSITION = 60.0;
  bool _showFiatCurrency = false;

  @override
  Widget build(BuildContext context) {
    double startHeaderSize = Theme.of(context).textTheme.headline4!.fontSize!;
    double endHeaderFontSize =
        Theme.of(context).textTheme.headline4!.fontSize! - 8.0;

    FiatConversion? fiatConversion = widget._currencyState.fiatEnabled
        ? FiatConversion(widget._currencyState.fiatCurrency!,
            widget._currencyState.fiatExchangeRate!)
        : null;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPressStart: (_) {
        setState(() {
          _showFiatCurrency = true;
        });
      },
      onLongPressEnd: (_) {
        setState(() {
          _showFiatCurrency = false;
        });
      },
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width,
              height: widget._height,
              decoration: BoxDecoration(
                color: theme.customData[theme.themeId]!.dashboardBgColor,
              )),
          Positioned(
            top: 60 - BALANCE_OFFSET_TRANSITION * widget._offsetFactor,
            child: Center(
              child: TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.focused)) {
                        return theme
                            .customData[theme.themeId]!.paymentListBgColor;
                      }
                      if (states.contains(MaterialState.hovered)) {
                        return theme
                            .customData[theme.themeId]!.paymentListBgColor;
                      }
                      return Theme.of(context)
                          .textTheme
                          .button!
                          .color!; // Defer to the widget's default.
                    }),
                  ),
                  onPressed: () {
                    if (widget._userModel.hideBalance) {
                      widget._onPrivacyChange(false);
                      return;
                    }
                    var nextCurrencyIndex = (BitcoinCurrency.currencies.indexOf(
                                widget._currencyState.bitcoinCurrency) +
                            1) %
                        BitcoinCurrency.currencies.length;
                    if (nextCurrencyIndex == 1) {
                      widget._onPrivacyChange(true);
                    }
                    widget._onCurrencyChange(BitcoinCurrency
                        .currencies[nextCurrencyIndex].tickerSymbol);
                  },
                  child: widget._userModel.hideBalance
                      ? Text("******",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary,
                                  fontSize: startHeaderSize -
                                      (startHeaderSize - endHeaderFontSize) *
                                          widget._offsetFactor))
                      : (widget._offsetFactor > 0.8 &&
                              _showFiatCurrency &&
                              fiatConversion != null)
                          ? Text(
                              fiatConversion
                                  .format(widget._accountState.balance),
                              style:
                                  Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                          fontSize: startHeaderSize -
                                              (startHeaderSize -
                                                      endHeaderFontSize) *
                                                  widget._offsetFactor))
                          : RichText(
                              text: TextSpan(
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                          fontSize: startHeaderSize -
                                              (startHeaderSize -
                                                      endHeaderFontSize) *
                                                  widget._offsetFactor),
                                  text: widget._currencyState.bitcoinCurrency
                                      .format(widget._accountState.balance,
                                          removeTrailingZeros: true,
                                          includeDisplayName: false),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: " ${widget._currencyState.bitcoinCurrency
                                              .displayName}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondary,
                                              fontSize: startHeaderSize * 0.6 -
                                                  (startHeaderSize * 0.6 -
                                                          endHeaderFontSize) *
                                                      widget._offsetFactor),
                                    ),
                                  ]),
                            )),
            ),
          ),
          Positioned(
            top: 100 - BALANCE_OFFSET_TRANSITION * widget._offsetFactor,
            child: Center(
              child: widget._currencyState.fiatEnabled &&
                      isAboveMinAmount(widget._currencyState.fiatCurrency!,
                          widget._currencyState.fiatExchangeRate!) &&
                      !widget._userModel.hideBalance
                  ? TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.focused)) {
                            return theme
                                .customData[theme.themeId]!.paymentListBgColor;
                          }
                          if (states.contains(MaterialState.hovered)) {
                            return theme
                                .customData[theme.themeId]!.paymentListBgColor;
                          }
                          return Theme.of(context)
                              .textTheme
                              .button!
                              .color!; // Defer to the widget's default.
                        }),
                      ),
                      onPressed: () {
                        FiatConversion? newFiatConversion =
                            nextValidFiatConversion();
                        if (newFiatConversion != null) {
                          widget._onFiatCurrencyChange(
                              newFiatConversion.currencyData.shortName);
                        }
                      },
                      child: fiatConversion != null
                          ? Text(
                              fiatConversion
                                  .format(widget._accountState.balance),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary
                                          .withOpacity(pow(
                                                  1.00 - widget._offsetFactor,
                                                  2)
                                              .toDouble())))
                          : Container())
                  : const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  FiatConversion? nextValidFiatConversion() {
    var currentIndex = widget._currencyState.preferredCurrencies
        .indexOf(widget._currencyState.fiatShortName);
    for (var i = 1; i < widget._currencyState.preferredCurrencies.length; i++) {
      var nextIndex =
          (i + currentIndex) % widget._currencyState.preferredCurrencies.length;
      var nextFiat = widget._currencyState.preferredCurrencies[nextIndex];
      var nextFiatObj = widget._currencyState.fiatByShortName(nextFiat);
      var nextFiatCurrency = widget._currencyState.exchangeRates[nextFiat];
      if (nextFiatObj != null && nextFiatCurrency != null) {
        if (isAboveMinAmount(nextFiatObj, nextFiatCurrency)) {
          return FiatConversion(nextFiatObj, nextFiatCurrency);
        }
      }
    }
    return null;
  }

  bool isAboveMinAmount(FiatCurrency currency, double exchangeRate) {
    var fiatConversion = FiatConversion(currency, exchangeRate);
    double fiatValue = fiatConversion.satToFiat(widget._accountState.balance);
    int fractionSize = fiatConversion.currencyData.fractionSize;
    double minimumAmount = 1 / (pow(10, fractionSize));

    return fiatValue > minimumAmount;
  }
}
