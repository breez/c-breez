import 'dart:io';

import 'package:breez_sdk/bridge_generated.dart' as sdk;
import 'package:c_breez/configs/config.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/services/keychain.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

final Logger _logger = Logger('CredentialsManager');

class CredentialsManager {
  static const String accountMnemonic = 'account_mnemonic';
  static const String accountApiKey = 'account_api_key';

  final KeyChain keyChain;

  CredentialsManager({required this.keyChain});

  Future<void> storeBreezApiKey({required String breezApiKey}) async {
    try {
      await _storeBreezApiKey(breezApiKey);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<String?> restoreBreezApiKey() async {
    try {
      final String? mnemonicStr = await keyChain.read(accountApiKey);
      return mnemonicStr;
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<void> deleteBreezApiKey() async {
    try {
      await keyChain.delete(accountApiKey);
      _logger.info('Deleted Breez API key successfully');
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<void> storeMnemonic({required String mnemonic}) async {
    try {
      await _storeMnemonic(mnemonic);
      _logger.info('Stored credentials successfully');
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<String?> restoreMnemonic() async {
    try {
      final String? mnemonicStr = await keyChain.read(accountMnemonic);
      _logger.info(
        (mnemonicStr != null)
            ? 'Restored credentials successfully'
            : 'No credentials found in secure storage',
      );
      return mnemonicStr;
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<void> deleteMnemonic() async {
    try {
      await keyChain.delete(accountMnemonic);
      _logger.info('Deleted credentials successfully');
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  // Helper methods
  Future<void> _storeBreezApiKey(String breezApiKey) async {
    await keyChain.write(accountApiKey, breezApiKey);
  }

  Future<void> _storeMnemonic(String mnemonic) async {
    await keyChain.write(accountMnemonic, mnemonic);
  }

  Future<List<File>> exportCredentials() async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final Directory keysDir = tempDir.createTempSync('keys');
      final String fileName = 'c-breez.backup-phrase.txt';
      final File mnemonicFile = await File('${keysDir.path}/$fileName').create(recursive: true);
      final String? mnemonic = await restoreMnemonic();
      if (mnemonic != null) {
        mnemonicFile.writeAsString(mnemonic);
      } else {
        throw Exception('No mnemonics');
      }
      return <File>[mnemonicFile];
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
