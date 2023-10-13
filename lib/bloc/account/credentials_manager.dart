import 'dart:io';

import 'package:breez_sdk/bridge_generated.dart' as sdk;
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/services/keychain.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:c_breez/config.dart';

class CredentialsManager {
  final _log = Logger("CredentialsManager");
  static const String accountMnemonic = "account_mnemonic";

  final KeyChain keyChain;

  CredentialsManager({required this.keyChain});

  Future storeMnemonic({
    required String mnemonic,
  }) async {
    try {
      await _storeMnemonic(mnemonic);
      _log.info("Stored credentials successfully");
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<String> restoreMnemonic() async {
    try {
      String? mnemonicStr = await keyChain.read(accountMnemonic);
      _log.info("Restored credentials successfully");
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

  Future<sdk.StaticBackupResponse> exportStaticChannelBackup() async {
    final breezLib = ServiceInjector().breezSDK;
    Config config = await Config.instance();
    String workingDir = config.sdkConfig.workingDir;
    return await breezLib.staticBackup(request: sdk.StaticBackupRequest(workingDir: workingDir));
  }
}
