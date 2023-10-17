import 'dart:async';

import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/payment_result.dart';
import 'package:c_breez/handlers/handler.dart';
import 'package:c_breez/handlers/handler_context_provider.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

final _log = Logger("PaymentResultHandler");

class PaymentResultHandler extends Handler {
  StreamSubscription<PaymentResult>? _subscription;

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

    if (paymentResult.paymentInfo != null) {
      final texts = context.texts();
      showFlushbar(
        context,
        messageWidget: SingleChildScrollView(
          child: Text(
            paymentResult.paymentInfo!.paymentType == PaymentType.Received
                ? texts.successful_payment_received
                : texts.home_payment_sent,
          ),
        ),
      );
    } else if (paymentResult.error != null) {
      _log.info("paymentResult error: ${paymentResult.error}");
      showFlushbar(
        context,
        message: paymentResult.errorMessage(),
      );
    }
  }
}
