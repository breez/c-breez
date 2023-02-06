import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/services/keychain.dart';
import 'package:fimber/fimber.dart';
import 'package:hex/hex.dart';
import 'package:path_provider/path_provider.dart';

class CredentialsManager {
  final _log = FimberLog("CredentialsManager");
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
      _log.i("Stored credentials successfully");
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<Credentials> restoreCredentials() async {
    try {
      GreenlightCredentials glCreds = await _restoreGreenlightCredentials();
      Uint8List seed = await _restoreSeed();
      _log.i("Restored credentials successfully");
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

  /* TODO: Subject to change to be compatible with CLI
      Instead of JSON, create two individual seed
      and a credentials file compatible with CLI
      then return the file list List<File>
  */
  Future<String> exportCredentials() async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      var keysDir = tempDir.createTempSync("keys");
      final File file = File('${keysDir.path}/c-breez_credentials.json');
      Credentials credentials = await restoreCredentials();
      file.writeAsString(jsonEncode(credentials.toGreenlightCredentialsJson()));
      return file.path;
    } catch (e) {
      throw e.toString();
    }
  }
}

class Credentials {
  final GreenlightCredentials glCreds;
  final Uint8List seed;

  Credentials({required this.glCreds, required this.seed});

  GreenlightCredentials fromGreenlightCredentialsJson(
      Map<String, dynamic> json,
      ) {
    return GreenlightCredentials(
      deviceKey: Uint8List.fromList(json['deviceKey']),
      deviceCert:  Uint8List.fromList(json['deviceCert']),
    );
  }

  Map<String, dynamic> toGreenlightCredentialsJson() => {
    'deviceKey': glCreds.deviceKey,
    'deviceCert': glCreds.deviceCert,
  };

  Credentials.fromJson(
    Map<String, dynamic> json,
  )   : glCreds = GreenlightCredentials(
          deviceKey:
              Uint8List.fromList(HEX.decode(json['glCreds']['deviceKey'])),
          deviceCert:
              Uint8List.fromList(HEX.decode(json['glCreds']['deviceCert'])),
        ),
        seed = Uint8List.fromList(HEX.decode(json['seed']));

  Map<String, dynamic> toJson() => {
        'glCreds': {
          'deviceKey': HEX.encode(glCreds.deviceKey),
          'deviceCert': HEX.encode(glCreds.deviceCert),
        },
        'seed': HEX.encode(seed),
      };
}
