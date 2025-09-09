import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<bool?> promptLSPFeeAndNavigate(BuildContext context, OpeningFeeParams longestValidOpeningFeeParams) {
  final themeData = Theme.of(context);
  final texts = context.texts();

  return promptAreYouSure(
    context,
    texts.lsp_fee_warning_title,
    Text(
      formatFeeMessage(context, longestValidOpeningFeeParams),
      style: themeData.dialogTheme.contentTextStyle,
    ),
    cancelText: texts.lsp_fee_warning_action_cancel,
    okText: texts.lsp_fee_warning_action_ok,
  );
}

String formatFeeMessage(BuildContext context, OpeningFeeParams openingFeeParams) {
  final texts = context.texts();
  final currencyState = context.read<CurrencyBloc>().state;
  final accountState = context.read<AccountBloc>().state;

  final minFeeSat = openingFeeParams.minMsat ~/ 1000;
  final minFeeFormatted = currencyState.bitcoinCurrency.format(minFeeSat);
  final minFeeAboveZero = minFeeSat > 0;
  final setUpFee = (openingFeeParams.proportional / 10000).toString();
  final liquidity = currencyState.bitcoinCurrency.format(accountState.maxInboundLiquiditySat);
  final liquidityAboveZero = accountState.maxInboundLiquiditySat > 0;

  if (minFeeAboveZero && liquidityAboveZero) {
    // A setup fee of {setUpFee}% with a minimum of {minFeeSat} will be applied for receiving more than {liquidity}
    return texts.moonpay_fee_warning_with_min_fee_account_connected(setUpFee, minFeeFormatted, liquidity);
  } else if (!minFeeAboveZero && liquidityAboveZero) {
    // A setup fee of {setUpFee}% will be applied for receiving more than {liquidity}.
    return texts.moonpay_fee_warning_without_min_fee_account_connected(setUpFee, liquidity);
  } else if (minFeeAboveZero && !liquidityAboveZero) {
    // A setup fee of {setUpFee}% with a minimum of {minFeeSat} will be applied on the received amount.
    return texts.moonpay_fee_warning_with_min_fee_account_not_connected(setUpFee, minFeeFormatted);
  } else {
    // A setup fee of {setUpFee}% will be applied on the received amount.
    return texts.moonpay_fee_warning_without_min_fee_account_not_connected(setUpFee);
  }
}
