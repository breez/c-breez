import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/models/currency.dart';
import 'package:c_breez/services/breez_server/server.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'models.dart';

class CurrencyBloc extends Cubit<CurrencyState> with HydratedMixin {
  final BreezServer _breezServer;

  CurrencyBloc(this._breezServer) : super(CurrencyState.initial()) {
    rootBundle.loadString('src/json/currencies.json').then((jsonCurrencies) {
      var fiatCurrencies = currencyDataFromJson(jsonCurrencies).values.toList();
      var sorted =
          _sortFiatConversionList(fiatCurrencies, state.preferredCurrencies);
      emit(state.copyWith(fiatCurrenciesData: sorted));
    });
    fetchExchangeRates();
  }

  void setFiatShortName(String fiaShortName) {
    emit(state.copyWith(fiatShortName: fiaShortName));
  }

  void setPreferredCurrencies(List<String> preferredCurrencies) {
    emit(state.copyWith(
        fiatCurrenciesData: _sortFiatConversionList(
            state.fiatCurrenciesData, preferredCurrencies),
        preferredCurrencies: preferredCurrencies,
        fiatShortName: preferredCurrencies[0]));
  }

  void setBitcoinTicker(String bitcoinTicker) {
    emit(state.copyWith(bitcoinTicker: bitcoinTicker));
  }

  Future<Map<String, double>> fetchExchangeRates() async {
    var rates = await _breezServer.rate();
    var ratesMap =
        rates.asMap().map((_, rate) => MapEntry(rate.coin, rate.value));
    emit(state.copyWith(exchangeRates: ratesMap));
    return ratesMap;
  }

  @override
  CurrencyState fromJson(Map<String, dynamic> json) {
    return CurrencyState.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(CurrencyState state) {
    return state.toJson();
  }

  List<FiatCurrency> _sortFiatConversionList(
      List<FiatCurrency> fiatCurrencies, List<String> preferredCurrencies) {
    var sorted = fiatCurrencies.toList();
    sorted.sort((f1, f2) {
      return f1.shortName.compareTo(f2.shortName);
    });

    // Then give precendence to the preferred items.
    for (var p in preferredCurrencies.reversed) {
      var preferredIndex = sorted.indexWhere((e) => e.shortName == p);
      if (preferredIndex >= 0) {
        var preferred = sorted[preferredIndex];
        sorted.removeAt(preferredIndex);
        sorted.insert(0, preferred);
      }
    }
    return sorted;
  }
}
