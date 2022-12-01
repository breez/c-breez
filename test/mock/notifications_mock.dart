import 'dart:async';

import 'package:c_breez/services/notifications.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

class NotificationsMock extends Mock implements Notifications {
  @override
  Future<String> getToken() => Future<String>.value("dummy token");

  @override
  Stream<Map<String, dynamic>> get notifications => BehaviorSubject<Map<String, dynamic>>().stream;
}
