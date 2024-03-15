import 'package:breez_sdk/sdk.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger("ErrorReportBloc");

class ErrorReportBloc extends Cubit<int> {
  ErrorReportBloc() : super(0);

  void reportError(String paymentHash, String comment) {
    _log.info("Reporting error for paymentHash: $paymentHash, comment: $comment");
    BreezSDK.reportIssue(
      req: ReportIssueRequest.paymentFailure(
        data: ReportPaymentFailureDetails(
          paymentHash: paymentHash,
          comment: comment,
        ),
      ),
    ).then((value) {
      _log.info("Reported error for paymentHash: $paymentHash, comment: $comment");
      emit(state + 1);
    }, onError: (error) {
      _log.warning("Failed to report error for paymentHash: $paymentHash, comment: $comment, error: $error");
    });
  }
}
