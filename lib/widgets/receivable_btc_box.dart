import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_state.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/min_font_size.dart';
import 'package:c_breez/widgets/warning_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReceivableBTCBox extends StatefulWidget {
  final String? receiveLabel;
  final void Function()? onTap;

  const ReceivableBTCBox({
    super.key,
    this.receiveLabel,
    this.onTap,
  });

  @override
  State<StatefulWidget> createState() {
    return ReceivableBTCBoxState();
  }
}

class ReceivableBTCBoxState extends State<ReceivableBTCBox> {
  late final texts = context.texts();
  late final currencyState = context.read<CurrencyBloc>().state;
  late final accountState = context.read<AccountBloc>().state;
  late final lspState = context.read<LSPBloc>().state;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 164,
      padding: const EdgeInsets.only(top: 16.0),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              widget.receiveLabel ??
                  texts.invoice_receive_label(
                    currencyState.bitcoinCurrency.format(
                      lspState!.isChannelOpeningAvailiable
                          ? accountState.maxAllowedToReceive
                          : accountState.maxInboundLiquidity,
                    ),
                  ),
              style: theme.textStyle,
              maxLines: 1,
              minFontSize: MinFontSize(context).minFontSize,
            ),
            accountState.isFeesApplicable ? FeeMessage() : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class FeeMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return BlocBuilder<LSPBloc, LspState?>(builder: (context, lspState) {
      final lspInfo = lspState?.lspInfo;
      return lspInfo != null && lspInfo.openingFeeParamsList.values.isNotEmpty
          ? WarningBox(
              boxPadding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formatFeeMessage(context, lspInfo.openingFeeParamsList.values.first),
                    style: themeData.textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : const SizedBox();
    });
  }

  String formatFeeMessage(BuildContext context, OpeningFeeParams openingFeeParams) {
    final texts = context.texts();
    final currencyState = context.read<CurrencyBloc>().state;
    final accountState = context.read<AccountBloc>().state;

    final minFee = openingFeeParams.minMsat ~/ 1000;
    final minFeeFormatted = currencyState.bitcoinCurrency.format(minFee);
    final minFeeAboveZero = minFee > 0;
    final setUpFee = (openingFeeParams.proportional / 10000).toString();
    final liquidity = currencyState.bitcoinCurrency.format(
      accountState.maxInboundLiquidity,
    );
    final liquidityAboveZero = accountState.maxInboundLiquidity > 0;

    if (minFeeAboveZero && liquidityAboveZero) {
      // A setup fee of {setUpFee}% with a minimum of {minFee} will be applied for receiving more than {liquidity}
      return texts.invoice_ln_address_warning_with_min_fee_account_connected(
        setUpFee,
        minFeeFormatted,
        liquidity,
      );
    } else if (!minFeeAboveZero && liquidityAboveZero) {
      // A setup fee of {setUpFee}% will be applied for receiving more than {liquidity}.
      return texts.invoice_ln_address_warning_without_min_fee_account_connected(
        setUpFee,
        liquidity,
      );
    } else if (minFeeAboveZero && !liquidityAboveZero) {
      // A setup fee of {setUpFee}% with a minimum of {minFee} will be applied on the received amount.
      return texts.invoice_ln_address_warning_with_min_fee_account_not_connected(
        setUpFee,
        minFeeFormatted,
      );
    } else {
      // A setup fee of {setUpFee}% will be applied on the received amount.
      return texts.invoice_ln_address_warning_without_min_fee_account_not_connected(
        setUpFee,
      );
    }
  }
}
