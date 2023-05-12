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
    print("Start polling for payment hash: $paymentHash every 10 seconds");
    final injector = ServiceInjector();
    final breezLib = injector.breezLib;

    Timer? paymentReceivedTimer;

    paymentReceivedTimer = Timer.periodic(
      const Duration(seconds: 10),
      (timer) async {
        final List<Payment> paymentList = await breezLib.listPayments();
        for (var payment in paymentList) {
          final detailsData = payment.details.data;
          if (detailsData is LnPaymentDetails && detailsData.paymentHash == paymentHash) {
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
void pollForReceivedPayment(data, Completer<bool> taskCompleter) {
  final paymentHash = data["payment_hash"];
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
