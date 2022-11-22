import 'package:auto_size_text/auto_size_text.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
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
                      accountState.maxAllowedToReceive,
                    ),
                  ),
              style: theme.textStyle,
              maxLines: 1,
              minFontSize: MinFontSize(context).minFontSize,
            ),
            FeeMessage(),
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
    final lspInformation = context.read<LSPBloc>().state;

    return lspInformation == null
        ? const SizedBox()
        : WarningBox(
            boxPadding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formatFeeMessage(context),
                  style: themeData.textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
  }

  String formatFeeMessage(BuildContext context) {
    final texts = context.texts();
    final currencyState = context.read<CurrencyBloc>().state;
    final accountState = context.read<AccountBloc>().state;
    final lspInfo = context.read<LSPBloc>().state!;

    final connected = accountState.status == AccountStatus.CONNECTED;
    final minFee = lspInfo.channelMinimumFeeMsat ~/ 1000;
    final minFeeFormatted = currencyState.bitcoinCurrency.format(minFee);
    final showMinFeeMessage = minFee > 0;
    final setUpFee = (lspInfo.channelFeePermyriad / 100).toString();
    final liquidity = currencyState.bitcoinCurrency.format(
      connected ? accountState.maxInboundLiquidity : 0,
    );

    if (connected && showMinFeeMessage) {
      return texts.invoice_ln_address_warning_with_min_fee_account_connected(
        setUpFee,
        minFeeFormatted,
        liquidity,
      );
    } else if (connected && !showMinFeeMessage) {
      return texts.invoice_ln_address_warning_without_min_fee_account_connected(
        setUpFee,
        liquidity,
      );
    } else if (!connected && showMinFeeMessage) {
      return texts
          .invoice_ln_address_warning_with_min_fee_account_not_connected(
        setUpFee,
        minFeeFormatted,
      );
    } else {
      return texts
          .invoice_ln_address_warning_without_min_fee_account_not_connected(
        setUpFee,
      );
    }
  }
}
