import 'dart:async';

import 'package:c_breez/bloc/security/security_state.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class SecurityBloc extends Cubit<SecurityState> with HydratedMixin {
  final _secureStorage = const FlutterSecureStorage();

  SecurityBloc() : super(const SecurityState.initial());

  Future setPin(String pin) async {
    await _secureStorage.write(key: "pinCode", value: pin);
    emit(state.copyWith(
      pinStatus: PinStatus.enabled,
    ));
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

  @override
  SecurityState? fromJson(Map<String, dynamic> json) {
    return SecurityState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(SecurityState state) {
    return state.toJson();
  }
}
