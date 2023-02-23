import 'package:c_breez/services/device.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

class DeviceMock extends Mock implements Device {
  final clipboardController = BehaviorSubject<String>.seeded("");

  @override
  Stream<String> get clipboardStream => clipboardController.stream;
}
