import 'package:breez_translations/generated/breez_translations.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import "package:flutter_rust_bridge/flutter_rust_bridge.dart";

final _log = FimberLog("exceptions");

String extractExceptionMessage(
  Object exception,
  BreezTranslations texts,
) {
  _log.v("extractExceptionMessage: $exception");
  if (exception is FfiException) {
    if (exception.message.isNotEmpty) {
      var message = exception.message.replaceAll("\n", " ").trim();
      message = _extractInnerErrorMessage(message)?.trim() ?? message;
      message = _localizedExceptionMessage(texts, message);
      return message;
    }
  }
  return _extractInnerErrorMessage(exception.toString()) ?? exception.toString();
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

String _localizedExceptionMessage(
  BreezTranslations texts,
  String originalMessage,
) {
  _log.v("localizedExceptionMessage: $originalMessage");
  switch (originalMessage.toLowerCase()) {
    case "transport error":
      return texts.generic_network_error;
    default:
      return originalMessage;
  }
}
