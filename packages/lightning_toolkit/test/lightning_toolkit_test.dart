import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightning_toolkit/lightning_toolkit.dart';

void main() {
  const MethodChannel channel = MethodChannel('lightning_toolkit');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await LightningToolkit.platformVersion, '42');
  });
}
