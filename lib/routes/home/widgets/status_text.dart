import 'package:auto_size_text/auto_size_text.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/utils/min_font_size.dart';
import 'package:c_breez/widgets/loading_animated_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StatusText extends StatelessWidget {
  final String? message;
  final bool isConnecting;

  const StatusText({
    Key? key,
    this.message,
    this.isConnecting = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isConnecting || message != null) {
      return LoadingAnimatedText(isConnecting ? "" : message!);
    } else {
      final texts = context.texts();
      final themeData = Theme.of(context);

      return AutoSizeText(
        texts.status_text_ready,
        style: themeData.textTheme.bodyText2?.copyWith(
          color: themeData.colorScheme.onSecondary,
        ),
        textAlign: TextAlign.center,
        minFontSize: MinFontSize(context).minFontSize,
        stepGranularity: 0.1,
      );
    }
  }
}
