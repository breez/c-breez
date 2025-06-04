import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:breez_translations/generated/breez_translations.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

const double itemHeight = 72.0;

class FiatCurrencyListTile extends StatelessWidget {
  final int index;
  final CurrencyState currencyState;
  final ScrollController scrollController;
  final Function(List<String> prefCurrencies) onChanged;

  const FiatCurrencyListTile({
    required this.index,
    required this.currencyState,
    required this.scrollController,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final BreezTranslations texts = context.texts();
    final ThemeData themeData = Theme.of(context);

    final FiatCurrency currencyData = currencyState.fiatCurrenciesData[index];
    final List<String> prefCurrencies = currencyState.preferredCurrencies.toList();

    String subtitle = currencyData.info.name;
    final List<LocalizedName> localizedName = currencyData.info.localizedName;
    if (localizedName.isNotEmpty) {
      for (LocalizedName localizedName in localizedName) {
        if (localizedName.locale == texts.locale) {
          subtitle = localizedName.name;
        }
      }
    }

    return CheckboxListTile(
      key: Key('tile-index-$index'),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Colors.white,
      checkColor: themeData.canvasColor,
      value: prefCurrencies.contains(currencyData.id),
      onChanged: (bool? checked) {
        if (checked == true) {
          prefCurrencies.add(currencyData.id);
          // center item in viewport
          if (scrollController.offset >= (itemHeight * (prefCurrencies.length - 1))) {
            scrollController.animateTo(
              ((2 * prefCurrencies.length - 1) * itemHeight - scrollController.position.viewportDimension) /
                  2,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 400),
            );
          }
        } else if (currencyState.preferredCurrencies.length != 1) {
          prefCurrencies.remove(currencyData.id);
        }
        onChanged(prefCurrencies);
      },
      subtitle: Text(subtitle, style: fiatConversionDescriptionStyle),
      title: RichText(
        text: TextSpan(
          text: currencyData.id,
          style: fiatConversionTitleStyle,
          children: <InlineSpan>[
            TextSpan(
              text: " (${currencyData.info.symbol?.grapheme ?? ""})",
              style: fiatConversionDescriptionStyle,
            ),
          ],
        ),
      ),
    );
  }
}
