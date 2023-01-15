import 'dart:typed_data';

import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/credential_manager.dart';
import 'package:c_breez/services/injector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hex/hex.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../mock/injector_mock.dart';
import '../utils/fake_path_provider_platform.dart';
import '../utils/hydrated_bloc_storage.dart';

var testSeed =
    '0c56b71ef51d393ecd55cbd22779ada82705d15bb583e7c6a4a20482a986e35031544c88f408b32fd0dd7604c0e8ced8c1595143a2da58dc0704effd58b80680';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final platform = FakePathProviderPlatform();
  InjectorMock injector = InjectorMock();  
  group('account', () {
    setUp(() async {
      ServiceInjector.configure(injector);
      await platform.setUp();
      PathProviderPlatform.instance = platform;
      await setUpHydratedBloc();
    });

    tearDown(() async {
      await platform.tearDown();
    });

    test('recover node', () async {
      var injector = InjectorMock();
      var breezLib = injector.breezLib;
      injector.keychain.write(CredentialsManager.accountCredsKey, "a3e1");
      injector.keychain.write(CredentialsManager.accountCredsCert, "a3e61");
      injector.keychain.write(CredentialsManager.accountSeedKey, "a3eed");
      AccountBloc accBloc = AccountBloc(
        breezLib,
        CredentialsManager(keyChain: injector.keychain)        
      );

      await accBloc.recoverNode(
        seed: Uint8List.fromList(HEX.decode(testSeed)),
      );
      var accountState = accBloc.state;
      expect(accountState.blockheight, greaterThan(1));
      expect(accountState.id?.length, equals(66));
      expect(accountState.balance, 0);
      expect(accountState.walletBalance, 0);
      expect(accountState.maxAllowedToPay, 0);
      expect(accountState.maxAllowedToReceive, 0);
      expect(accountState.maxPaymentAmount, 4294967);
      expect(accountState.maxChanReserve, 0);
      expect(accountState.maxInboundLiquidity, 0);
      expect(accountState.onChainFeeRate, 0);
      expect(accountState.payments.length, 0);
    });
  });
}
