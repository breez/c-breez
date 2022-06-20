import 'package:breez_sdk/sdk.dart';
import 'package:c_breez/models/currency.dart';
import 'package:c_breez/utils/fiat_conversion.dart';

class CurrencyState {
  final List<String> preferredCurrencies;
  final String fiatShortName;
  final String bitcoinTicker;
  final Map<String, double> exchangeRates;
  final List<FiatCurrency> fiatCurrenciesData;

  CurrencyState(
      {this.fiatCurrenciesData = const [],
      this.exchangeRates = const {},
      this.preferredCurrencies = const ["USD"],
      this.fiatShortName = "USD",
      this.bitcoinTicker = "SAT"});

  CurrencyState.initial() : this();

  CurrencyState copyWith(
      {List<FiatCurrency>? fiatCurrenciesData,
      Map<String, double>? exchangeRates,
      String? fiatShortName,
      String? bitcoinTicker,
      List<String>? preferredCurrencies}) {
    return CurrencyState(
        fiatCurrenciesData: fiatCurrenciesData ?? this.fiatCurrenciesData,
        exchangeRates: exchangeRates ?? this.exchangeRates,
        preferredCurrencies: preferredCurrencies ?? this.preferredCurrencies,
        fiatShortName: fiatShortName ?? this.fiatShortName,
        bitcoinTicker: bitcoinTicker ?? this.bitcoinTicker);
  }

  BitcoinCurrency get bitcoinCurrency =>
      BitcoinCurrency.fromTickerSymbol(bitcoinTicker);

  FiatCurrency? get fiatCurrency => fiatByShortName(fiatShortName);

  double? get fiatExchangeRate => exchangeRates[fiatShortName];

  bool get fiatEnabled => fiatCurrency != null && fiatExchangeRate != null;

  FiatCurrency? fiatByShortName(String name) {
    for (var fc in fiatCurrenciesData) {
      if (fc.shortName == name) {
        return fc;
      }
    }
    return null;
  }

  FiatConversion? fiatConversion() {
    final currency = fiatCurrency;
    final exchange = fiatExchangeRate;
    if (currency != null && exchange != null) {
      return FiatConversion(currency, exchange);
    } else {
      return null;
    }
  }

  CurrencyState.fromJson(Map<String, dynamic> json)
      : preferredCurrencies =
            (json['preferredCurrencies'] as List<dynamic>).cast<String>(),
        exchangeRates = (json['exchangeRates'] as Map<String, dynamic>)
            .cast<String, double>(),
        fiatCurrenciesData = [],
        fiatShortName = json['fiatShortName'],
        bitcoinTicker = json['bitcoinTicker'];

  Map<String, dynamic> toJson() => {
        'exchangeRates': exchangeRates,
        'preferredCurrencies': preferredCurrencies,
        'fiatShortName': fiatShortName,
        'bitcoinTicker': bitcoinTicker
      };
}
