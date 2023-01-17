import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher_string.dart';

final _log = FimberLog("ExternalBrowser");

Future<void> launchLinkOnExternalBrowser(
  BuildContext context, {
  required String linkAddress,
}) async {
  final texts = context.texts();
  final navigator = Navigator.of(context);
  var loaderRoute = createLoaderRoute(context);
  navigator.push(loaderRoute);
  try {
    if (await canLaunchUrlString(linkAddress)) {
      final themeData = Theme.of(context);
      await ChromeSafariBrowser().open(
        url: WebUri(linkAddress),
        settings: ChromeSafariBrowserSettings(
          // Android
          shareState: CustomTabsShareState.SHARE_STATE_ON,
          showTitle: true,
          // iOS
          dismissButtonStyle: DismissButtonStyle.CLOSE,
          barCollapsingEnabled: true,
          // Styling
          // Android
          toolbarBackgroundColor: themeData.appBarTheme.backgroundColor,
          navigationBarColor: themeData.bottomAppBarTheme.color,
          // iOS 10.0+
          preferredControlTintColor: Colors.white,
          preferredBarTintColor: themeData.appBarTheme.backgroundColor,
        ),
      );
    } else {
      throw Exception(texts.link_launcher_failed_to_launch(linkAddress));
    }
  } catch (error) {
    _log.w(error.toString(), ex: error);
    rethrow;
  } finally {
    navigator.removeRoute(loaderRoute);
  }
}
