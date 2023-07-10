// ignore_for_file: avoid_print
import 'package:bip39/bip39.dart' as bip39;
import 'package:breez_sdk/breez_bridge.dart';
import 'package:c_breez/bloc/account/credentials_manager.dart';
import 'package:c_breez/config.dart';
import 'package:c_breez/services/injector.dart';

Future<BreezBridge> initializeBreezServices() async {
  final injector = ServiceInjector();
  final breezLib = injector.breezLib;
  final bool isBreezInitialized = await breezLib.isInitialized();
  print("Is Breez Services initialized: $isBreezInitialized");
  if (!isBreezInitialized) {
    final credentialsManager = CredentialsManager(keyChain: injector.keychain);
    final mnemonic = await credentialsManager.restoreMnemonic();
    final seed = bip39.mnemonicToSeed(mnemonic);
    print("Retrieved credentials");
    await breezLib.connect(config: (await Config.instance()).sdkConfig, seed: seed);
    print("Initialized Services");
    print("Node has started");
  }
  await breezLib.syncNode();
  print("Node has synchronized");
  return breezLib;
}
