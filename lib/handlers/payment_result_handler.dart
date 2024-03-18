import 'dart:async';

import 'package:breez_sdk/sdk.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/payment_result.dart';
import 'package:c_breez/bloc/error_report_bloc/error_report_bloc.dart';
import 'package:c_breez/handlers/handler.dart';
import 'package:c_breez/handlers/handler_context_provider.dart';
import 'package:c_breez/models/bug_report_behavior.dart';
import 'package:c_breez/utils/preferences.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/payment_dialogs/payment_failed_report_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';

final _log = Logger("PaymentResultHandler");

class PaymentResultHandler extends Handler {
  final Preferences preferences;
  StreamSubscription<PaymentResult>? _subscription;

  PaymentResultHandler({
    this.preferences = const Preferences(),
  });

  @override
  void init(HandlerContextProvider contextProvider) {
    super.init(contextProvider);
    _log.info("PaymentResultHandler inited");
    _subscription = contextProvider
        .getBuildContext()!
        .read<AccountBloc>()
        .paymentResultStream
        .delay(const Duration(seconds: 1))
        .listen(_listen);
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
    _subscription = null;
  }

  void _listen(PaymentResult paymentResult) async {
    _log.info("Received paymentResult: $paymentResult");
    final context = contextProvider?.getBuildContext();
    if (context == null) {
      _log.warning("Failed to proceed because context is null");
      return;
    }

    final paymentInfo = paymentResult.paymentInfo;
    final error = paymentResult.error;
    if (paymentInfo != null) {
      final texts = context.texts();
      showFlushbar(
        context,
        messageWidget: SingleChildScrollView(
          child: Text(
            paymentInfo.paymentType == PaymentType.Received
                ? texts.successful_payment_received
                : texts.home_payment_sent,
          ),
        ),
      );
    } else if (error != null) {
      _log.info("paymentResult error: $error");
      showFlushbar(
        context,
        message: error.message,
      );
      _reportFlow(error.paymentHash, error.comment);
    } else {
      _log.warning("paymentResult is null and error is null");
    }
  }

  void _reportFlow(String paymentHash, String comment) async {
    _log.info("Starting report flow for error: $paymentHash $comment");
    final behavior = await preferences.getBugReportBehavior();
    switch (behavior) {
      case BugReportBehavior.SEND_REPORT:
        _log.info("User has chosen to report");
        _report(paymentHash, comment);
        break;
      case BugReportBehavior.IGNORE:
        _log.info("User has chosen not to report");
        break;
      default:
        _log.info("User has not chosen yet, asking for permission");
        final context = contextProvider?.getBuildContext();
        if (context == null) {
          _log.warning("Failed to proceed because context is null");
          return;
        }
        final result = await showDialog(
          useRootNavigator: false,
          context: context,
          barrierDismissible: false,
          builder: (_) => const PaymentFailedReportDialog(),
        );
        if (result is PaymentFailedReportDialogResult) {
          _log.info("Got result from PaymentFailedReportDialog: $result");
          if (result.doNotAskAgain) {
            await preferences.setBugReportBehavior(
                result.report ? BugReportBehavior.SEND_REPORT : BugReportBehavior.IGNORE);
          }
          if (result.report) {
            _report(paymentHash, comment);
          }
        } else {
          _log.warning("Failed to get result from PaymentFailedReportDialog");
        }
        break;
    }
  }

  void _report(String paymentHash, String comment) {
    _log.info("Reporting error: $paymentHash $comment");
    final context = contextProvider?.getBuildContext();
    if (context == null) {
      _log.warning("Failed to report because context is null");
      return;
    }
    context.read<ErrorReportBloc>().reportError(paymentHash, comment);
  }
}
