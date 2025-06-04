import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/payment_error.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/routes/withdraw/model/withdraw_funds_model.dart';
import 'package:c_breez/utils/utils.dart';
import 'package:c_breez/widgets/amount_form_field/amount_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger("WithdrawFundsAmountTextFormField");

class WithdrawFundsAmountTextFormField extends AmountFormField {
  WithdrawFundsAmountTextFormField({
    super.key,
    required super.bitcoinCurrency,
    required super.context,
    required TextEditingController super.controller,
    required bool withdrawMaxValue,
    required WithdrawFundsPolicy policy,
    required int maxPayableSat,
  }) : super(
         texts: context.texts(),
         readOnly: policy.withdrawKind == WithdrawKind.unexpected_funds || withdrawMaxValue,
         validatorFn: (paymentAmountSat) {
           _log.info("Validator called for $paymentAmountSat");
           return PaymentValidator(
             currency: bitcoinCurrency,
             texts: context.texts(),
             channelCreationPossible: context.read<LSPBloc>().state?.isChannelOpeningAvailable ?? false,
             validatePayment: (amountSat, outgoing, channelCreationPossible, {channelMinimumFeeSat}) {
               _log.info("Validating $amountSat $policy");
               if (amountSat < policy.minValue) {
                 throw PaymentBelowLimitError(policy.minValue);
               }
               if (amountSat > policy.maxValue) {
                 throw PaymentExceededLimitError(policy.maxValue);
               }
               if (amountSat > maxPayableSat) {
                 throw const InsufficientLocalBalanceError();
               }
             },
           ).validateOutgoing(paymentAmountSat);
         },
       );
}
