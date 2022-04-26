import 'dart:convert';

import 'package:c_breez/models/currency.dart';

Map<String, FiatCurrency> currencyDataFromJson(String str) =>
    Map.from(json.decode(str))
        .map((k, v) => MapEntry<String, FiatCurrency>(k, fromJson(k, v)));

Map<String, FiatCurrency> _fiatCurrenciesOverrideFromJson(
  FiatCurrency base,
  Map<String, dynamic>? src,
) {
  if (src == null || src.isEmpty) return {};
  return src.map((locale, json) => MapEntry<String, FiatCurrency>(
        locale,
        fromJsonAndBase(base, json),
      ));
}

FiatCurrency fromJson(String shortName, Map<String, dynamic> json) {
  final fiatCurrency = FiatCurrency(
    name: json["name"],
    localizedName: json["localized_name"]?.map<String, String>(
          (lang, name) => MapEntry<String, String>(lang, name),
        ) ??
        {},
    shortName: shortName,
    fractionSize: json["fractionSize"] ?? 0,
    symbol: json["symbol"] != null ? json["symbol"]["grapheme"] : shortName,
    rtl: json["symbol"] != null ? json["symbol"]["rtl"] : false,
    position: json["symbol"] != null ? json["symbol"]["position"] ?? 0 : 0,
    spacing: json["spacing"] ?? 1,
  );
  final localeOverrides = _fiatCurrenciesOverrideFromJson(
    fiatCurrency,
    json["localeOverrides"],
  );
  fiatCurrency.localeOverrides = localeOverrides;
  return fiatCurrency;
}

FiatCurrency fromJsonAndBase(
  FiatCurrency base,
  Map<String, dynamic> json,
) {
  return FiatCurrency(
    name: base.name,
    localizedName: base.localizedName,
    shortName: base.shortName,
    fractionSize: base.fractionSize,
    symbol: base.symbol,
    rtl: base.rtl,
    position: json["symbol"] != null ? json["symbol"]["position"] : null,
    spacing: json["spacing"] ?? 0,
  );
}
