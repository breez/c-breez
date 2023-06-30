import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/payment_error.dart';
import 'package:c_breez/models/currency.dart';
import 'package:c_breez/routes/withdraw_funds/withdraw_funds_address_page.dart';
import 'package:c_breez/utils/payment_validator.dart';
import 'package:c_breez/widgets/amount_form_field/amount_form_field.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';

final _log = FimberLog("WithdrawAmountTextFormField");

class WithdrawAmountTextFormField extends AmountFormField {
  WithdrawAmountTextFormField({
    super.key,
    required BitcoinCurrency bitcoinCurrency,
    required BuildContext context,
    required TextEditingController controller,
    required bool withdrawMaxValue,
    required WithdrawFundsPolicy policy,
  }) : super(
          controller: controller,
          texts: context.texts(),
          context: context,
          readOnly: policy.withdrawKind == WithdrawKind.unexpected_funds || withdrawMaxValue,
          bitcoinCurrency: bitcoinCurrency,
          validatorFn: (amount) {
            _log.v("Validator called for $amount");
            return PaymentValidator(
              currency: bitcoinCurrency,
              texts: context.texts(),
              validatePayment: (amount, outgoing, {channelMinimumFee}) {
                _log.v("Validating $amount $policy");
                if (amount < policy.minValue) {
                  throw PaymentBelowLimitError(policy.minValue);
                }
                if (amount > policy.maxValue) {
                  throw PaymentExceededLimitError(policy.maxValue);
                }
              },
            ).validateOutgoing(amount);
          },
        );
}
