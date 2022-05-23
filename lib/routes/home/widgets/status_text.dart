import 'package:auto_size_text/auto_size_text.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/utils/min_font_size.dart';
import 'package:c_breez/widgets/loading_animated_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatusText extends StatelessWidget {
  final String? message;

  const StatusText({
    Key? key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (message != null) {
      return LoadingAnimatedText(message!);
    } else {
      return BlocBuilder<AccountBloc, AccountState>(
        builder: (context, account) => _build(context, account),
      );
    }
  }

  Widget _build(
    BuildContext context,
    AccountState account,
  ) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    if (account.status == AccountStatus.CONNECTING) {
      return LoadingAnimatedText(
        "",
        textAlign: TextAlign.center,
        textElements: [
          TextSpan(
            text: texts.status_text_loading_begin,
            style: themeData.textTheme.bodyText2?.copyWith(
              color: themeData.colorScheme.onSecondary,
            ),
          ),
          TextSpan(
            style: themeData.textTheme.bodyText2!.copyWith(
              color: themeData.colorScheme.onSecondary,
              decoration: TextDecoration.underline,
            ),
            text: texts.status_text_loading_middle,
          ),
          TextSpan(
            text: texts.status_text_loading_end,
            style: themeData.textTheme.bodyText2?.copyWith(
              color: themeData.colorScheme.onSecondary,
            ),
          ),
        ],
      );
    }

    if (account.status == AccountStatus.CONNECTED) {
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

    return Text(
      texts.status_opening_secure_connection,
      style: themeData.textTheme.bodyText2?.copyWith(
        color: themeData.colorScheme.onSecondary,
      ),
      textAlign: TextAlign.center,
    );
  }
}
