import 'dart:async';

import 'package:c_breez/bloc/security/security_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class SecurityBloc extends Cubit<SecurityState> with HydratedMixin {
  SecurityBloc() : super(const SecurityState.initial());

  Future setPin() async {
    emit(state.copyWith(
      pinStatus: PinStatus.enabled,
    ));
  }

  Future clearPin() async {
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
