import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_sdk/native_toolkit.dart';

class FiatService {
  final LightningToolkit _lightningToolkit = getNativeToolkit();

  Future<Map<String, Rate>> fetchRates() async {
    final rates = await _lightningToolkit.fetchRates();
    return rates.fold<Map<String, Rate>>({}, (map, rate) {
      map[rate.coin] = rate;
      return map;
    });
  }

  Future<Map<String, FiatCurrency>> fiatCurrencies() async {
    final currencies = await _lightningToolkit.listFiatCurrencies();
    return currencies.fold<Map<String, FiatCurrency>>({}, (map, currency) {
      map[currency.id] = currency;
      return map;
    });
  }
}
