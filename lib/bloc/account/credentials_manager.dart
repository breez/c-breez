import 'dart:io';

import 'package:breez_sdk/sdk.dart' as sdk;
import 'package:c_breez/config.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/services/keychain.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

class CredentialsManager {
  final _log = Logger("CredentialsManager");
  static const String accountMnemonic = "account_mnemonic";
  static const String accountApiKey = "account_api_key";

  final KeyChain keyChain;

  CredentialsManager({required this.keyChain});

  Future storeApiKey({
    required String apiKey,
  }) async {
    try {
      await keyChain.write(accountApiKey, apiKey);
      _log.info("Stored api key successfully");
    } catch (err) {
      throw Exception(err.toString());
    }
  }

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
    final breezSDK = ServiceInjector().breezSDK;
    Config config = await Config.instance();
    String workingDir = config.sdkConfig.workingDir;
    final req = sdk.StaticBackupRequest(workingDir: workingDir);
    return await breezSDK.staticBackup(req: req);
  }
}
