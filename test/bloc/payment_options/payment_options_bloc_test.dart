import 'package:c_breez/bloc/payment_options/payment_options_bloc.dart';
import 'package:c_breez/bloc/payment_options/payment_options_state.dart';
import 'package:c_breez/services/injector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../../mock/injector_mock.dart';
import '../../unit_logger.dart';
import '../../utils/fake_path_provider_platform.dart';
import '../../utils/hydrated_bloc_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final platform = FakePathProviderPlatform();
  final hydratedBlocStorage = HydratedBlocStorage();
  late InjectorMock injector;
  setUpLogger();

  setUp(() async {
    injector = InjectorMock();
    ServiceInjector.configure(injector);
    await platform.setUp();
    PathProviderPlatform.instance = platform;
    await hydratedBlocStorage.setUpHydratedBloc();
  });

  tearDown(() async {
    await platform.tearDown();
    await hydratedBlocStorage.tearDownHydratedBloc();
  });

  PaymentOptionsBloc make() => PaymentOptionsBloc(
        injector.preferences,
      );

  test('initial state should use defaults', () async {
    final bloc = make();
    expectLater(
      bloc.stream,
      emitsInOrder([
        const PaymentOptionsState.initial(),
      ]),
    );
  });

  test('should emit new state when proportional fee changed', () async {
    final bloc = make();
    expectLater(
      bloc.stream,
      emitsInOrder([
        const PaymentOptionsState.initial(),
        const PaymentOptionsState(proportionalFee: 0.01, saveEnabled: true),
        const PaymentOptionsState(proportionalFee: 0.01),
      ]),
    );
    // Delay to allow the bloc to initialize
    await Future.delayed(const Duration(milliseconds: 1));
    await bloc.setProportionalFee(0.01);
    await bloc.saveFees();
    expect(injector.preferencesMock.setPaymentOptionsProportionalFeeCalled, 1);
  });

  test('should emit new state when exempt fee changed', () async {
    final bloc = make();
    expectLater(
      bloc.stream,
      emitsInOrder([
        const PaymentOptionsState.initial(),
        const PaymentOptionsState(exemptFeeMsat: 5000, saveEnabled: true),
        const PaymentOptionsState(exemptFeeMsat: 5000),
      ]),
    );
    // Delay to allow the bloc to initialize
    await Future.delayed(const Duration(milliseconds: 1));
    await bloc.setExemptfeeMsat(5000);
    await bloc.saveFees();
    expect(injector.preferencesMock.setPaymentOptionsExemptFeeCalled, 1);
  });

  test('should emit new state when exempt fee changed', () async {
    final bloc = make();
    expectLater(
      bloc.stream,
      emitsInOrder([
        const PaymentOptionsState.initial(),
        const PaymentOptionsState(autoChannelSetupFeeLimitMsat: 5000 * 1000, saveEnabled: true),
        const PaymentOptionsState(autoChannelSetupFeeLimitMsat: 5000 * 1000),
      ]),
    );
    // Delay to allow the bloc to initialize
    await Future.delayed(const Duration(milliseconds: 1));
    await bloc.setAutoChannelSetupFeeLimitMsat(5000 * 1000);
    await bloc.saveFees();
    expect(injector.preferencesMock.setPaymentOptionsAutoChannelSetupFeeLimit(5000 * 1000), 1);
  });

  test('should emit new state when reset fees', () async {
    final bloc = make();
    expectLater(
      bloc.stream,
      emitsInOrder([
        const PaymentOptionsState.initial(),
        const PaymentOptionsState.initial().copyWith(
          proportionalFee: 0.01,
          exemptFeeMsat: 20000,
          saveEnabled: true,
        ),
        const PaymentOptionsState.initial().copyWith(
          proportionalFee: 0.01,
          exemptFeeMsat: 20000,
        ),
        const PaymentOptionsState.initial(),
      ]),
    );
    // Delay to allow the bloc to initialize
    await Future.delayed(const Duration(milliseconds: 1));
    await bloc.setProportionalFee(0.01);
    await bloc.setExemptfeeMsat(20000);
    await bloc.setAutoChannelSetupFeeLimitMsat(5000000);
    await bloc.saveFees();
    await bloc.resetFees();
    expect(injector.preferencesMock.setPaymentOptionsProportionalFeeCalled, 2);
    expect(injector.preferencesMock.setPaymentOptionsExemptFeeCalled, 2);
    expect(injector.preferencesMock.setPaymentOptionsAutoChannelSetupFeeLimitCalled, 2);
  });

  test('cancel editing should clear the unsaved state', () async {
    final bloc = make();
    expectLater(
      bloc.stream,
      emitsInOrder([
        const PaymentOptionsState.initial(),
        const PaymentOptionsState.initial().copyWith(
          proportionalFee: 0.01,
          exemptFeeMsat: 20000,
          saveEnabled: true,
        ),
        const PaymentOptionsState.initial(),
      ]),
    );
    // Delay to allow the bloc to initialize
    await Future.delayed(const Duration(milliseconds: 1));
    await bloc.setProportionalFee(0.01);
    await bloc.setExemptfeeMsat(20000);
    await bloc.setAutoChannelSetupFeeLimitMsat(5000000);
    await bloc.cancelEditing();
    // Delay to allow the fetch to complete
    await Future.delayed(const Duration(milliseconds: 1));
    expect(injector.preferencesMock.setPaymentOptionsProportionalFeeCalled, 0);
    expect(injector.preferencesMock.setPaymentOptionsExemptFeeCalled, 0);
    expect(injector.preferencesMock.setPaymentOptionsAutoChannelSetupFeeLimitCalled, 0);
  });
}
