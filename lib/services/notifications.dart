import 'dart:async';

import 'package:c_breez/logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';

abstract class Notifications {
  Future<String?> getToken();
  Stream<Map<dynamic, dynamic>> get notifications;
}

class FirebaseNotifications implements Notifications {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;  

  final StreamController<Map<dynamic, dynamic>> _notificationController =
      BehaviorSubject<Map<dynamic, dynamic>>();
  @override
  Stream<Map<dynamic, dynamic>> get notifications =>
      _notificationController.stream;

  FirebaseNotifications() {    
    FirebaseMessaging.onMessage.listen(_onMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onResume);
  }

  Future _onMessage(RemoteMessage message) {
    log.info("_onMessage = " + message.data.toString());
    var data = message.data["data"] ?? message.data["aps"] ?? message.data;
    if (data != null) {
      _notificationController.add(data);
    }
    return Future.value(null);
  }

  Future _onResume(RemoteMessage message) {
    log.info("_onResume = " + message.data.toString());
    var data = message.data["data"] ?? message.data;
    if (data != null) {
      _notificationController.add(data);
    }
    return Future.value(null);
  }

  @override
  Future<String?> getToken() async {
    NotificationSettings firebaseNotificationSettings = await _firebaseMessaging.requestPermission(
        sound: true, badge: true, alert: true);
    if(firebaseNotificationSettings.authorizationStatus == AuthorizationStatus.authorized){
      return _firebaseMessaging.getToken();
    } else {
      return null;
    }
  }
}
