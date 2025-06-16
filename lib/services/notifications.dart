import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';

final Logger _logger = Logger('FirebaseNotifications');

abstract class NotificationsClient {
  Future<String?> getToken();
  Stream<Map<dynamic, dynamic>> get notifications;
}

class FirebaseNotificationsClient implements NotificationsClient {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final BehaviorSubject<Map<dynamic, dynamic>> _notificationController =
      BehaviorSubject<Map<dynamic, dynamic>>();

  @override
  Stream<Map<dynamic, dynamic>> get notifications => _notificationController.stream;

  FirebaseNotificationsClient() {
    FirebaseMessaging.onMessage.listen(_onMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onResume);
  }

  Future<void> _onMessage(RemoteMessage message) async {
    _logger.info('_onMessage = ${message.data}');
    final Map<dynamic, dynamic>? data = _extractData(message.data);
    if (data != null) {
      _notificationController.add(data);
    }
  }

  Future<void> _onResume(RemoteMessage message) async {
    _logger.info('_onResume = ${message.data}');
    final Map<dynamic, dynamic>? data = _extractData(message.data);
    if (data != null) {
      _notificationController.add(data);
    }
  }

  Map<dynamic, dynamic>? _extractData(Map<String, dynamic> data) {
    dynamic extractedData = data['data'] ?? data['aps'] ?? data;
    if (extractedData is String) {
      extractedData = json.decode(extractedData);
    }
    return extractedData;
  }

  @override
  Future<String?> getToken() async {
    _logger.info('getToken');
    final NotificationSettings firebaseNotificationSettings = await _firebaseMessaging.requestPermission();

    _logger.config('User granted permission: ${firebaseNotificationSettings.authorizationStatus}');
    if (firebaseNotificationSettings.authorizationStatus == AuthorizationStatus.authorized) {
      _logger.info('Authorized to get token');
      return _firebaseMessaging.getToken();
    } else {
      _logger.warning('Unauthorized to get token');
      return null;
    }
  }
}
