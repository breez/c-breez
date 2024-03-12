import 'package:c_breez/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class LoadingOrError extends StatelessWidget {
  final Object? error;
  final String displayErrorMessage;

  const LoadingOrError({
    super.key,
    this.error,
    required this.displayErrorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    if (error == null) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 310.0,
        child: Align(
          alignment: const Alignment(0, -0.33),
          child: SizedBox(
            height: 80.0,
            width: 80.0,
            child: CircularProgressIndicator(
              valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.white,
              ),
              backgroundColor: themeData.isLightTheme
                  ? themeData.colorScheme.onSecondary
                  : themeData.colorScheme.background,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Text(
        displayErrorMessage,
        style: themeData.primaryTextTheme.displaySmall!.copyWith(
          fontSize: 16,
        ),
      ),
    );
  }
}
