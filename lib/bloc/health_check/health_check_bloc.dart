import 'dart:async';

import 'package:breez_sdk/sdk.dart';
import 'package:c_breez/app_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger("HealthCheckBloc");

class HealthCheckBloc extends Cubit<HealthCheckStatus?> {
  Timer? _retryTimer;

  HealthCheckBloc() : super(null);

  void checkStatus({
    retryInterval = const Duration(seconds: 60),
  }) async {
    _log.info("Performing health check");
    _onNewHealthCheckStatus(null);
    _retryTimer?.cancel();
    _retryTimer = null;
    await _waitForNodeState();

    try {
      final apiKey = AppConfig().apiKey;
      final response = await BreezSDK.serviceHealthCheck(apiKey: apiKey);
      final status = response.status;
      _onNewHealthCheckStatus(status);
      if (status != HealthCheckStatus.Operational) {
        _log.info("Health check reported $status, retrying in $retryInterval");
        _scheduleRetry(retryInterval);
      }
    } catch (error) {
      _log.severe("Health check failed, retrying in $retryInterval", error);
      _scheduleRetry(retryInterval);
    }
  }

  void _onNewHealthCheckStatus(HealthCheckStatus? status) {
    _log.info("New health check status: $status previous status: $state");
    emit(status);
  }

  void _scheduleRetry(Duration retryInterval) {
    _retryTimer = Timer(retryInterval, () {
      _log.info("Retrying health check");
      checkStatus(retryInterval: retryInterval);
    });
  }

  Future<void> _waitForNodeState() async {
    _log.info("waitForNodeState");
    await BreezSDK.nodeStateStream.firstWhere((nodeState) => nodeState != null);
    _log.info("waitForNodeState: done");
  }
}
