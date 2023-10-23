import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/routes/subswap/swap/get_refund/widgets/refund_item_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RefundItem extends StatelessWidget {
  final SwapInfo swapInfo;

  const RefundItem(
    this.swapInfo, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _RefundItemAmount(swapInfo.confirmedSats),
        RefundItemAction(swapInfo),
        const Divider(
          height: 0.0,
          color: Color.fromRGBO(255, 255, 255, 0.52),
        ),
      ],
    );
  }
}

class _RefundItemAmount extends StatelessWidget {
  final int confirmedSats;

  const _RefundItemAmount(this.confirmedSats);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final currencyState = context.read<CurrencyBloc>().state;
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Text(
            texts.get_refund_amount(
              currencyState.bitcoinCurrency.format(confirmedSats),
            ),
            textAlign: TextAlign.left,
          ),
        )
      ],
    );
  }
}
