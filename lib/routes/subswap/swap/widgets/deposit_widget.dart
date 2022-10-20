import 'dart:convert';

import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/routes/subswap/swap/widgets/backup_script.dart';
import 'package:c_breez/widgets/warning_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hex/hex.dart';

import 'address_widget.dart';

class DepositWidget extends StatefulWidget {
  final SwapInfo swap;

  const DepositWidget(this.swap, {Key? key}) : super(key: key);

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
    final lspInfo = context.read<LSPBloc>().state;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AddressWidget(
          widget.swap.bitcoinAddress,
          backupJson: backupJson,
        ),
        lspInfo == null
            ? const SizedBox()
            : WarningBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _sendMessage(context, lspInfo),
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  // TODO: Check if there are parts no longer needed with new library
  String _sendMessage(BuildContext context, LspInformation? lspInfo) {
    final accountState = context.read<AccountBloc>().state;
    final currencyState = context.read<CurrencyBloc>().state;
    int minAllowedDeposit = widget.swap.minAllowedDeposit;
    int maxAllowedDeposit = widget.swap.maxAllowedDeposit;

    final texts = context.texts();

    final minFees =
        (lspInfo != null) ? lspInfo.channelMinimumFeeMsat ~/ 1000 : 0;
    final showMinFeeMessage = minFees > 0;
    final minFeeFormatted = currencyState.bitcoinCurrency.format(minFees);
    final minSats = currencyState.bitcoinCurrency.format(
      _minAllowedDeposit(
        lspInfo,
        minAllowedDeposit,
      ),
      includeDisplayName: true,
    );
    final maxSats = currencyState.bitcoinCurrency.format(
      maxAllowedDeposit,
      includeDisplayName: true,
    );
    final setUpFee = (lspInfo!.channelFeePermyriad / 100).toString();
    final liquidity =
        currencyState.bitcoinCurrency.format(accountState.maxInboundLiquidity);

    if (showMinFeeMessage) {
      return texts.invoice_btc_address_warning_with_min_fee_account_connected(
        minSats,
        maxSats,
        setUpFee,
        minFeeFormatted,
        liquidity,
      );
    } else if (!showMinFeeMessage) {
      return texts
          .invoice_btc_address_warning_without_min_fee_account_connected(
        minSats,
        maxSats,
        setUpFee,
        liquidity,
      );
    }
    return "";
  }

  int _minAllowedDeposit(
    LspInformation? lspInfo,
    int? minAllowedDeposit,
  ) {
    final minFees =
        (lspInfo != null) ? lspInfo.channelMinimumFeeMsat ~/ 1000 : 0;
    if (minAllowedDeposit == null) return minFees;
    if (minFees > minAllowedDeposit) return minFees;
    return minAllowedDeposit;
  }
}
