import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/routes/lnurl/auth/login_text.dart';
import 'package:c_breez/routes/lnurl/widgets/lnurl_page_result.dart';
import 'package:c_breez/widgets/error_dialog.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<LNURLPageResult?> handleAuthRequest(
  BuildContext context,
  LnUrlAuthRequestData requestData,
) async {
  final log = FimberLog("handleLNURLAuthRequest");
  return promptAreYouSure(context, null, LoginText(domain: requestData.domain)).then(
    (permitted) async {
      if (permitted == true) {
        final texts = context.texts();
        final navigator = Navigator.of(context);
        final loaderRoute = createLoaderRoute(context);
        navigator.push(loaderRoute);
        try {
          final resp = await context.read<AccountBloc>().lnurlAuth(reqData: requestData);
          if (resp is LnUrlCallbackStatus_Ok) {
            log.v("LNURL auth success");
            return const LNURLPageResult(protocol: LnUrlProtocol.Auth);
          } else if (resp is LnUrlCallbackStatus_ErrorStatus) {
            log.v("LNURL auth failed: ${resp.data.reason}");
            return LNURLPageResult(protocol: LnUrlProtocol.Auth, error: resp.data.reason);
          } else {
            log.w("Unknown response from lnurlAuth: $resp");
            return LNURLPageResult(
              protocol: LnUrlProtocol.Auth,
              error: texts.lnurl_payment_page_unknown_error,
            );
          }
        } catch (e) {
          log.w("Error authenticating LNURL auth", ex: e);
          if (loaderRoute.isActive) {
            navigator.removeRoute(loaderRoute);
          }
          return LNURLPageResult(protocol: LnUrlProtocol.Auth, error: e);
        } finally {
          if (loaderRoute.isActive) {
            navigator.removeRoute(loaderRoute);
          }
        }
      }
      return Future.value();
    },
  );
}

void handleLNURLAuthPageResult(BuildContext context, LNURLPageResult result) {
  final log = FimberLog("handleLNURLAuthPageResult");
  if (result.hasError) {
    log.v("Handle LNURL auth page result with error '${result.error}'");
    promptError(
      context,
      context.texts().lnurl_webview_error_title,
      Text(result.errorMessage),
      okFunc: () => Navigator.of(context).pop(),
    );
    throw result.error!;
  }
}
