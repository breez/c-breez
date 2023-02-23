import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/bloc/input/input_bloc.dart';
import 'package:c_breez/bloc/input/input_state.dart';
import 'package:c_breez/services/injector.dart';
import 'package:dart_lnurl/dart_lnurl.dart';
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

    test('lnurl', () {
      const input = "LNURL1DP68GURN8GHJ7MRFVA58GUMPW3EJUCM0D5HKZURF9ASH2ARG9AKXUATJDSHKGMEDD3HKW6TW"
          "8A4NZ0F4VFJRZVMRX5MXGWTYVYMNJDTR8PJRYEFEVD3NSVMXXSCXVVECVYER2ENRVFJKXVEKVYUNVCE4XUUX2E3H"
          "VCEKGEFCVG6KXDFJV9JRYFN5V9NN6MR0VA5KUZPFUCA";
      final data = LnUrlPayRequestData(
        callback: "a callback",
        minSendable: 10,
        maxSendable: 10,
        metadataStr: "a metadata",
        commentAllowed: 1,
      );
      final inputType = InputType_LnUrlPay(data: data);

      final injector = InjectorMock();
      final bloc = InputBloc(injector.breezLib, injector.lightningLinks, injector.device);
      injector.breezLib.getNodeState();
      injector.breezLibMock.parseInputAnswer[input] = inputType;

      expectLater(
        bloc.stream,
        emitsInOrder([
          InputState(isLoading: true),
          InputState(inputType: inputType, inputData: data),
        ]),
      );

      bloc.addIncomingInput(input);
    });
  });
}
