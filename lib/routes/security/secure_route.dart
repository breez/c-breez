import 'package:c_breez/bloc/security/security_bloc.dart';
import 'package:c_breez/bloc/security/security_state.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/routes/lock_screen/widget/pin_code_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SecureRoute<T> extends CupertinoPageRoute<T> {
  SecureRoute({
    required Route<T> protectedRoute,
    RouteSettings? settings,
  }) : super(
          builder: (_) => _SecureRouteWidget(
            protectedRoute: protectedRoute,
          ),
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }
}

class _SecureRouteWidget<T> extends StatelessWidget {
  final Route<T> protectedRoute;

  const _SecureRouteWidget({
    Key? key,
    required this.protectedRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: GlobalKey<ScaffoldState>(),
      ),
      body: BlocConsumer<SecurityBloc, SecurityState>(
        listener: (context, state) {
          if (state.pinStatus != PinStatus.enabled) {
            _continueToProtectedRoute(context);
          }
        },
        builder: (context, state) {
          if (state.pinStatus == PinStatus.enabled) {
            final texts = context.texts();
            return PinCodeWidget(
              label: texts.lock_screen_enter_pin,
              testPinCodeFunction: (pin) async {
                bool pinMatches = false;
                try {
                  pinMatches = await context.read<SecurityBloc>().testPin(pin);
                } catch (e) {
                  return TestPinResult(false, errorMessage: texts.lock_screen_pin_match_exception);
                }
                if (pinMatches) {
                  _continueToProtectedRoute(context);
                  return const TestPinResult(true);
                } else {
                  return TestPinResult(false, errorMessage: texts.lock_screen_pin_incorrect);
                }
              },
            );
          } else {
            Future.microtask(() => _continueToProtectedRoute(context));
            return Container();
          }
        },
      ),
    );
  }

  void _continueToProtectedRoute(BuildContext context) {
    Navigator.of(context).pushReplacement(protectedRoute);
  }
}
