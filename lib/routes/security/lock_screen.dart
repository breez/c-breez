import 'dart:io';

import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/security/security_bloc.dart';
import 'package:c_breez/bloc/security/security_state.dart';
import 'package:c_breez/routes/security/widget/pin_code_widget.dart';
import 'package:c_breez/theme/breez_light_theme.dart';
import 'package:c_breez/widgets/route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class LockScreen extends StatelessWidget {
  final AuthorizedAction authorizedAction;

  const LockScreen({
    super.key,
    required this.authorizedAction,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final navigator = Navigator.of(context);

    return WillPopScope(
      onWillPop: () => SynchronousFuture(false),
      child: Scaffold(
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
                  _authorized(navigator);
                  return const TestPinResult(true);
                } else {
                  return TestPinResult(
                    false,
                    errorMessage: texts.lock_screen_pin_incorrect,
                  );
                }
              },
              testBiometricsFunction: () async {
                bool pinMatches = await context.read<SecurityBloc>().localAuthentication(
                      texts.security_and_backup_validate_biometrics_reason,
                    );
                if (pinMatches) {
                  _authorized(navigator);
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
      ),
    );
  }

  void _authorized(NavigatorState navigator) {
    switch (authorizedAction) {
      case AuthorizedAction.launchHome:
        navigator.pushReplacementNamed("/");
        break;
      case AuthorizedAction.popPage:
        navigator.pop(true);
        break;
    }
  }
}

enum AuthorizedAction {
  launchHome,
  popPage,
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: Directory(
      join((await getApplicationDocumentsDirectory()).path, "preview_storage"),
    ),
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<SecurityBloc>(
          create: (BuildContext context) => SecurityBloc(),
        ),
      ],
      child: MaterialApp(
        theme: breezLightTheme,
        home: LayoutBuilder(
          builder: (context, _) => Center(
            child: TextButton(
              child: const Text("Launch lock screen"),
              onPressed: () => Navigator.of(context).push(
                FadeInRoute(
                  builder: (_) => const LockScreen(
                    authorizedAction: AuthorizedAction.popPage,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
