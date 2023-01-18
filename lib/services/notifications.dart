import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';

abstract class Notifications {
  Future<String?> getToken();
  Stream<Map<dynamic, dynamic>> get notifications;
}

class FirebaseNotifications implements Notifications {
  final _log = FimberLog("FirebaseNotifications");
  
  FirebaseMessaging get  _firebaseMessaging {
    return FirebaseMessaging.instance;
  }

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
    _log.i("_onMessage = ${message.data}");
    var data = message.data["data"] ?? message.data["aps"] ?? message.data;
    if (data != null) {
      _notificationController.add(data);
    }
    return Future.value(null);
  }

  Future _onResume(RemoteMessage message) {
    _log.i("_onResume = ${message.data}");
    var data = message.data["data"] ?? message.data;
    if (data != null) {
      _notificationController.add(data);
    }
    return Future.value(null);
  }

  @override
  Future<String?> getToken() async {
    NotificationSettings firebaseNotificationSettings = await _firebaseMessaging
        .requestPermission(sound: true, badge: true, alert: true);
    if (firebaseNotificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      return _firebaseMessaging.getToken();
    } else {
      return null;
    }
  }
}
