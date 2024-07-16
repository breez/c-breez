import 'package:breez_translations/generated/breez_translations.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/models/currency.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/fiat_conversion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'currency_converter_dialog.dart';
import 'sat_amount_form_field_formatter.dart';

class AmountFormField extends TextFormField {
  final FiatConversion? fiatConversion;
  final BitcoinCurrency bitcoinCurrency;
  final String? Function(int amountSat) validatorFn;
  final BreezTranslations texts;

  AmountFormField({
    required this.bitcoinCurrency,
    this.fiatConversion,
    required this.validatorFn,
    required this.texts,
    required BuildContext context,
    Color? iconColor,
    Function(String amountSat)? returnFN,
    super.controller,
    Key? key,
    String? initialValue,
    super.focusNode,
    InputDecoration decoration = const InputDecoration(),
    super.style,
    TextAlign textAlign = TextAlign.start,
    int maxLines = 1,
    int? maxLength,
    super.onFieldSubmitted,
    super.onSaved,
    super.enabled,
    super.onChanged,
    bool? readOnly,
  }) : super(
          keyboardType: TextInputType.numberWithOptions(
            decimal: bitcoinCurrency != BitcoinCurrency.SAT,
          ),
          decoration: InputDecoration(
            labelText: texts.amount_form_denomination(
              bitcoinCurrency.displayName,
            ),
            suffixIcon: (readOnly ?? false)
                ? null
                : IconButton(
                    icon: Image.asset(
                      (fiatConversion?.currencyData != null)
                          ? fiatConversion!.logoPath
                          : "src/icon/btc_convert.png",
                      color: iconColor ?? theme.BreezColors.white[500],
                    ),
                    padding: const EdgeInsets.only(top: 21.0),
                    alignment: Alignment.bottomRight,
                    onPressed: () => showDialog(
                      useRootNavigator: false,
                      context: context,
                      builder: (_) => CurrencyConverterDialog(
                        context.read<CurrencyBloc>(),
                        returnFN ??
                            (value) => controller!.text = bitcoinCurrency.format(
                                  bitcoinCurrency.parse(value),
                                  includeCurrencySymbol: false,
                                  includeDisplayName: false,
                                ),
                        validatorFn,
                      ),
                    ),
                  ),
          ),
          inputFormatters: bitcoinCurrency != BitcoinCurrency.SAT
              ? [
                  FilteringTextInputFormatter.allow(bitcoinCurrency.whitelistedPattern),
                  TextInputFormatter.withFunction(
                    (_, newValue) => newValue.copyWith(
                      text: newValue.text.replaceAll(',', '.'),
                    ),
                  ),
                ]
              : [SatAmountFormFieldFormatter()],
          readOnly: readOnly ?? false,
        );

  @override
  FormFieldValidator<String?> get validator {
    return (value) {
      if (value!.isEmpty) {
        return texts.amount_form_insert_hint(
          bitcoinCurrency.displayName,
        );
      }
      try {
        int intAmount = bitcoinCurrency.parse(value);
        if (intAmount <= 0) {
          return texts.amount_form_error_invalid_amount;
        }
        return validatorFn(intAmount);
      } catch (err) {
        return texts.amount_form_error_invalid_amount;
      }
    };
  }
}
