import 'dart:async';

import 'package:c_breez/bloc/security/mnemonic_verification_status_preferences.dart';
import 'package:c_breez/bloc/security/security_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:local_auth/local_auth.dart' as l_auth;
import 'package:local_auth_android/local_auth_android.dart' hide BiometricType;
import 'package:local_auth_darwin/types/auth_messages_ios.dart';
import 'package:logging/logging.dart';

class SecurityBloc extends Cubit<SecurityState> with HydratedMixin {
  final _log = Logger("LocalAuthenticationService");
  final _auth = l_auth.LocalAuthentication();
  final _secureStorage = const FlutterSecureStorage();
  Timer? _autoLock;

  SecurityBloc() : super(const SecurityState.initial()) {
    hydrate();
    _initializeSecurityState();
  }

  /// Initializes the security state by loading verification status and setting up
  /// background lock listeners
  Future<void> _initializeSecurityState() async {
    await _loadMnemonicVerificationStatus();
    _setupBackgroundLockListener();
  }

  /// Sets up the app background/foreground listener to manage auto-locking
  void _setupBackgroundLockListener() {
    FGBGEvents.stream.listen((event) {
      final lockInterval = state.lockInterval;
      if (event == FGBGType.foreground) {
        _autoLock?.cancel();
        _autoLock = null;
      } else {
        if (state.pinStatus == PinStatus.enabled) {
          _autoLock = Timer(lockInterval, () {
            _setLockState(LockState.locked);
            _autoLock = null;
          });
        }
      }
    });
  }

  Future setPin(String pin) async {
    await _secureStorage.write(key: "pinCode", value: pin);
    emit(state.copyWith(pinStatus: PinStatus.enabled));
  }

  Future<bool> testPin(String pin) async {
    final storedPin = await _secureStorage.read(key: "pinCode");
    if (storedPin == null) {
      _setLockState(LockState.locked);
      throw SecurityStorageException();
    }
    return storedPin == pin;
  }

  Future clearPin() async {
    await _secureStorage.delete(key: "pinCode");
    emit(state.copyWith(pinStatus: PinStatus.disabled));
    _setLockState(LockState.unlocked);
  }

  Future setLockInterval(Duration lockInterval) async {
    emit(state.copyWith(lockInterval: lockInterval));
    _setLockState(LockState.unlocked);
  }

  Future clearLocalAuthentication() async {
    emit(state.copyWith(localAuthenticationOption: BiometricType.none));
    _setLockState(LockState.unlocked);
  }

  Future enableLocalAuthentication() async {
    emit(state.copyWith(localAuthenticationOption: await localAuthenticationOption()));
    _setLockState(LockState.unlocked);
  }

  Future<BiometricType> localAuthenticationOption() async {
    final availableBiometrics = await _auth.getAvailableBiometrics();
    if (availableBiometrics.contains(l_auth.BiometricType.face)) {
      return defaultTargetPlatform == TargetPlatform.iOS ? BiometricType.faceId : BiometricType.face;
    }
    if (availableBiometrics.contains(l_auth.BiometricType.fingerprint)) {
      return defaultTargetPlatform == TargetPlatform.iOS ? BiometricType.touchId : BiometricType.fingerprint;
    }
    final otherBiometrics = await _auth.isDeviceSupported();
    return otherBiometrics ? BiometricType.other : BiometricType.none;
  }

  Future<bool> localAuthentication(String localizedReason) async {
    try {
      final authenticated = await _auth.authenticate(
        options: const AuthenticationOptions(biometricOnly: true, useErrorDialogs: false),
        localizedReason: localizedReason,
        authMessages: const [AndroidAuthMessages(), IOSAuthMessages()],
      );
      _setLockState(authenticated ? LockState.unlocked : LockState.locked);
      return authenticated;
    } on PlatformException catch (error) {
      if (error.code == "LockedOut" || error.code == "PermanentlyLockedOut") {
        throw error.message!;
      }
      _log.severe("Error Code: ${error.code} - Message: ${error.message}", error);
      await _auth.stopAuthentication();
      _setLockState(LockState.locked);
      return false;
    }
  }

  void _setLockState(LockState lockState) {
    emit(state.copyWith(lockState: lockState));
  }

  /// Loads the mnemonic verification status from preferences
  Future<void> _loadMnemonicVerificationStatus() async {
    try {
      final bool isVerified = await MnemonicVerificationStatusPreferences.isVerificationComplete();
      emit(state.copyWith(mnemonicStatus: isVerified ? MnemonicStatus.verified : MnemonicStatus.unverified));
      _log.info('Mnemonic verification status loaded: ${isVerified ? 'verified' : 'unverified'}');
    } catch (e) {
      _log.severe('Error loading mnemonic verification status: $e');
      // Keep default unverified status on error
    }
  }

  /// Marks the mnemonic as verified by the user
  Future<void> completeMnemonicVerification() async {
    try {
      await MnemonicVerificationStatusPreferences.setVerificationComplete(true);
      await _loadMnemonicVerificationStatus();
      _log.info('Mnemonic verification completed');
    } catch (e) {
      _log.severe('Error completing mnemonic verification: $e');
      throw Exception('Failed to save mnemonic verification status: $e');
    }
  }

  @override
  SecurityState? fromJson(Map<String, dynamic> json) {
    final state = SecurityState.fromJson(json);
    _setLockState(state.pinStatus == PinStatus.enabled ? LockState.locked : LockState.unlocked);
    return state;
  }

  @override
  Map<String, dynamic>? toJson(SecurityState state) {
    return state.toJson();
  }

  @override
  String get storagePrefix => "SecurityBloc";
}

class SecurityStorageException implements Exception {}
