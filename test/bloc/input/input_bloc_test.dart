import 'package:c_breez/bloc/input/input_bloc.dart';
import 'package:c_breez/bloc/input/input_state.dart';
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
  InjectorMock injector = InjectorMock();

  group('input parser', () {
    setUp(() async {
      setUpLogger();
      ServiceInjector.configure(injector);
      await platform.setUp();
      PathProviderPlatform.instance = platform;
      await setUpHydratedBloc();
    });

    tearDown(() async {
      await platform.tearDown();
      await tearDownHydratedBloc();
    });

    test('lnurl', () async {
      final injector = InjectorMock();
      var breezLib = injector.breezLib;

      const input = "LNURL1DP68GURN8GHJ7MRFVA58GUMPW3EJUCM0D5HKZURF9ASH2ARG9AKXUATJDSHKGMEDD3HKW6TW"
          "8A4NZ0F4VFJRZVMRX5MXGWTYVYMNJDTR8PJRYEFEVD3NSVMXXSCXVVECVYER2ENRVFJKXVEKVYUNVCE4XUUX2E3H"
          "VCEKGEFCVG6KXDFJV9JRYFN5V9NN6MR0VA5KUZPFUCA";
      final parsedInput = await breezLib.parseInput(input: input);

      final bloc = InputBloc(breezLib, injector.lightningLinks, injector.device);
      breezLib.getNodeState();

      expectLater(
        bloc.stream,
        emitsInOrder([
          InputState(isLoading: true),
          InputState(inputData: parsedInput),
        ]),
      );

      bloc.addIncomingInput(input);
    });
  });
}
