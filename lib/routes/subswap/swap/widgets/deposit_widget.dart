import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
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
    final lspInfo = context.read<LSPBloc>().state?.lspInfo;
    final openingFeeParams = widget.swap.channelOpeningFees;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AddressWidget(
          widget.swap.bitcoinAddress,
          backupJson: backupJson,
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

    final minFees = openingFeeParams.minMsat ~/ 1000;
    final minFeeAboveZero = minFees > 0;
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
    final setUpFee = (openingFeeParams.proportional / 10000).toString();
    final liquidity = currencyState.bitcoinCurrency.format(accountState.maxInboundLiquidity);
    final liquidityAboveZero = accountState.maxInboundLiquidity > 0;

    if (minFeeAboveZero && liquidityAboveZero) {
      // Send more than {minSats} and up to {maxSats} to this address. A setup fee of {setUpFee}% with a minimum of {minFee}
      // will be applied for sending more than {liquidity}.
      return texts.invoice_btc_address_warning_with_min_fee_account_connected(
        minSats,
        maxSats,
        setUpFee,
        minFeeFormatted,
        liquidity,
      );
    } else if (minFeeAboveZero && !liquidityAboveZero) {
      // Send more than {minSats} and up to {maxSats} to this address. A setup fee of {setUpFee}% with a minimum of {minFee}
      // will be applied on the received amount.
      return texts.invoice_btc_address_warning_with_min_fee_account_not_connected(
        minSats,
        maxSats,
        setUpFee,
        minFeeFormatted,
      );
    } else if (!minFeeAboveZero && liquidityAboveZero) {
      // Send more than {minSats} and up to {maxSats} to this address. A setup fee of {setUpFee}% will be applied
      // for sending more than {liquidity}.
      return texts.invoice_btc_address_warning_without_min_fee_account_connected(
        minSats,
        maxSats,
        setUpFee,
        liquidity,
      );
    } else {
      // Send more than {minSats} and up to {maxSats} to this address. A setup fee of {setUpFee}% will be applied
      // on the received amount.
      return texts.invoice_btc_address_warning_without_min_fee_account_not_connected(
        minSats,
        maxSats,
        setUpFee,
      );
    }
  }

  int _minAllowedDeposit(
    LspInformation? lspInfo,
    int? minAllowedDeposit,
  ) {
    final minFees = (lspInfo != null) ? lspInfo.openingFeeParamsMenu.values.first.minMsat ~/ 1000 : 0;
    if (minAllowedDeposit == null) return minFees;
    if (minFees > minAllowedDeposit) return minFees;
    return minAllowedDeposit;
  }
}
