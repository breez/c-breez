import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/models/currency.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/fiat_conversion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'currency_converter_dialog.dart';
import 'sat_amount_form_field_formatter.dart';

class AmountFormField extends TextFormField {
  final FiatConversion? fiatConversion;
  final BitcoinCurrency bitcoinCurrency;
  final String? Function(int amount) validatorFn;
  final AppLocalizations texts;

  AmountFormField({
    required this.bitcoinCurrency,
    this.fiatConversion,
    required this.validatorFn,
    required this.texts,
    required BuildContext context,
    Color? iconColor,
    Function(String amount)? returnFN,
    TextEditingController? controller,
    Key? key,
    String? initialValue,
    FocusNode? focusNode,
    InputDecoration decoration = const InputDecoration(),
    TextStyle? style,
    TextAlign textAlign = TextAlign.start,
    int maxLines = 1,
    int? maxLength,
    ValueChanged<String>? onFieldSubmitted,
    FormFieldSetter<String>? onSaved,
    bool? enabled,
    ValueChanged<String>? onChanged,
    bool? readOnly,
  }) : super(
          focusNode: focusNode,
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
                            (value) =>
                                controller!.text = bitcoinCurrency.format(
                                  bitcoinCurrency.parse(value),
                                  includeCurrencySymbol: false,
                                  includeDisplayName: false,
                                ),
                        validatorFn,
                      ),
                    ),
                  ),
          ),
          style: style,
          enabled: enabled,
          controller: controller,
          inputFormatters: bitcoinCurrency != BitcoinCurrency.SAT
              ? [FilteringTextInputFormatter.allow(RegExp(r'\d+\.?\d*'))]
              : [SatAmountFormFieldFormatter()],
          onFieldSubmitted: onFieldSubmitted,
          onSaved: onSaved,
          onChanged: onChanged,
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
