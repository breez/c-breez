import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/lsp/lsp_state.dart';
import 'package:c_breez/bloc/sdk_connectivity/sdk_connectivity_state.dart';
import 'package:c_breez/theme/theme_provider.dart';
import 'package:c_breez/utils/utils.dart';
import 'package:c_breez/widgets/loading_animated_text.dart';
import 'package:flutter/material.dart';

class StatusText extends StatelessWidget {
  final SdkConnectivityState sdkConnectivityState;
  final AccountState accountState;
  final LspState? lspState;

  const StatusText({
    super.key,
    required this.sdkConnectivityState,
    required this.accountState,
    required this.lspState,
  });

  @override
  Widget build(BuildContext context) {
    switch (sdkConnectivityState) {
      case SdkConnectivityState.connecting:
        return const LoadingAnimatedText();
      case SdkConnectivityState.connected:
        final texts = context.texts();
        final themeData = Theme.of(context);

        if (lspState == null) {
          return const LoadingAnimatedText();
        } else {
          final isChannelOpeningAvailable = lspState!.isChannelOpeningAvailable;
          return AutoSizeText(
            (isChannelOpeningAvailable && accountState.maxInboundLiquiditySat >= 0)
                ? texts.status_text_ready
                : texts.lsp_error_cannot_open_channel,
            style: themeData.textTheme.bodyMedium?.copyWith(
              color: themeData.isLightTheme ? BreezColors.grey[600] : themeData.colorScheme.onSecondary,
            ),
            textAlign: TextAlign.center,
            minFontSize: MinFontSize(context).minFontSize,
            stepGranularity: 0.1,
          );
        }
      default:
        return const SizedBox();
    }
  }
}
