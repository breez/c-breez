import 'dart:async';

import 'package:bip39/bip39.dart' as bip39;
import 'package:breez_sdk/breez_sdk.dart';
import 'package:breez_sdk/sdk.dart' as sdk;
import 'package:c_breez/bloc/account/credentials_manager.dart';
import 'package:c_breez/bloc/sdk_connectivity/sdk_connectivity_state.dart';
import 'package:c_breez/bloc/sdk_connectivity/sync_manager.dart';
import 'package:c_breez/configs/config.dart';
import 'package:c_breez/services/wallet_archive_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('SdkConnectivityCubit');

class SdkConnectivityCubit extends Cubit<SdkConnectivityState> {
  final CredentialsManager credentialsManager;
  final BreezSDK breezSDK;

  SdkConnectivityCubit({required this.credentialsManager, required this.breezSDK})
    : super(SdkConnectivityState.disconnected);

  Future<void> register() async {
    _logger.info('Registering a new wallet.');
    final String mnemonic = bip39.generateMnemonic();
    await _connect(mnemonic, storeMnemonic: true);
  }

  Future<void> restore({required String mnemonic}) async {
    _logger.info('Restoring wallet.');
    await _connect(mnemonic, storeMnemonic: true, restoreOnly: true);
  }

  Future<void> reconnect({String? mnemonic}) async {
    _logger.info(mnemonic == null ? 'Attempting to reconnect.' : 'Reconnecting.');
    try {
      final String? restoredMnemonic = mnemonic ?? await credentialsManager.restoreMnemonic();
      if (restoredMnemonic != null) {
        await _connect(restoredMnemonic, restoreOnly: true);
      } else {
        _logger.warning('Failed to restore mnemonics.');
        throw Exception('Failed to restore mnemonics.');
      }
    } catch (e) {
      _logger.warning('Failed to reconnect. Retrying when network connection is detected.');
      await _retryUntilConnected();
    }
  }

  Future<void> _connect(String mnemonic, {bool storeMnemonic = false, bool restoreOnly = false}) async {
    try {
      emit(SdkConnectivityState.connecting);
      _logger.info('Retrieving SDK configuration...');
      final Config config = await Config.instance();
      final sdk.Config sdkConfig = config.sdkConfig;
      _logger.info('SDK configuration retrieved successfully.');

      final seed = bip39.mnemonicToSeed(mnemonic);
      final sdk.ConnectRequest req = sdk.ConnectRequest(
        seed: seed,
        config: sdkConfig,
        restoreOnly: restoreOnly,
      );
      _logger.info('Using the provided mnemonic and SDK configuration to connect to Breez SDK - Native.');
      await breezSDK.connect(req: req);
      _logger.info('Successfully connected to Breez SDK - Native.');

      _startSyncing();

      await _storeBreezApiKey(sdkConfig.apiKey);
      if (storeMnemonic) {
        await credentialsManager.storeMnemonic(mnemonic: mnemonic);
      }

      emit(SdkConnectivityState.connected);
    } catch (e) {
      _logger.warning('Failed to connect to Breez SDK - Native. Reason: $e');
      if (storeMnemonic) {
        _clearStoredCredentials();
      }

      emit(SdkConnectivityState.disconnected);
      rethrow;
    }
  }

  Future<void> _storeBreezApiKey(String? breezApiKey) async {
    final String? storedBreezApiKey = await credentialsManager.restoreBreezApiKey();
    if (breezApiKey != null && breezApiKey.isNotEmpty && storedBreezApiKey != breezApiKey) {
      await credentialsManager.storeBreezApiKey(breezApiKey: breezApiKey);
    }
  }

  Future<void> _clearStoredCredentials() async {
    _logger.info('Clearing stored credentials.');
    await credentialsManager.deleteBreezApiKey();
    await credentialsManager.deleteMnemonic();
    await WalletArchiveService.clearWorkingDirContents();
    _logger.info('Successfully cleared stored credentials.');
  }

  void _startSyncing() {
    final SyncManager syncManager = SyncManager(breezSDK);
    syncManager.startSyncing();
  }

  Future<void> _retryUntilConnected() async {
    _logger.info('Subscribing to network events.');
    StreamSubscription<List<ConnectivityResult>>? subscription;
    subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> event) async {
      final bool hasNetworkConnection =
          !(event.contains(ConnectivityResult.none) ||
              event.every((ConnectivityResult result) => result == ConnectivityResult.vpn));
      // Attempt to reconnect when internet is back.
      if (hasNetworkConnection && state == SdkConnectivityState.disconnected) {
        _logger.info('Network connection detected.');
        await reconnect();
        if (state == SdkConnectivityState.connected) {
          _logger.info('SDK has reconnected. Unsubscribing from network events.');
          subscription!.cancel();
        }
      }
    });
  }
}
