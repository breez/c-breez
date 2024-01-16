import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:flutter/cupertino.dart';

class PaymentResult {
  final Payment? paymentInfo;
  final PaymentResultError? error;

  const PaymentResult({
    this.paymentInfo,
    this.error,
  });

  @override
  String toString() {
    return 'PaymentResult{paymentInfo: $paymentInfo, error: $error}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentResult &&
          runtimeType == other.runtimeType &&
          paymentInfo == other.paymentInfo &&
          error == other.error;

  @override
  int get hashCode => paymentInfo.hashCode ^ error.hashCode;
}

class PaymentResultError {
  final String message;
  final bool ignoreGlobalFeedback;
  final bool validationError;
  final String paymentHash;
  final String comment;

  const PaymentResultError({
    required this.message,
    this.ignoreGlobalFeedback = false,
    this.validationError = false,
    required this.paymentHash,
    required this.comment,
  });

  factory PaymentResultError.fromException(String paymentHash, Object? error, {BuildContext? context}) {
    final texts = context?.texts() ?? getSystemAppLocalizations();
    String? displayMessage = error != null ? extractExceptionMessage(error, texts) : null;
    return PaymentResultError(
      message: displayMessage != null
          ? texts.payment_error_to_send(displayMessage)
          : texts.payment_error_to_send_unknown_reason,
      ignoreGlobalFeedback: false,
      validationError: error != null &&
          error.toString().toLowerCase().contains("rpcerror") &&
          !error.toString().toLowerCase().contains("payment is in transition"),
      paymentHash: paymentHash,
      comment: error?.toString() ?? "Unknown error",
    );
  }

  @override
  String toString() {
    return 'PaymentResultError{message: $message, ignoreGlobalFeedback: $ignoreGlobalFeedback, '
        'validationError: $validationError, paymentHash: $paymentHash, comment: $comment}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentResultError &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          ignoreGlobalFeedback == other.ignoreGlobalFeedback &&
          validationError == other.validationError &&
          paymentHash == other.paymentHash &&
          comment == other.comment;

  @override
  int get hashCode =>
      message.hashCode ^
      ignoreGlobalFeedback.hashCode ^
      validationError.hashCode ^
      paymentHash.hashCode ^
      comment.hashCode;
}
