import 'package:c_breez/models/fee_options/fee_option.dart';
import 'package:c_breez/routes/withdraw/widgets/fee_chooser/widgets/fee_breakdown_widgets/boltz_service_fee.dart';
import 'package:c_breez/routes/withdraw/widgets/fee_chooser/widgets/fee_breakdown_widgets/recipient_amount.dart';
import 'package:c_breez/routes/withdraw/widgets/fee_chooser/widgets/fee_breakdown_widgets/sender_amount.dart';
import 'package:c_breez/routes/withdraw/widgets/fee_chooser/widgets/fee_breakdown_widgets/transaction_fee.dart';
import 'package:flutter/material.dart';

class FeeBreakdown extends StatelessWidget {
  final int amountSat;
  final FeeOption feeOption;

  const FeeBreakdown(
    this.amountSat,
    this.feeOption, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    var feeOption = this.feeOption;
    int? boltzServiceFeeSat;
    if (feeOption is ReverseSwapFeeOption) {
      boltzServiceFeeSat = feeOption.pairInfo.totalFees - feeOption.txFeeSat;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        border: Border.all(
          color: themeData.colorScheme.onSurface.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        children: [
          SenderAmount(
            amountSat: (feeOption is ReverseSwapFeeOption)
                ? feeOption.pairInfo.senderAmountSat
                : amountSat + feeOption.txFeeSat,
          ),
          if (boltzServiceFeeSat != null) ...[
            BoltzServiceFee(boltzServiceFeeSat: boltzServiceFeeSat),
          ],
          TransactionFee(txFeeSat: feeOption.txFeeSat),
          RecipientAmount(
            amountSat: (feeOption is ReverseSwapFeeOption)
                ? feeOption.pairInfo.recipientAmountSat
                : amountSat - feeOption.txFeeSat,
          )
        ],
      ),
    );
  }
}
