import 'package:breez_sdk/breez_sdk.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger("HealthCheckBloc");

class HealthCheckBloc extends Cubit<HealthCheckStatus> {
  final BreezSDK _breezSDK;

  HealthCheckBloc(
    this._breezSDK, {
    checkInterval = const Duration(seconds: 30),
  }) : super(HealthCheckStatus.Operational) {
    Stream.periodic(checkInterval).listen((_) async {
      _log.info("Performing health check");
      try {
        final response = await _breezSDK.serviceHealthCheck();
        _onNewHealthCheckStatus(response.status);
      } catch (error) {
        _log.severe("Health check error", error);
      }
    }, onError: (error) {
      _log.severe("Health check error", error);
    });
  }

  void _onNewHealthCheckStatus(HealthCheckStatus status) {
    _log.info("New health check status: $status previous status: $state");
    if (state != status) {
      emit(status);
    }
  }
}
