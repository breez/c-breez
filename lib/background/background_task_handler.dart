import 'package:c_breez/background/payment_hash_poller.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:workmanager/workmanager.dart';

final _log = Logger("BackgroundTaskManager");

@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
class BackgroundTaskManager {
  final timeoutDuration = Duration(seconds: (defaultTargetPlatform == TargetPlatform.iOS) ? 30 : 60);

  handleBackgroundTask() {
    Workmanager().executeTask((String taskName, Map<String, dynamic>? inputData) async {
      _log.info("Executing task: $taskName\nInput data: ${inputData.toString()}");
      if (inputData != null) {
        switch (inputData["notification_type"]) {
          case "payment_received":
            return PaymentHashPoller(
              paymentHash: inputData["payment_hash"],
              timeoutDuration: timeoutDuration,
            ).startPolling();
        }
      }
      return Future.value(false);
    });
  }
}
