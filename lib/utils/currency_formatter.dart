import 'package:c_breez/models/currency.dart';
import 'package:intl/intl.dart';
import 'package:intl/number_symbols.dart';
import 'package:intl/number_symbols_data.dart';

class CurrencyFormatter {
  final NumberFormat formatter = _defineFormatter();

  static NumberFormat _defineFormatter() {
    numberFormatSymbols['space-between'] = const NumberSymbols(
      NAME: "zz",
      DECIMAL_SEP: '.',
      GROUP_SEP: '\u00A0',
      PERCENT: '%',
      ZERO_DIGIT: '0',
      PLUS_SIGN: '+',
      MINUS_SIGN: '-',
      EXP_SYMBOL: 'e',
      PERMILL: '\u2030',
      INFINITY: '\u221E',
      NAN: 'NaN',
      DECIMAL_PATTERN: '#,##0.###',
      SCIENTIFIC_PATTERN: '#E0',
      PERCENT_PATTERN: '#,##0%',
      CURRENCY_PATTERN: '\u00A4#,##0.00',
      DEF_CURRENCY_CODE: 'AUD',
    );
    final formatter = NumberFormat('###,###.##', 'space-between');
    return formatter;
  }
}

class BitcoinCurrencyFormatter {
  static final formatter = CurrencyFormatter().formatter;

  String format(
    int amountSat,
    BitcoinCurrency currency, {
    bool addCurrencySuffix = true,
    bool addCurrencySymbol = false,
    removeTrailingZeros = false,
    userInput = false,
  }) {
    String formattedAmount = formatter.format(amountSat);
    switch (currency) {
      case BitcoinCurrency.BTC:
        double amountInBTC = (amountSat.toInt() / 100000000);
        formattedAmount = amountInBTC.toStringAsFixed(8);
        if (removeTrailingZeros) {
          if (amountInBTC.truncateToDouble() == amountInBTC) {
            formattedAmount = amountInBTC.toInt().toString();
          } else {
            formattedAmount = formattedAmount.replaceAllMapped(
              RegExp(r'^(\d+\.\d*?[1-9])0+$'),
              (match) => match.group(1)!,
            );
          }
        }
        break;
      case BitcoinCurrency.SAT:
        formattedAmount = formatter.format(amountSat);
        break;
    }
    if (addCurrencySymbol) {
      formattedAmount = currency.symbol + formattedAmount;
    } else if (addCurrencySuffix) {
      formattedAmount += ' ${currency.displayName}';
    }

    if (userInput) {
      return formattedAmount.replaceAll(RegExp(r"\s+\b|\b\s"), "");
    }

    return formattedAmount;
  }

  int parse(String amount, BitcoinCurrency currency) {
    switch (currency) {
      case BitcoinCurrency.BTC:
        return (double.parse(amount) * 100000000).round();
      case BitcoinCurrency.SAT:
        return int.parse(amount.replaceAll(RegExp('\\s+'), ''));
      default:
        return (double.parse(amount) * 100000000).round();
    }
  }

  int toSats(double amount, BitcoinCurrency currency) {
    switch (currency) {
      case BitcoinCurrency.BTC:
        return (amount * 100000000).round();
      case BitcoinCurrency.SAT:
        return amount.toInt();
      default:
        return (amount * 100000000).round();
    }
  }
}
