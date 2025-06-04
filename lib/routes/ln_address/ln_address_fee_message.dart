import 'dart:math';

import 'package:breez_sdk/sdk.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/bloc/payment_options/payment_options_bloc.dart';
import 'package:c_breez/widgets/warning_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LnAddressFeeMessage extends StatelessWidget {
  const LnAddressFeeMessage();

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final accountState = context.read<AccountBloc>().state;
    final lspState = context.watch<LSPBloc>().state;
    final isChannelOpeningAvailable = lspState?.isChannelOpeningAvailable ?? false;
    final openingFeeParams = lspState?.lspInfo?.openingFeeParamsList.values.first;

    if (!isChannelOpeningAvailable && accountState.maxInboundLiquiditySat <= 0) {
      return WarningBox(
        boxPadding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              texts.lsp_error_cannot_open_channel,
              style: themeData.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

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
    // Proportional value is ppm(parts per million)
    final proportionalPercent = (openingFeeParams.proportional / (1000000 / 100)).toString();
    final liquiditySat = accountState.maxInboundLiquiditySat;
    final liquidityFormatted = currencyState.bitcoinCurrency.format(liquiditySat);
    final liquidityAboveMin = liquiditySat > 1;

    // Calculate the maximum receivable amount within the fee limit (in millisatoshis)
    final channelFeeLimitSat = paymentOptionsState.channelFeeLimitMsat ~/ 1000;
    // Calculate the maximum sendable amount (in sats)
    final maxSendableSat = maxReceivableSat(accountState, channelFeeLimitSat, openingFeeParams);
    final maxSendableFormatted = currencyState.bitcoinCurrency.format(maxSendableSat);

    // Get the minimum sendable amount (in sats), can not be less than 1 or more than maxSendable
    final minSendableSat = (liquidityAboveMin) ? 1 : openingFeeParams.minMsat.toInt() ~/ 1000;
    final minSendableAboveMin = minSendableSat >= 1;
    final minSendableFormatted = currencyState.bitcoinCurrency.format(minSendableSat);
    if (!minSendableAboveMin) {
      return "Minimum sendable amount can't be less than ${currencyState.bitcoinCurrency.format(1)}.";
    }
    if (minSendableSat > maxSendableSat) {
      return "Minimum sendable amount can't be greater than maximum sendable amount.";
    }
    final minFeeFormatted = currencyState.bitcoinCurrency.format(openingFeeParams.minMsat.toInt() ~/ 1000);

    final isFeeApplicable = maxSendableSat > liquiditySat;
    if (!isFeeApplicable) {
      // Send more than {minSendableSat} and up to {maxSendableSat} to this address.
      return texts.invoice_ln_address_channel_not_needed(minSendableFormatted, maxSendableFormatted);
    } else if (liquidityAboveMin) {
      // Send more than {minSendableSat} and up to {maxSendableSat} to this address. A setup fee of {proportionalPercent}% with a minimum of {minFeeFormatted}
      // will be applied for sending more than {liquiditySat}.
      return texts.invoice_ln_address_warning_with_min_fee_account_connected(
        minSendableFormatted,
        maxSendableFormatted,
        proportionalPercent,
        minFeeFormatted,
        liquidityFormatted,
      );
    } else {
      // Send more than {minSendableSat} and up to {maxSendableSat} to this address. A setup fee of {proportionalPercent}% with a minimum of {minSendableSat}
      // will be applied on the received amount.
      return texts.invoice_ln_address_warning_with_min_fee_account_not_connected(
        minSendableFormatted,
        maxSendableFormatted,
        proportionalPercent,
        minSendableFormatted,
      );
    }
  }

  int maxReceivableSat(AccountState account, int channelFeeLimitSat, OpeningFeeParams openingFeeParams) {
    // Treat fee limit feature as disabled when it's set to 0
    if (channelFeeLimitSat != 0) {
      int maxAllowedToReceiveSat = account.maxAllowedToReceiveSat;
      // Proportional value is ppm(parts per million)
      final proportional = openingFeeParams.proportional / (1000000);
      final maxReceivableSatFeeLimit = (proportional != 0.0 && channelFeeLimitSat != 0)
          ? min(maxAllowedToReceiveSat, channelFeeLimitSat.toDouble() ~/ proportional).toInt()
          : maxAllowedToReceiveSat;
      return max(account.maxInboundLiquiditySat, maxReceivableSatFeeLimit);
    } else {
      return account.maxInboundLiquiditySat;
    }
  }
}
