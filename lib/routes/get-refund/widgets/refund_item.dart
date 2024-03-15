import 'package:breez_sdk/sdk.dart';
import 'package:c_breez/routes/get-refund/widgets/refund_item_action.dart';
import 'package:c_breez/widgets/available_btc.dart';
import 'package:flutter/material.dart';

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
        AvailableBTC(swapInfo.confirmedSats),
        RefundItemAction(swapInfo),
      ],
    );
  }
}
