import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/models/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentDetailsAmount extends StatelessWidget {
  final Payment paymentInfo;
  final AutoSizeGroup? labelAutoSizeGroup;
  final AutoSizeGroup? valueAutoSizeGroup;

  const PaymentDetailsAmount({
    super.key,
    required this.paymentInfo,
    this.labelAutoSizeGroup,
    this.valueAutoSizeGroup,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return Container(
      height: 36.0,
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: AutoSizeText(
              texts.payment_details_dialog_amount_title,
              style: themeData.primaryTextTheme.headline4,
              textAlign: TextAlign.left,
              maxLines: 1,
              group: labelAutoSizeGroup,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: BlocBuilder<CurrencyBloc, CurrencyState>(builder: (context, state) {
                final amountSats = BitcoinCurrency.fromTickerSymbol(
                  state.bitcoinTicker,
                ).format(paymentInfo.amountMsat ~/ 1000);
                return AutoSizeText(
                  paymentInfo.paymentType == PaymentType.Received
                      ? texts.payment_details_dialog_amount_positive(amountSats)
                      : texts.payment_details_dialog_amount_negative(amountSats),
                  style: themeData.primaryTextTheme.headline3,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  group: valueAutoSizeGroup,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
