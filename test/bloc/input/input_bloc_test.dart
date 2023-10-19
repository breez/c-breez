import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/bloc/input/input_bloc.dart';
import 'package:c_breez/bloc/input/input_printer.dart';
import 'package:c_breez/bloc/input/input_source.dart';
import 'package:c_breez/bloc/input/input_state.dart';
import 'package:c_breez/services/injector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../../mock/breez_bridge_mock.dart';
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

  group('input parser', () {
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

    test('lnurl', () async {
      var breezLib = injector.breezSDK;

      const input = "LNURL1DP68GURN8GHJ7MRFVA58GUMPW3EJUCM0D5HKZURF9ASH2ARG9AKXUATJDSHKGMEDD3HKW6TW"
          "8A4NZ0F4VFJRZVMRX5MXGWTYVYMNJDTR8PJRYEFEVD3NSVMXXSCXVVECVYER2ENRVFJKXVEKVYUNVCE4XUUX2E3H"
          "VCEKGEFCVG6KXDFJV9JRYFN5V9NN6MR0VA5KUZPFUCA";
      final parsedInput = await breezLib.parseInput(input: input) as InputType_LnUrlPay;

      final bloc = InputBloc(breezLib, injector.lightningLinks, injector.device, const InputPrinter());
      breezLib.nodeInfo();

      expectLater(
        bloc.stream,
        emitsInOrder([
          const InputState.loading(),
          InputState.lnUrlPay(parsedInput.data, InputSource.clipboard),
        ]),
      );

      bloc.addIncomingInput(input, InputSource.clipboard);
    });
  });
}
