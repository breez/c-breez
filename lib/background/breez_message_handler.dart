import 'dart:io';

import 'package:c_breez/background/breez_service_initializer.dart';
import 'package:c_breez/main.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:workmanager/workmanager.dart';

final log = FimberLog("BreezMessageHandler");

class BreezMessageHandler {
  final RemoteMessage message;

  BreezMessageHandler(this.message);

  Future<void> handleBackgroundMessage() async {
    log.i("Handling a background message: ${message.messageId}\nMessage data: ${message.data}");
    await initializeBreezServices();
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

    switch (message.data["notification_type"]) {
      case "payment_received":
        await handlePaymentReceivedMsg();
        break;
    }

    return Future<void>.value();
  }

  Future<void> handlePaymentReceivedMsg() async {
    final uniqueName = message.data["payment_hash"] as String;
    final taskName = message.data["notification_type"] as String;
    await Workmanager().registerOneOffTask(
      (Platform.isIOS) ? "com.cBreez.paymentreceived" : uniqueName,
      (Platform.isIOS) ? "com.cBreez.paymentreceived" : taskName,
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
