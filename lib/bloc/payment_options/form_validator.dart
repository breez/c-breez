import 'package:breez_translations/breez_translations_locales.dart';

String? exemptFeeValidator(
  String? value,
) {
  final texts = getSystemAppLocalizations();
  if (value == null) {
    return texts.payment_options_exemptfee_label;
  }
  if (value.isEmpty) {
    return texts.payment_options_exemptfee_label;
  }
  try {
    final newExemptFee = int.parse(value);
    if (newExemptFee < 0) {
      return texts.payment_options_exemptfee_label;
    }
  } catch (e) {
    return texts.payment_options_exemptfee_label;
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

String? autoChannelSetupFeeLimitValidator(
  String? value,
) {
  final texts = getSystemAppLocalizations();
  if (value == null) {
    return texts.payment_options_auto_channel_setup_fee_limit_label;
  }
  if (value.isEmpty) {
    return texts.payment_options_auto_channel_setup_fee_limit_label;
  }
  try {
    final newChannelFee = int.parse(value);
    if (newChannelFee < 0) {
      return texts.payment_options_auto_channel_setup_fee_limit_label;
    }
  } catch (e) {
    return texts.payment_options_auto_channel_setup_fee_limit_label;
  }
  return null;
}
