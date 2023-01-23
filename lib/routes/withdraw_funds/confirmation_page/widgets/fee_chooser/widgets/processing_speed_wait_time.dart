import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

class ProcessingSpeedWaitTime extends Text {
  ProcessingSpeedWaitTime(
    BuildContext context,
    Duration waitingTime,
  ) : super(
          _estimatedDelivery(context, waitingTime),
          style: _style(context),
        );

  static String _estimatedDelivery(
    BuildContext context,
    Duration waitingTime,
  ) {
    final texts = context.texts();
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
