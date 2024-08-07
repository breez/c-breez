import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/account/credentials_manager.dart';
import 'package:c_breez/services/injector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../../mock/injector_mock.dart';
import '../../unit_logger.dart';
import '../../utils/fake_path_provider_platform.dart';
import '../../utils/hydrated_bloc_storage.dart';

var testMnemonic = 'update elbow source spin squeeze horror world become oak assist bomb nuclear';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final platform = FakePathProviderPlatform();
  final hydratedBlocStorage = HydratedBlocStorage();
  late InjectorMock injector;
  setUpLogger();

  group('account', () {
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

    test('recover node', () async {
      var injector = InjectorMock();
      var breezSDK = injector.breezSDK;
      injector.keychain.write(CredentialsManager.accountMnemonic, "a3eed");
      AccountBloc accBloc = AccountBloc(breezSDK, CredentialsManager(keyChain: injector.keychain));

      await accBloc.connect(mnemonic: testMnemonic, isRestore: true);
      var accountState = accBloc.state;
      expect(accountState.blockheight, greaterThan(1));
      expect(accountState.id?.length, equals(66));
      expect(accountState.balanceSat, 0);
      expect(accountState.walletBalanceSat, 0);
      expect(accountState.maxAllowedToPaySat, 0);
      expect(accountState.maxAllowedToReceiveSat, 0);
      expect(accountState.maxPaymentAmountSat, 4294967);
      expect(accountState.maxChanReserveSat, 0);
      expect(accountState.maxInboundLiquiditySat, 0);
      expect(accountState.payments.length, 0);
      expect(accountState.verificationStatus, VerificationStatus.VERIFIED);
    });
  });
}
