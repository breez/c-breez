import "package:flutter_rust_bridge/flutter_rust_bridge.dart";

String extractExceptionMessage(Object exception) {
  if (exception is FfiException) {
    if (exception.message.isNotEmpty) {
      final message = exception.message;
      final innerErrorMessage = _extractInnerErrorMessage(message);
      return innerErrorMessage ?? message;
    }
  }
  return exception.toString();
}

String? _extractInnerErrorMessage(String content) {
  final innerMessageRegex = RegExp(r'((?<=message: \\")(.*)(?=.*\\"))');
  final messageRegex = RegExp(r'((?<=message: ")(.*)(?=.*"))');
  return innerMessageRegex.stringMatch(content) ?? messageRegex.stringMatch(content);
}
