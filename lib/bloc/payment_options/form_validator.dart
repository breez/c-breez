import 'package:breez_translations/breez_translations_locales.dart';

String? baseFeeValidator(
  String? value,
) {
  final texts = getSystemAppLocalizations();
  if (value == null) {
    return texts.payment_options_base_fee_label;
  }
  if (value.isEmpty) {
    return texts.payment_options_base_fee_label;
  }
  try {
    final newBaseFee = int.parse(value);
    if (newBaseFee < 0) {
      return texts.payment_options_base_fee_label;
    }
  } catch (e) {
    return texts.payment_options_base_fee_label;
  }
  return null;
}

String? proportionalFeeValidator(
  String? value,
) {
  final texts = getSystemAppLocalizations();
  if (value == null) {
    return texts.payment_options_proportional_fee_label;
  }
  if (value.isEmpty) {
    return texts.payment_options_proportional_fee_label;
  }
  try {
    final newProportionalFee = double.parse(value);
    if (newProportionalFee < 0.0) {
      return texts.payment_options_proportional_fee_label;
    }
  } catch (e) {
    return texts.payment_options_proportional_fee_label;
  }
  return null;
}
