import 'dart:math';

import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/bloc/payment_options/payment_options_bloc.dart';
import 'package:c_breez/widgets/warning_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LnFeeMessage extends StatelessWidget {
  const LnFeeMessage();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final lspState = context.watch<LSPBloc>().state;
    final isChannelOpeningAvailable = lspState?.isChannelOpeningAvailable ?? false;
    final openingFeeParams = lspState?.lspInfo?.openingFeeParamsList.values.first;

    return isChannelOpeningAvailable
        ? WarningBox(
            boxPadding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatFeeMessage(context, openingFeeParams!),
                  style: themeData.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        : const SizedBox();
  }

  String _formatFeeMessage(BuildContext context, OpeningFeeParams openingFeeParams) {
    final texts = context.texts();
    final currencyState = context.read<CurrencyBloc>().state;
    final accountState = context.read<AccountBloc>().state;
    final paymentOptionsState = context.read<PaymentOptionsBloc>().state;

    final minFee = openingFeeParams.minMsat ~/ 1000;
    final minFeeFormatted = currencyState.bitcoinCurrency.format(minFee);
    final minFeeAboveZero = minFee > 0;
    final setUpFee = (openingFeeParams.proportional / 10000).toString();
    final liquidity = currencyState.bitcoinCurrency.format(
      accountState.maxInboundLiquidity,
    );
    final liquidityAboveZero = accountState.maxInboundLiquidity > 0;

    final channelFeeLimitSat = paymentOptionsState.channelFeeLimitMsat ~/ 1000;
    final maxFee = maxReceivableSat(accountState, channelFeeLimitSat, openingFeeParams);
    final maxFeeFormatted = currencyState.bitcoinCurrency.format(maxFee);
    final isFeesApplicable = maxFee > accountState.maxInboundLiquidity;

    if (!isFeesApplicable) {
      // Send more than {minSats} and up to {maxSats} to this address. This address can be used only once.
      return texts.invoice_btc_address_channel_not_needed(minFeeFormatted, maxFeeFormatted);
    } else if (minFeeAboveZero && liquidityAboveZero) {
      // Send more than {minSats} and up to {maxSats} to this address. A setup fee of {setUpFee}% with a minimum of {minFee}
      // will be applied for sending more than {liquidity}. This address can be used only once.
      return texts.invoice_btc_address_warning_with_min_fee_account_connected(
        minFeeFormatted,
        maxFeeFormatted,
        setUpFee,
        minFeeFormatted,
        liquidity,
      );
    } else if (minFeeAboveZero && !liquidityAboveZero) {
      // Send more than {minSats} and up to {maxSats} to this address. A setup fee of {setUpFee}% with a minimum of {minFee}
      // will be applied on the received amount.
      return texts.invoice_btc_address_warning_with_min_fee_account_not_connected(
        minFeeFormatted,
        maxFeeFormatted,
        setUpFee,
        minFeeFormatted,
      );
    } else if (!minFeeAboveZero && liquidityAboveZero) {
      // Send more than {minSats} and up to {maxSats} to this address. A setup fee of {setUpFee}% will be applied
      // for sending more than {liquidity}.
      return texts.invoice_btc_address_warning_without_min_fee_account_connected(
        minFeeFormatted,
        maxFeeFormatted,
        setUpFee,
        liquidity,
      );
    } else {
      // Send more than {minSats} and up to {maxSats} to this address. A setup fee of {setUpFee}% will be applied
      // on the received amount.
      return texts.invoice_btc_address_warning_without_min_fee_account_not_connected(
        minFeeFormatted,
        maxFeeFormatted,
        setUpFee,
      );
    }
  }

  int maxReceivableSat(
    AccountState account,
    int channelFeeLimitSat,
    OpeningFeeParams openingFeeParams,
  ) {
    if (channelFeeLimitSat != 0) {
      int maxAllowedToReceiveSat = account.maxAllowedToReceive;
      final proportionalPercent = openingFeeParams.proportional / 1000000;
      final maxReceivableSatFeeLimit = (proportionalPercent != 0.0 && channelFeeLimitSat != 0)
          ? min(maxAllowedToReceiveSat, channelFeeLimitSat.toDouble() ~/ proportionalPercent).toInt()
          : maxAllowedToReceiveSat;
      return max(account.maxInboundLiquidity, maxReceivableSatFeeLimit);
    } else {
      return account.maxInboundLiquidity;
    }
  }
}
