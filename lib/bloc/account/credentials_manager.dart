import 'dart:io';

import 'package:c_breez/services/keychain.dart';
import 'package:fimber/fimber.dart';
import 'package:path_provider/path_provider.dart';

class CredentialsManager {
  final _log = FimberLog("CredentialsManager");
  static const String accountMnemonic = "account_mnemonic";

  final KeyChain keyChain;

  CredentialsManager({required this.keyChain});

  Future storeMnemonic({
    required String mnemonic,
  }) async {
    try {
      await _storeMnemonic(mnemonic);
      _log.i("Stored credentials successfully");
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<String> restoreMnemonic() async {
    try {
      String? mnemonicStr = await keyChain.read(accountMnemonic);
      _log.i("Restored credentials successfully");
      return mnemonicStr!;
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  // Helper methods
  Future<void> _storeMnemonic(String mnemonic) async {
    await keyChain.write(accountMnemonic, mnemonic);
  }

  Future<List<File>> exportCredentials() async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      var keysDir = tempDir.createTempSync("keys");
      final File mnemonicFile = await File('${keysDir.path}/phrase').create(recursive: true);
      String mnemonic = await restoreMnemonic();
      mnemonicFile.writeAsString(mnemonic);
      return [mnemonicFile];
    } catch (e) {
      throw e.toString();
    }
  }
}
