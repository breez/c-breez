import 'package:c_breez/bloc/withdraw/withdraw_funds_state.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:flutter/material.dart';

class WithdrawFundsSpeedMessage extends Text {
  WithdrawFundsSpeedMessage(
    BuildContext context,
    WithdrawFudsInfoState infoState,
  ) : super(
          _estimatedDelivery(context, infoState),
          style: _style(context),
        );

  static String _estimatedDelivery(
    BuildContext context,
    WithdrawFudsInfoState infoState,
  ) {
    final texts = context.texts();
    final waitingTime = infoState.selectedCost().waitingTime;
    final hours = waitingTime.inHours;

    if (hours >= 12.0) {
      return texts.fee_chooser_estimated_delivery_more_than_day;
    } else if (hours >= 4) {
      return texts.fee_chooser_estimated_delivery_hour_range(
        hours.ceil().toString(),
      );
    } else if (hours >= 2.0) {
      return texts.fee_chooser_estimated_delivery_hours(
        hours.ceil().toString(),
      );
    } else if (hours >= 1.0) {
      return texts.fee_chooser_estimated_delivery_hour;
    } else {
      return texts.fee_chooser_estimated_delivery_minutes(
        waitingTime.inMinutes.toString(),
      );
    }
  }

  static _style(BuildContext context) {
    final themeData = Theme.of(context);
    return themeData.textTheme.button!.copyWith(
      color: themeData.colorScheme.onSurface.withOpacity(0.4),
    );
  }
}
