// ignore_for_file: avoid_print
import 'dart:async';

import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/services/injector.dart';

class PaymentHashPoller {
  final String paymentHash;
  void Function(bool contains) onDone;

  PaymentHashPoller({
    required this.onDone,
    required this.paymentHash,
  });

  void start() {
    const int interval = 5;
    print("Start polling for payment hash: $paymentHash every $interval seconds");
    final injector = ServiceInjector();
    final breezLib = injector.breezLib;

    Timer? paymentReceivedTimer;

    paymentReceivedTimer = Timer.periodic(
      const Duration(seconds: interval),
      (timer) async {
        final List<Payment> paymentList = await breezLib.listPayments(
          filter: PaymentTypeFilter.Received,
          fromTimestamp: DateTime.now().subtract(const Duration(minutes: 30)).millisecondsSinceEpoch,
        );
        for (var payment in paymentList) {
          final detailsData = payment.details.data;
          if (!payment.pending && detailsData is LnPaymentDetails && detailsData.paymentHash == paymentHash) {
            onDone(true);
            print("Payment received! Stop polling.");
            paymentReceivedTimer!.cancel();
          }
        }
        print("Payment isn't received yet. Keep polling.");
      },
    );
  }
}

/* WorkManager task of PaymentHashPoller*/
void pollForReceivedPayment(String paymentHash, Completer<bool> taskCompleter) {
  print("Executing payment_received task for $paymentHash");
  final paymentHashPoller = PaymentHashPoller(
    paymentHash: paymentHash,
    onDone: (bool containsPaymentHash) async {
      try {
        print("Completed payment_received task for $paymentHash");
        taskCompleter.complete(containsPaymentHash);
      } catch (error, stackTrace) {
        print("Completed payment_received task for $paymentHash with an error: ${error.toString()}");
        taskCompleter.completeError(error, stackTrace);
      }
    },
  );
  paymentHashPoller.start();
}
