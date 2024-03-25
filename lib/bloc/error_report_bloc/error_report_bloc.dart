import 'package:breez_sdk/breez_sdk.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger("ErrorReportBloc");

class ErrorReportBloc extends Cubit<int> {
  final BreezSDK _breezSDK;

  ErrorReportBloc(
    this._breezSDK,
  ) : super(0);

  void reportError(String paymentHash, String comment) {
    _log.info("Reporting error for paymentHash: $paymentHash, comment: $comment");
    var req = ReportIssueRequest.paymentFailure(
      data: ReportPaymentFailureDetails(
        paymentHash: paymentHash,
        comment: comment,
      ),
    );
    _breezSDK.reportIssue(req: req).then((value) {
      _log.info("Reported error for paymentHash: $paymentHash, comment: $comment");
      emit(state + 1);
    }, onError: (error) {
      _log.warning("Failed to report error for paymentHash: $paymentHash, comment: $comment, error: $error");
    });
  }
}
