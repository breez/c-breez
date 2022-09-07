import 'dart:io';

import 'package:c_breez/bloc/security/security_bloc.dart';
import 'package:c_breez/bloc/security/security_state.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/routes/security/widget/pin_code_widget.dart';
import 'package:c_breez/theme/breez_light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class LockScreen extends StatelessWidget {
  const LockScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return Scaffold(
      body: BlocBuilder<SecurityBloc, SecurityState>(
        builder: (context, state) {
          return PinCodeWidget(
            label: texts.lock_screen_enter_pin,
            localAuthenticationOption: state.localAuthenticationOption,
            testPinCodeFunction: (pin) async {
              bool pinMatches = false;
              try {
                pinMatches = await context.read<SecurityBloc>().testPin(pin);
              } catch (e) {
                return TestPinResult(
                  false,
                  errorMessage: texts.lock_screen_pin_match_exception,
                );
              }
              if (pinMatches) {
                return const TestPinResult(true);
              } else {
                return TestPinResult(
                  false,
                  errorMessage: texts.lock_screen_pin_incorrect,
                );
              }
            },
            testBiometricsFunction: () async {
              bool pinMatches = await context
                  .read<SecurityBloc>()
                  .localAuthentication(texts.security_and_backup_validate_biometrics_reason);
              if (pinMatches) {
                return const TestPinResult(true);
              } else {
                return TestPinResult(
                  false,
                  errorMessage: texts.lock_screen_pin_incorrect,
                );
              }
            },
          );
        },
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBlocOverrides.runZoned(
    () => runApp(MultiBlocProvider(
      providers: [
        BlocProvider<SecurityBloc>(
          create: (BuildContext context) => SecurityBloc(),
        ),
      ],
      child: MaterialApp(
        theme: breezLightTheme,
        home: const LockScreen(),
      ),
    )),
    storage: await HydratedStorage.build(
      storageDirectory: Directory(join((await getApplicationDocumentsDirectory()).path, "preview_storage")),
    ),
  );
}
