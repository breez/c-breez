import 'package:breez_sdk/breez_bridge.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class CurrencyBloc extends Cubit<CurrencyState> with HydratedMixin {
  final BreezBridge _breezLib;

  CurrencyBloc(this._breezLib) : super(CurrencyState.initial()) {
    _breezLib.listFiatCurrencies().then((fiatCurrencies) {
      var sorted =
          _sortFiatConversionList(fiatCurrencies, state.preferredCurrencies);
      emit(state.copyWith(fiatCurrenciesData: sorted));
    });
    fetchExchangeRates();
  }

  void setFiatId(String fiatId) {
    emit(state.copyWith(fiatId: fiatId));
  }

  void setPreferredCurrencies(List<String> preferredCurrencies) {
    emit(state.copyWith(
        fiatCurrenciesData: _sortFiatConversionList(
            state.fiatCurrenciesData, preferredCurrencies),
        preferredCurrencies: preferredCurrencies,
        fiatId: preferredCurrencies[0]));
  }

  void setBitcoinTicker(String bitcoinTicker) {
    emit(state.copyWith(bitcoinTicker: bitcoinTicker));
  }

  Future<Map<String, Rate>> fetchExchangeRates() async {
    var ratesMap = await _breezLib.fetchRates();
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
      return f1.id.compareTo(f2.id);
    });

    // Then give precedence to the preferred items.
    for (var p in preferredCurrencies.reversed) {
      var preferredIndex = sorted.indexWhere((e) => e.id == p);
      if (preferredIndex >= 0) {
        var preferred = sorted[preferredIndex];
        sorted.removeAt(preferredIndex);
        sorted.insert(0, preferred);
      }
    }
    return sorted;
  }
}
