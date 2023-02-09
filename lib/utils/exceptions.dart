import 'package:flutter_fimber/flutter_fimber.dart';
import "package:flutter_rust_bridge/flutter_rust_bridge.dart";

final _log = FimberLog("exceptions");

String extractExceptionMessage(Object exception) {
  _log.v("extractExceptionMessage: $exception");
  if (exception is FfiException) {
    if (exception.message.isNotEmpty) {
      final message = exception.message;
      final innerErrorMessage = _extractInnerErrorMessage(message);
      return innerErrorMessage ?? message;
    }
  }
  return _extractInnerErrorMessage(exception.toString()) ??
      exception.toString();
}

String? _extractInnerErrorMessage(String content) {
  _log.v("extractInnerErrorMessage: $content");
  final innerMessageRegex = RegExp(r'((?<=message: \\")(.*)(?=.*\\"))');
  final messageRegex = RegExp(r'((?<=message: ")(.*)(?=.*"))');
  return innerMessageRegex.stringMatch(content) ??
      messageRegex.stringMatch(content);
}
