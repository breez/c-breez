import 'package:c_breez/background/breez_service_initializer.dart';
import 'package:c_breez/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:workmanager/workmanager.dart';

final _log = Logger("BreezMessageHandler");

@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
class BreezMessageHandler {
  final RemoteMessage message;

  BreezMessageHandler(this.message);

  Future<void> handleBackgroundMessage() async {
    _log.info("Handling a background message: ${message.messageId}\nMessage data: ${message.data}");
    await initializeBreezServices();
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

    switch (message.data["notification_type"]) {
      case "payment_received":
        await handlePaymentReceivedMsg();
        break;
      case "modified_notification":
        _log.info("Received modified notification from Breez Notification Service Extension.");
        break;
    }

    return Future<void>.value();
  }

  Future<void> handlePaymentReceivedMsg() async {
    final uniqueName = message.data["payment_hash"] as String;
    final taskName = message.data["notification_type"] as String;
    await Workmanager().registerOneOffTask(
      (defaultTargetPlatform == TargetPlatform.iOS) ? "com.cBreez.paymentreceived" : uniqueName,
      (defaultTargetPlatform == TargetPlatform.iOS) ? "com.cBreez.paymentreceived" : taskName,
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresCharging: false,
      ),
      initialDelay: Duration.zero,
      inputData: {
        'notification_type': taskName,
        'payment_hash': uniqueName,
      }, // We need to parse taskName from inputData as taskName is ignored on iOS
    );
  }
}
