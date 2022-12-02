import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/src/mixin/handler_mixin.dart';

void sqfliteFfiInitAsMockMethodCallHandler() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final binding = TestDefaultBinaryMessengerBinding.instance!;
  binding.defaultBinaryMessenger.setMockMethodCallHandler(
    const MethodChannel('com.tekartik.sqflite'),
    (methodCall) async {
      try {
        return await ffiMethodCallhandleInIsolate(
          FfiMethodCall(
            methodCall.method,
            methodCall.arguments,
          ),
        );
      } on SqfliteFfiException catch (e) {
        throw PlatformException(
          code: e.code,
          message: e.message,
          details: e.details,
        );
      }
    },
  );
}
