// ignore_for_file: avoid_print
import 'package:bip39/bip39.dart' as bip39;
import 'package:breez_sdk/breez_bridge.dart';
import 'package:c_breez/bloc/account/credential_manager.dart';
import 'package:c_breez/config.dart';
import 'package:c_breez/services/injector.dart';

Future<BreezBridge> initializeBreezServices() async {
  final injector = ServiceInjector();
  final breezLib = injector.breezLib;
  final bool isBreezInitialized = await breezLib.isInitialized();
  print("Is Breez Services initialized: $isBreezInitialized");
  if (!isBreezInitialized) {
    final credentialsManager = CredentialsManager(keyChain: injector.keychain);
    final credentials = await credentialsManager.restoreCredentials();
    final seed = bip39.mnemonicToSeed(credentials.mnemonic);
    print("Retrieved credentials");
    await breezLib.initServices(
      config: (await Config.instance()).sdkConfig,
      seed: seed,
      creds: credentials.glCreds,
    );
    print("Initialized Services");
    await breezLib.startNode();
    print("Node has started");
  }
  await breezLib.syncNode();
  print("Node has synchronized");
  return breezLib;
}
