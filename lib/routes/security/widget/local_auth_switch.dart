import 'package:c_breez/bloc/security/security_bloc.dart';
import 'package:c_breez/bloc/security/security_state.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocalAuthSwitch extends StatelessWidget {
  const LocalAuthSwitch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();
    final securityBloc = context.read<SecurityBloc>();

    return FutureBuilder<LocalAuthenticationOption>(
      future: securityBloc.localAuthenticationOption(),
      initialData: LocalAuthenticationOption.none,
      builder: (context, snapshot) {
        final availableOption = snapshot.data ?? LocalAuthenticationOption.none;
        if (availableOption == LocalAuthenticationOption.none) {
          return Container();
        } else {
          return BlocBuilder<SecurityBloc, SecurityState>(
            builder: (context, state) {
              final localAuthEnabled = state.localAuthenticationOption != LocalAuthenticationOption.none;
              return ListTile(
                title: Text(
                  _localAuthenticationOptionLabel(
                    context,
                    localAuthEnabled ? state.localAuthenticationOption : availableOption,
                  ),
                  style: themeData.primaryTextTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
                  maxLines: 1,
                ),
                trailing: Switch(
                  key: const Key("local_auth_switch"),
                  activeColor: Colors.white,
                  value: localAuthEnabled,
                  onChanged: (switchEnabled) {
                    if (switchEnabled) {
                      securityBloc.localAuthentication(texts.security_and_backup_validate_biometrics_reason).then(
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
                  },
                ),
              );
            },
          );
        }
      },
    );
  }

  String _localAuthenticationOptionLabel(
    BuildContext context,
    LocalAuthenticationOption authenticationOption,
  ) {
    final texts = context.texts();
    switch (authenticationOption) {
      case LocalAuthenticationOption.face:
        return texts.security_and_backup_enable_biometric_option_face;
      case LocalAuthenticationOption.faceId:
        return texts.security_and_backup_enable_biometric_option_face_id;
      case LocalAuthenticationOption.fingerprint:
        return texts.security_and_backup_enable_biometric_option_fingerprint;
      case LocalAuthenticationOption.touchId:
        return texts.security_and_backup_enable_biometric_option_touch_id;
      case LocalAuthenticationOption.other:
        return texts.security_and_backup_enable_biometric_option_other;
      case LocalAuthenticationOption.none:
      default:
        return texts.security_and_backup_enable_biometric_option_none;
    }
  }
}
