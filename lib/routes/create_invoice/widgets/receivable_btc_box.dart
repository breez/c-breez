import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/routes/create_invoice/widgets/fee_message.dart';
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
  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final currencyState = context.read<CurrencyBloc>().state;
    final accountState = context.read<AccountBloc>().state;
    final lspState = context.watch<LSPBloc>().state;
    final isChannelOpeningAvailable = lspState?.isChannelOpeningAvailable ?? false;
    final openingFeeParams = lspState?.lspInfo?.openingFeeParamsList.values.first;

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
            (!isChannelOpeningAvailable && accountState.maxInboundLiquiditySat <= 0)
                ? WarningBox(
                    boxPadding: const EdgeInsets.only(top: 8),
                    child: AutoSizeText(
                      texts.lsp_error_cannot_open_channel,
                      textAlign: TextAlign.center,
                    ),
                  )
                : AutoSizeText(
                    widget.receiveLabel ??
                        texts.invoice_receive_label(
                          currencyState.bitcoinCurrency.format((isChannelOpeningAvailable)
                              ? accountState.maxAllowedToReceiveSat
                              : accountState.maxInboundLiquiditySat),
                        ),
                    style: theme.textStyle,
                    maxLines: 1,
                    minFontSize: MinFontSize(context).minFontSize,
                  ),
            isChannelOpeningAvailable && accountState.isFeesApplicable
                ? FeeMessage(openingFeeParams: openingFeeParams!)
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
