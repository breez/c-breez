import 'package:breez_sdk/sdk.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/routes/subswap/swap/widgets/backup_script.dart';
import 'package:c_breez/routes/subswap/swap/widgets/subswap_dialog.dart';
import 'package:c_breez/widgets/address_widget.dart';
import 'package:c_breez/widgets/warning_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hex/hex.dart';

class DepositWidget extends StatefulWidget {
  final SwapInfo swap;

  const DepositWidget(this.swap, {super.key});

  @override
  State<DepositWidget> createState() => _DepositWidgetState();
}

class _DepositWidgetState extends State<DepositWidget> {
  late String backupJson;

  @override
  void initState() {
    super.initState();
    createBackupJsonStr();
  }

  void createBackupJsonStr() {
    try {
      backupJson = BackupScript(
        script: HEX.encode(widget.swap.script),
        privateKey: HEX.encode(widget.swap.privateKey),
      ).toString();
    } catch (e) {
      // TODO: Handle the case where backup script can't be encoded into a String
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final lspInfo = context.read<LSPBloc>().state?.lspInfo;
    final openingFeeParams = widget.swap.channelOpeningFees;
    final texts = context.texts();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AddressWidget(
          widget.swap.bitcoinAddress,
          title: texts.invoice_btc_address_deposit_address,
          footer: widget.swap.bitcoinAddress,
          onLongPress: () => showDialog(
            useRootNavigator: false,
            context: context,
            builder: (_) => SwapDialog(backupJson: backupJson),
          ),
        ),
        lspInfo != null && openingFeeParams != null
            ? WarningBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _sendMessage(context, lspInfo, openingFeeParams),
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  // TODO: Check if there are parts no longer needed with new library
  String _sendMessage(BuildContext context, LspInformation lspInfo, OpeningFeeParams openingFeeParams) {
    final accountState = context.read<AccountBloc>().state;
    final currencyState = context.read<CurrencyBloc>().state;
    int minAllowedDeposit = widget.swap.minAllowedDeposit;
    int maxAllowedDeposit = widget.swap.maxAllowedDeposit;

    final texts = context.texts();

    final minFees = openingFeeParams.minMsat.toInt() ~/ 1000;
    final minFeeAboveZero = minFees > 0;
    final minFeeFormatted = currencyState.bitcoinCurrency.format(minFees);
    final minSat = currencyState.bitcoinCurrency.format(
      _minAllowedDeposit(
        lspInfo,
        minAllowedDeposit,
      ),
      includeDisplayName: true,
    );
    final maxSat = currencyState.bitcoinCurrency.format(
      maxAllowedDeposit,
      includeDisplayName: true,
    );
    final setUpFee = (openingFeeParams.proportional / 10000).toString();
    final liquidity = currencyState.bitcoinCurrency.format(accountState.maxInboundLiquiditySat);
    final liquidityAboveZero = accountState.maxInboundLiquiditySat > 0;
    final showFeeMessage = accountState.isFeesApplicable;

    if (!showFeeMessage) {
      // Send more than {minSat} and up to {maxSat} to this address. This address can be used only once.
      return texts.invoice_btc_address_channel_not_needed(minFeeFormatted, maxSat);
    } else if (minFeeAboveZero && liquidityAboveZero) {
      // Send more than {minSat} and up to {maxSat} to this address. A setup fee of {setUpFee}% with a minimum of {minFee}
      // will be applied for sending more than {liquidity}. This address can be used only once.
      return texts.invoice_btc_address_warning_with_min_fee_account_connected(
        minSat,
        maxSat,
        setUpFee,
        minFeeFormatted,
        liquidity,
      );
    } else if (minFeeAboveZero && !liquidityAboveZero) {
      // Send more than {minSat} and up to {maxSat} to this address. A setup fee of {setUpFee}% with a minimum of {minFee}
      // will be applied on the received amount.
      return texts.invoice_btc_address_warning_with_min_fee_account_not_connected(
        minSat,
        maxSat,
        setUpFee,
        minFeeFormatted,
      );
    } else if (!minFeeAboveZero && liquidityAboveZero) {
      // Send more than {minSat} and up to {maxSat} to this address. A setup fee of {setUpFee}% will be applied
      // for sending more than {liquidity}.
      return texts.invoice_btc_address_warning_without_min_fee_account_connected(
        minSat,
        maxSat,
        setUpFee,
        liquidity,
      );
    } else {
      // Send more than {minSat} and up to {maxSat} to this address. A setup fee of {setUpFee}% will be applied
      // on the received amount.
      return texts.invoice_btc_address_warning_without_min_fee_account_not_connected(
        minSat,
        maxSat,
        setUpFee,
      );
    }
  }

  int _minAllowedDeposit(
    LspInformation? lspInfo,
    int? minAllowedDeposit,
  ) {
    final minFees = (lspInfo != null) ? lspInfo.openingFeeParamsList.values.first.minMsat.toInt() ~/ 1000 : 0;
    if (minAllowedDeposit == null) return minFees;
    if (minFees > minAllowedDeposit) return minFees;
    return minAllowedDeposit;
  }
}
