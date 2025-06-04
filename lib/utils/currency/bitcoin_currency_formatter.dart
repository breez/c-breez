import 'package:c_breez/models/currency.dart';
import 'package:c_breez/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('BitcoinCurrencyFormatter');

/// Utility class for formatting and parsing Bitcoin amounts in different denominations
class BitcoinCurrencyFormatter {
  /// Number formatter with custom spacing for satoshi amounts
  final NumberFormat formatter;

  /// Creates a new BitcoinCurrencyFormatter
  BitcoinCurrencyFormatter() : formatter = CurrencyFormatter().getFormatter();

  /// Formats a Bitcoin amount according to the specified currency unit
  ///
  /// [satoshies] The amount in satoshis
  /// [currency] The Bitcoin currency unit (BTC or SAT)
  /// [addCurrencySuffix] Whether to add the currency suffix (e.g., "BTC")
  /// [addCurrencySymbol] Whether to add the currency symbol (e.g., "₿")
  /// [removeTrailingZeros] Whether to remove trailing zeros for BTC amounts
  /// [userInput] Whether this is for user input (removes spaces)
  /// Returns a formatted string representation of the amount
  String format(
    int satoshies,
    BitcoinCurrency currency, {
    bool addCurrencySuffix = true,
    bool addCurrencySymbol = false,
    bool removeTrailingZeros = false,
    bool userInput = false,
  }) {
    _logger.fine('Formatting $satoshies satoshis in ${currency.displayName}');
    String formattedAmount = formatter.format(satoshies);

    switch (currency) {
      case BitcoinCurrency.BTC:
        final double amountInBTC = satoshies.toInt() / PaymentConstants.satoshisPerBitcoin;
        formattedAmount = amountInBTC.toStringAsFixed(8);

        if (removeTrailingZeros) {
          if (amountInBTC.truncateToDouble() == amountInBTC) {
            formattedAmount = amountInBTC.toInt().toString();
          } else {
            formattedAmount = formattedAmount.replaceAllMapped(
              RegExp(r'^(\d+\.\d*?[1-9])0+$'),
              (Match match) => match.group(1)!,
            );
          }
        }
        break;
      case BitcoinCurrency.SAT:
        formattedAmount = formatter.format(satoshies);
        break;
    }

    if (addCurrencySymbol) {
      formattedAmount = currency.symbol + formattedAmount;
    } else if (addCurrencySuffix) {
      formattedAmount += ' ${currency.displayName}';
    }

    if (userInput) {
      return formattedAmount.replaceAll(RegExp(r'\s+\b|\b\s'), '');
    }

    return formattedAmount;
  }

  /// Parses a formatted string amount into satoshis
  ///
  /// [amount] The formatted amount string
  /// [currency] The Bitcoin currency unit (BTC or SAT)
  /// Returns the amount in satoshis
  int parse(String amount, BitcoinCurrency currency) {
    _logger.fine('Parsing "$amount" in ${currency.displayName}');

    switch (currency) {
      case BitcoinCurrency.BTC:
        return (double.parse(amount) * PaymentConstants.satoshisPerBitcoin).round();
      case BitcoinCurrency.SAT:
        return int.parse(amount.replaceAll(RegExp(r'\s+'), ''));
      default:
        return (double.parse(amount) * PaymentConstants.satoshisPerBitcoin).round();
    }
  }

  /// Converts an amount in the specified currency to satoshis
  ///
  /// [amount] The amount in the specified currency
  /// [currency] The Bitcoin currency unit (BTC or SAT)
  /// Returns the amount in satoshis
  int toSats(double amount, BitcoinCurrency currency) {
    _logger.fine('Converting $amount ${currency.displayName} to satoshis');

    switch (currency) {
      case BitcoinCurrency.BTC:
        return (amount * PaymentConstants.satoshisPerBitcoin).round();
      case BitcoinCurrency.SAT:
        return amount.toInt();
      default:
        return (amount * PaymentConstants.satoshisPerBitcoin).round();
    }
  }
}
