import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/security/security_bloc.dart';
import 'package:c_breez/bloc/security/security_state.dart';
import 'package:c_breez/widgets/designsystem/switch/simple_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocalAuthSwitch extends StatelessWidget {
  const LocalAuthSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final securityBloc = context.read<SecurityBloc>();

    return FutureBuilder<BiometricType>(
      future: securityBloc.localAuthenticationOption(),
      initialData: BiometricType.none,
      builder: (context, snapshot) {
        final availableOption = snapshot.data ?? BiometricType.none;
        if (availableOption == BiometricType.none) {
          return Container();
        } else {
          return BlocBuilder<SecurityBloc, SecurityState>(
            builder: (context, state) {
              final localAuthEnabled = state.localAuthenticationOption != BiometricType.none;
              return SimpleSwitch(
                text: _localAuthenticationOptionLabel(
                  context,
                  localAuthEnabled ? state.localAuthenticationOption : availableOption,
                ),
                switchValue: localAuthEnabled,
                onChanged: (value) => _localAuthenticationOptionChanged(context, value),
              );
            },
          );
        }
      },
    );
  }

  void _localAuthenticationOptionChanged(BuildContext context, bool switchEnabled) {
    final texts = context.texts();
    final securityBloc = context.read<SecurityBloc>();
    if (switchEnabled) {
      securityBloc
          .localAuthentication(texts.security_and_backup_validate_biometrics_reason)
          .then(
            (authenticated) {
              if (authenticated) {
                securityBloc.enableLocalAuthentication();
              } else {
                securityBloc.clearLocalAuthentication();
              }
            },
            onError: (error) {
              securityBloc.clearLocalAuthentication();
            },
          );
    } else {
      securityBloc.clearLocalAuthentication();
    }
  }

  String _localAuthenticationOptionLabel(BuildContext context, BiometricType authenticationOption) {
    final texts = context.texts();
    switch (authenticationOption) {
      case BiometricType.face:
        return texts.security_and_backup_enable_biometric_option_face;
      case BiometricType.faceId:
        return texts.security_and_backup_enable_biometric_option_face_id;
      case BiometricType.fingerprint:
        return texts.security_and_backup_enable_biometric_option_fingerprint;
      case BiometricType.touchId:
        return texts.security_and_backup_enable_biometric_option_touch_id;
      case BiometricType.other:
        return texts.security_and_backup_enable_biometric_option_other;
      case BiometricType.none:
        return texts.security_and_backup_enable_biometric_option_none;
    }
  }
}
