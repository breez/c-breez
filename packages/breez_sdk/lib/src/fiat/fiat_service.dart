import 'dart:convert';

import 'package:breez_sdk/src/breez_server/generated/breez.pbgrpc.dart';
import 'package:breez_sdk/src/breez_server/server.dart';
import 'package:flutter/services.dart';

class FiatService {
  Future<Map<String, double>> fetchRates() async {
    final server = await BreezServer.createWithDefaultConfig();
    var channel = await server.createServerChannel();
    var infoClient = InformationClient(channel, options: server.defaultCallOptions);
    var response = await infoClient.rates(RatesRequest());
    return response.rates.asMap().map((_, rate) => MapEntry(rate.coin, rate.value));
  }

  Future<Map<String, FiatCurrency>> fiatCurrencies() async {
    return rootBundle.loadString('packages/breez_sdk/assets/currencies.json').then((jsonCurrencies) {
      final Map<String, dynamic> decodedJson = json.decode(jsonCurrencies);
      final currencyMap = <String, FiatCurrency>{};
      for (var shortName in decodedJson.keys) {
        final fiat = FiatCurrency.fromJson(shortName, decodedJson[shortName]);
        currencyMap[shortName] = fiat;
      }
      return currencyMap;
    });
  }
}

class FiatCurrency {
  String name;
  Map<String, String> localizedName;
  String shortName;
  int fractionSize;
  String symbol;
  bool rtl;
  int position;
  int spacing;
  Map<String, FiatCurrency> localeOverrides = {};

  FiatCurrency({
    required this.name,
    required this.localizedName,
    required this.shortName,
    required this.fractionSize,
    required this.symbol,
    required this.rtl,
    required this.position,
    required this.spacing,
  });

  FiatCurrency localeAware(String languageTag, String languageCode) {
    if (localeOverrides.isEmpty) return this;
    if (localeOverrides.containsKey(languageTag)) {
      return localeOverrides[languageTag]!;
    }
    if (localeOverrides.containsKey(languageCode)) {
      return localeOverrides[languageCode]!;
    }
    return this;
  }

  FiatCurrency copyWith({int? position, int? spacing}) {
    return FiatCurrency(
        name: name,
        localizedName: localizedName,
        shortName: shortName,
        fractionSize: fractionSize,
        symbol: symbol,
        rtl: rtl,
        position: position ?? this.position,
        spacing: spacing ?? this.spacing);
  }

  factory FiatCurrency.fromJson(String shortName, Map<String, dynamic> json) {
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

    fiatCurrency.localeOverrides = <String, FiatCurrency>{};
    final localOverriedesSettings = json["localeOverrides"];
    if (localOverriedesSettings != null) {
      final overridesMap = localOverriedesSettings as Map<String, dynamic>;
      for (var localeKey in overridesMap.keys) {
        final position = overridesMap[localeKey]["symbol"] != null ? json["symbol"]["position"] : null;
        final spacing = overridesMap[localeKey]["spacing"] ?? 0;
        fiatCurrency.localeOverrides[localeKey] = fiatCurrency.copyWith(position: position, spacing: spacing);
      }
    }

    return fiatCurrency;
  }
}
