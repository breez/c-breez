import 'package:breez_sdk/sdk.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class CurrencyBloc extends Cubit<CurrencyState> with HydratedMixin {
  final FiatService _fiatService;

  CurrencyBloc(this._fiatService) : super(CurrencyState.initial()) {  
    _fiatService.fiatCurrencies().then((jsonCurrencies) {
      var fiatCurrencies = jsonCurrencies.values.toList();
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
    var ratesMap = await _fiatService.fetchRates();   
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

    // Then give precedence to the preferred items.
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
