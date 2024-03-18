import 'package:breez_sdk/sdk.dart';
import 'package:c_breez/bloc/health_check/health_check_bloc.dart';
import 'package:c_breez/services/injector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

import '../../mock/breez_bridge_mock.dart';
import '../../mock/injector_mock.dart';
import '../../unit_logger.dart';

void main() {
  late InjectorMock injector;
  setUpLogger();

  setUp(() async {
    injector = InjectorMock();
    ServiceInjector.configure(injector);
  });

  test('maintenance', () async {
    BreezSDKMock.serviceHealthCheckResponse = const ServiceHealthCheckResponse(
      status: HealthCheckStatus.Maintenance,
    );

    final bloc = _bloc();
    expectLater(
      bloc.stream.whereNotNull(),
      emitsInOrder([
        HealthCheckStatus.Maintenance,
      ]),
    );
    BreezSDKMock.nodeInfo();
    bloc.checkStatus(retryInterval: const Duration(seconds: 1));
  });

  test('service disruption', () async {
    BreezSDKMock.serviceHealthCheckResponse = const ServiceHealthCheckResponse(
      status: HealthCheckStatus.ServiceDisruption,
    );

    final bloc = _bloc();
    expectLater(
      bloc.stream.whereNotNull(),
      emitsInOrder([
        HealthCheckStatus.ServiceDisruption,
      ]),
    );
    BreezSDKMock.nodeInfo();
    bloc.checkStatus(retryInterval: const Duration(seconds: 1));
  });
}

HealthCheckBloc _bloc() => HealthCheckBloc();
