// ignore_for_file: avoid_print
import 'dart:async';

import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/services/injector.dart';

@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
class PaymentHashPoller {
  final Completer<bool> taskCompleter = Completer<bool>();
  final String paymentHash;
  final Duration timeoutDuration;

  PaymentHashPoller({
    required this.paymentHash,
    required this.timeoutDuration,
  });

  Future<bool> startPolling() {
    const Duration interval = Duration(seconds: 5);
    print("Start polling for payment hash: $paymentHash every $interval seconds");
    final paymentReceivedTimer = Timer.periodic(interval, isPaymentReceived);
    // Check if payment is received immediately(otherwise there's a delay of interval.inSeconds
    isPaymentReceived(paymentReceivedTimer);
    // Cancel timer if it's still running after a timeout duration
    Future.delayed(timeoutDuration).then((_) {
      print("Timeout exceeded. Stop polling.\nCompleted payment_received task for $paymentHash.");
      paymentReceivedTimer.cancel();
      taskCompleter.complete(false);
    });
    return taskCompleter.future;
  }

  void isPaymentReceived(Timer timer) async {
    final injector = ServiceInjector();
    final breezLib = injector.breezSDK;
    try {
      final List<Payment> paymentList = await breezLib.listPayments(
        filter: PaymentTypeFilter.Received,
        fromTimestamp: DateTime.now().subtract(const Duration(minutes: 30)).millisecondsSinceEpoch,
      );
      for (var payment in paymentList) {
        final detailsData = payment.details.data;
        final isPaymentReceived = payment.status == PaymentStatus.Complete &&
            detailsData is LnPaymentDetails &&
            detailsData.paymentHash == paymentHash;
        if (isPaymentReceived) {
          print("Payment received! Stop polling.");
          timer.cancel();
          print("Completed payment_received task for $paymentHash.");
          taskCompleter.complete(true);
          return;
        }
      }
      print("Payment isn't received yet. Keep polling.");
    } catch (error, stackTrace) {
      print("Completed payment_received task for $paymentHash with an error: ${error.toString()}");
      taskCompleter.completeError(error, stackTrace);
    }
  }
}
