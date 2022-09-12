import 'dart:async';
import 'dart:io';

import 'package:c_breez/bloc/security/security_state.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/types/auth_messages_ios.dart';

class SecurityBloc extends Cubit<SecurityState> with HydratedMixin {
  final _log = FimberLog("LocalAuthenticationService");
  final _auth = LocalAuthentication();
  final _secureStorage = const FlutterSecureStorage();

  SecurityBloc() : super(const SecurityState.initial());

  Future setPin(String pin) async {
    await _secureStorage.write(key: "pinCode", value: pin);
    emit(state.copyWith(
      pinStatus: PinStatus.enabled,
    ));
  }

  Future<bool> testPin(String pin) async {
    final storedPin = await _secureStorage.read(key: "pinCode");
    if (storedPin == null) {
      throw SecurityStorageException();
    }
    return storedPin == pin;
  }

  Future clearPin() async {
    await _secureStorage.delete(key: "pinCode");
    emit(state.copyWith(
      pinStatus: PinStatus.disabled,
    ));
  }

  Future setLockInterval(Duration lockInterval) async {
    emit(state.copyWith(
      lockInterval: lockInterval,
    ));
  }

  Future clearLocalAuthentication() async {
    emit(state.copyWith(
      localAuthenticationOption: LocalAuthenticationOption.none,
    ));
  }

  Future enableLocalAuthentication() async {
    emit(state.copyWith(
      localAuthenticationOption: await localAuthenticationOption(),
    ));
  }

  Future<LocalAuthenticationOption> localAuthenticationOption() async {
    final availableBiometrics = await _auth.getAvailableBiometrics();
    if (availableBiometrics.contains(BiometricType.face)) {
      return Platform.isIOS ? LocalAuthenticationOption.faceId : LocalAuthenticationOption.face;
    }
    if (availableBiometrics.contains(BiometricType.fingerprint)) {
      return Platform.isIOS ? LocalAuthenticationOption.touchId : LocalAuthenticationOption.fingerprint;
    }
    final otherBiometrics = await _auth.isDeviceSupported();
    return otherBiometrics ? LocalAuthenticationOption.other : LocalAuthenticationOption.none;
  }

  Future<bool> localAuthentication(String localizedReason) async {
    try {
      return await _auth.authenticate(
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: false,
        ),
        localizedReason: localizedReason,
        authMessages: const [
          AndroidAuthMessages(),
          IOSAuthMessages(),
        ],
      );
    } on PlatformException catch (error) {
      if (error.code == "LockedOut" || error.code == "PermanentlyLockedOut") {
        throw error.message!;
      }
      _log.e("Error Code: ${error.code} - Message: ${error.message}", ex: error);
      await _auth.stopAuthentication();
      return false;
    }
  }

  @override
  SecurityState? fromJson(Map<String, dynamic> json) {
    return SecurityState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(SecurityState state) {
    return state.toJson();
  }
}

class SecurityStorageException implements Exception {}
