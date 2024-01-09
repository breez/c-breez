import 'package:breez_sdk/breez_sdk.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/bloc/health_check/health_check_bloc.dart';
import 'package:c_breez/services/injector.dart';
import 'package:flutter_test/flutter_test.dart';

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
    var breezSDK = injector.breezSDK;
    injector.breezSDKMock.serviceHealthCheckResponse = const ServiceHealthCheckResponse(
      status: HealthCheckStatus.Maintenance,
    );

    final bloc = _bloc(breezSDK);
    expectLater(
      bloc.stream,
      emitsInOrder([
        HealthCheckStatus.Maintenance,
      ]),
    );
  });

  test('service disruption', () async {
    var breezSDK = injector.breezSDK;
    injector.breezSDKMock.serviceHealthCheckResponse = const ServiceHealthCheckResponse(
      status: HealthCheckStatus.ServiceDisruption,
    );

    final bloc = _bloc(breezSDK);
    expectLater(
      bloc.stream,
      emitsInOrder([
        HealthCheckStatus.ServiceDisruption,
      ]),
    );
  });
}

HealthCheckBloc _bloc(BreezSDK sdk) => HealthCheckBloc(sdk, checkInterval: const Duration(seconds: 1));
