import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';

String extractExceptionMessage(Object exception) {
  if (exception is FfiException) {
    if (exception.message.isNotEmpty) {
      return exception.message;
    }
  }
  return exception.toString();
}
