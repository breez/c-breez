import 'dart:math';
import 'package:c_breez/models/currency.dart';
import 'package:c_breez/utils/currency_formatter.dart';
import 'package:c_breez/utils/locale.dart';
import 'package:fixnum/fixnum.dart';

class FiatConversion {
  FiatCurrency currencyData;
  double exchangeRate;

  FiatConversion(this.currencyData, this.exchangeRate);

  String get logoPath {
    switch (currencyData.symbol) {
      case "€":
        return "src/icon/btc_eur.png";
      case "£":
        return "src/icon/btc_gbp.png";
      case "¥":
        return "src/icon/btc_yen.png";
      case "\$":
        return "src/icon/btc_usd.png";
      default:
        return "src/icon/btc_convert.png";
    }
  }

  Int64 fiatToSat(double fiatAmount) {
    return Int64((fiatAmount / exchangeRate * 100000000).round());
  }

  double satToFiat(Int64 satoshies) {
    return satoshies.toDouble() / 100000000 * exchangeRate;
  }

  String format(Int64 amount) {
    double fiatValue = satToFiat(amount);
    return formatFiat(fiatValue);
  }

  String formatFiat(
    double fiatAmount, {
    bool removeTrailingZeros = false,
  }) {
    final locale = getSystemLocale();
    final currencyData = this
        .currencyData
        .localeAware(locale.toLanguageTag(), locale.languageCode);
    int? fractionSize = currencyData.fractionSize;
    double minimumAmount = 1 / (pow(10, fractionSize!));

    String formattedAmount = "";
    String spacing = " " * currencyData.spacing;
    String symbol = (currencyData.position == 1)
        ? spacing + currencyData.symbol
        : currencyData.symbol + spacing;
    // if conversion result is less than the minimum it doesn't make sense to display
    // it.
    if (fiatAmount < minimumAmount) {
      formattedAmount = minimumAmount.toStringAsFixed(fractionSize);
      symbol = '< $symbol';
    } else {
      final formatter = CurrencyFormatter().formatter;
      formatter.minimumFractionDigits = fractionSize;
      formatter.maximumFractionDigits = fractionSize;
      formattedAmount = formatter.format(fiatAmount);
    }
    formattedAmount = (currencyData.position == 1)
        ? formattedAmount + symbol
        : symbol + formattedAmount;
    if (removeTrailingZeros) {
      RegExp removeTrailingZeros = RegExp(r"([.]0*)(?!.*\d)");
      formattedAmount = formattedAmount.replaceAll(removeTrailingZeros, "");
    }
    return formattedAmount;
  }

  double get satConversionRate => 1 / exchangeRate * 100000000;
}
