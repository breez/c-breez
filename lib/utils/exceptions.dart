import 'package:flutter_fimber/flutter_fimber.dart';
import "package:flutter_rust_bridge/flutter_rust_bridge.dart";

final _log = FimberLog("exceptions");

String extractExceptionMessage(Object exception) {
  _log.v("extractExceptionMessage: $exception");
  if (exception is FfiException) {
    if (exception.message.isNotEmpty) {
      final message = exception.message.replaceAll("\n", " ").trim();
      final innerErrorMessage = _extractInnerErrorMessage(message)?.trim();
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
  final causedByRegex = RegExp(r'((?<=Caused by: )(.*)(?=.*))');
  return innerMessageRegex.stringMatch(content) ??
      messageRegex.stringMatch(content) ??
      causedByRegex.stringMatch(content);
}
