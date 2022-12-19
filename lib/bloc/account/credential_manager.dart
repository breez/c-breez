import 'dart:typed_data';

import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/services/keychain.dart';
import 'package:hex/hex.dart';

class CredentialsManager {
  static const String accountCredsKey = "account_creds_key";
  static const String accountCredsCert = "account_creds_cert";
  static const String accountSeedKey = "account_seed_key";

  final KeyChain keyChain;

  CredentialsManager({required this.keyChain});

  Future storeCredentials({
    required GreenlightCredentials glCreds,
    required Uint8List seed,
  }) async {
    try {
      await _storeGreenlightCredentials(glCreds);
      await _storeSeed(seed);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<Credentials> restoreCredentials() async {
    try {
      GreenlightCredentials glCreds = await _restoreGreenlightCredentials();
      Uint8List seed = await _restoreSeed();
      return Credentials(glCreds: glCreds, seed: seed);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  // Helper methods
  Future<void> _storeGreenlightCredentials(
    GreenlightCredentials glCreds,
  ) async {
    await keyChain.write(accountCredsCert, HEX.encode(glCreds.deviceCert));
    await keyChain.write(accountCredsKey, HEX.encode(glCreds.deviceKey));
  }

  Future<void> _storeSeed(Uint8List seed) async {
    await keyChain.write(accountSeedKey, HEX.encode(seed));
  }

  Future<GreenlightCredentials> _restoreGreenlightCredentials() async {
    String? deviceCertStr = await keyChain.read(accountCredsCert);
    String? deviceKeyStr = await keyChain.read(accountCredsKey);
    return GreenlightCredentials(
      deviceKey: Uint8List.fromList(HEX.decode(deviceKeyStr!)),
      deviceCert: Uint8List.fromList(HEX.decode(deviceCertStr!)),
    );
  }

  Future<Uint8List> _restoreSeed() async {
    String? seedStr = await keyChain.read(accountSeedKey);
    return Uint8List.fromList(HEX.decode(seedStr!));
  }
}

class Credentials {
  final GreenlightCredentials glCreds;
  final Uint8List seed;

  Credentials({required this.glCreds, required this.seed});
}
