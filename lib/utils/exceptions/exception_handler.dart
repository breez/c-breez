import 'package:breez_translations/generated/breez_translations.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('ExceptionHandler');

/// Utility class for extracting user-friendly error messages from exceptions
class ExceptionHandler {
  /// Private constructor to prevent instantiation
  ExceptionHandler._();

  /// Extracts a user-friendly message from an exception
  ///
  /// [exception] The exception to extract a message from
  /// [texts] Translations for localized error messages
  /// [defaultErrorMsg] Optional default error message if extraction fails
  /// Returns a user-friendly error message
  static String extractMessage(Object exception, BreezTranslations texts, {String? defaultErrorMsg}) {
    _logger.info('Extracting exception message: $exception');

    if (exception is FfiException) {
      if (exception.message.isNotEmpty) {
        String message = exception.message.replaceAll('\n', ' ').trim();
        message = _extractInnerErrorMessage(message)?.trim() ?? message;
        message = _localizedExceptionMessage(texts, message);
        return message;
      }
    }

    if (exception is FrbAnyhowException) {
      if (exception.anyhow.isNotEmpty) {
        String message = exception.anyhow.replaceAll('\n', ' ').trim();
        message = _extractInnerErrorMessage(message)?.trim() ?? message;
        message = _localizedExceptionMessage(texts, message);
        return message;
      }
    }

    return _extractInnerErrorMessage(exception.toString()) ?? defaultErrorMsg ?? exception.toString();
  }

  /// Extracts inner error messages from exception strings
  ///
  /// [content] The exception string to parse
  /// Returns the inner error message or null if none is found
  static String? _extractInnerErrorMessage(String content) {
    _logger.info('Extracting inner error message: $content');

    final RegExp innerMessageRegex = RegExp(r'((?<=message: \\")(.*)(?=.*\\"))');
    final RegExp messageRegex = RegExp(r'((?<=message: ")(.*)(?=.*"))');
    final RegExp causedByRegex = RegExp(r'((?<=Caused by: )(.*)(?=.*))');
    final RegExp reasonRegex = RegExp(r'((?<=FAILURE_REASON_)(.*)(?=.*))');

    return innerMessageRegex.stringMatch(content) ??
        messageRegex.stringMatch(content) ??
        causedByRegex.stringMatch(content) ??
        reasonRegex.stringMatch(content);
  }

  /// Maps error messages to localized strings
  ///
  /// [texts] Translations for localized error messages
  /// [originalMessage] The original error message
  /// Returns a localized error message
  static String _localizedExceptionMessage(BreezTranslations texts, String originalMessage) {
    _logger.info('Localizing exception message: $originalMessage');

    final String messageToLower = originalMessage.toLowerCase();

    if (messageToLower.contains('transport error')) {
      return texts.generic_network_error;
    } else if (messageToLower.contains('insufficient_balance')) {
      return texts.payment_error_insufficient_balance;
    } else if (messageToLower.contains('incorrect_payment_details')) {
      return texts.payment_error_incorrect_payment_details;
    } else if (messageToLower == 'error') {
      return texts.payment_error_unexpected_error;
    } else if (messageToLower == 'no_route') {
      return texts.payment_error_no_route;
    } else if (messageToLower == 'timeout') {
      return texts.payment_error_payment_timeout_exceeded;
    } else if (messageToLower == 'none') {
      return texts.payment_error_none;
    } else if (messageToLower.startsWith("lsp doesn't support opening a new channel")) {
      return texts.lsp_error_cannot_open_channel;
    } else if (messageToLower.contains('dns error') || messageToLower.contains('os error 104')) {
      return texts.generic_network_error;
    } else if (messageToLower.contains('mnemonic has an invalid checksum')) {
      return texts.enter_backup_phrase_error;
    } else if (messageToLower.contains("Recovery failed:")) {
      return texts.enter_backup_phrase_error;
    } else {
      return originalMessage;
    }
  }
}
