import 'package:c_breez/bloc/buy_bitcoin/moonpay/moonpay_bloc.dart';
import 'package:c_breez/bloc/buy_bitcoin/moonpay/moonpay_state.dart';
import 'package:c_breez/routes/buy_bitcoin/moonpay/moonpay_loading.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

final _log = FimberLog("MoonpayWebView");

class MoonpayWebView extends StatelessWidget {
  final String url;

  const MoonpayWebView({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const MoonpayLoading(),
        InAppWebView(
          initialSettings: InAppWebViewSettings(
            transparentBackground: true,
            disableDefaultErrorPage: true,
            sharedCookiesEnabled: true,
            applePayAPIEnabled: true,
          ),
          initialUrlRequest: URLRequest(
            url: WebUri(url),
          ),
          onLoadStart: (controller, url) {
            _log.v("onLoadStart url: $url");
            context.read<MoonPayBloc>().updateWebViewStatus(WebViewStatus.loading);
          },
          onLoadStop: (controller, url) {
            _log.v("onLoadStop url: $url");
            context.read<MoonPayBloc>().updateWebViewStatus(WebViewStatus.success);
          },
          onReceivedError: (controller, request, error) {
            _log.w("onReceivedError error: $error", ex: error);
            if (error.type == WebResourceErrorType.UNKNOWN) {
              _log.v("Ignoring unknown error");
              return;
            }
            context.read<MoonPayBloc>().updateWebViewStatus(WebViewStatus.error);
          },
          onReceivedHttpError: (controller, request, error) {
            _log.w("onReceivedHttpError error: $error", ex: error);
            context.read<MoonPayBloc>().updateWebViewStatus(WebViewStatus.error);
          },
          onConsoleMessage: (controller, consoleMessage) {
            _log.v("onConsoleMessage: $consoleMessage");
          },
        ),
      ],
    );
  }
}
