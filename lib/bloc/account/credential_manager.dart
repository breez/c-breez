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
  static const String accountMnemonic = "account_mnemonic";

  final KeyChain keyChain;

  CredentialsManager({required this.keyChain});

  Future storeCredentials({
    required GreenlightCredentials glCreds,
    required String mnemonic,
  }) async {
    try {
      await _storeGreenlightCredentials(glCreds);
      await _storeMnemonic(mnemonic);
      _log.i("Stored credentials successfully");
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<Credentials> restoreCredentials() async {
    try {
      GreenlightCredentials glCreds = await _restoreGreenlightCredentials();
      String mnemonic = await _restoreMnemonic();
      _log.i("Restored credentials successfully");
      return Credentials(glCreds: glCreds, mnemonic: mnemonic);
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

  Future<void> _storeMnemonic(String mnemonic) async {
    await keyChain.write(accountMnemonic, mnemonic);
  }

  Future<GreenlightCredentials> _restoreGreenlightCredentials() async {
    String? deviceCertStr = await keyChain.read(accountCredsCert);
    String? deviceKeyStr = await keyChain.read(accountCredsKey);
    return GreenlightCredentials(
      deviceKey: Uint8List.fromList(HEX.decode(deviceKeyStr!)),
      deviceCert: Uint8List.fromList(HEX.decode(deviceCertStr!)),
    );
  }

  Future<String> _restoreMnemonic() async {
    String? mnemonicStr = await keyChain.read(accountMnemonic);
    return mnemonicStr!;
  }

  Future<List<File>> exportCredentials() async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      var keysDir = tempDir.createTempSync("keys");
      final File credentialsFile = await File('${keysDir.path}/creds').create(recursive: true);
      Credentials credentials = await restoreCredentials();
      credentialsFile.writeAsString(jsonEncode(credentials.toGreenlightCredentialsJson()));
      final File mnemonicFile = await File('${keysDir.path}/phrase').create(recursive: true);
      mnemonicFile.writeAsString(credentials.mnemonic);
      return [credentialsFile, mnemonicFile];
    } catch (e) {
      throw e.toString();
    }
  }
}

class Credentials {
  final GreenlightCredentials glCreds;
  final String mnemonic;

  Credentials({required this.glCreds, required this.mnemonic});

  GreenlightCredentials fromGreenlightCredentialsJson(
    Map<String, dynamic> json,
  ) {
    return GreenlightCredentials(
      deviceKey: Uint8List.fromList(json['deviceKey']),
      deviceCert: Uint8List.fromList(json['deviceCert']),
    );
  }

  Map<String, dynamic> toGreenlightCredentialsJson() => {
        'deviceKey': glCreds.deviceKey,
        'deviceCert': glCreds.deviceCert,
      };

  Credentials.fromJson(
    Map<String, dynamic> json,
  )   : glCreds = GreenlightCredentials(
          deviceKey: Uint8List.fromList(HEX.decode(json['glCreds']['deviceKey'])),
          deviceCert: Uint8List.fromList(HEX.decode(json['glCreds']['deviceCert'])),
        ),
        mnemonic = json['mnemonic'];

  Map<String, dynamic> toJson() => {
        'glCreds': {
          'deviceKey': HEX.encode(glCreds.deviceKey),
          'deviceCert': HEX.encode(glCreds.deviceCert),
        },
        'mnemonic': mnemonic,
      };
}
