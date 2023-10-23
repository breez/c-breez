import 'package:c_breez/bloc/buy_bitcoin/moonpay/moonpay_bloc.dart';
import 'package:c_breez/bloc/buy_bitcoin/moonpay/moonpay_state.dart';
import 'package:c_breez/routes/buy_bitcoin/moonpay/moonpay_loading.dart';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

final _log = Logger("MoonpayWebView");

class MoonpayWebView extends StatelessWidget {
  final String url;

  const MoonpayWebView({
    super.key,
    required this.url,
  });

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
            _log.info("onLoadStart url: $url");
            context.read<MoonPayBloc>().updateWebViewStatus(WebViewStatus.loading);
          },
          onLoadStop: (controller, url) {
            _log.info("onLoadStop url: $url");
            context.read<MoonPayBloc>().updateWebViewStatus(WebViewStatus.success);
          },
          onReceivedError: (controller, request, error) {
            _log.warning("onReceivedError error: $error", error);
            if (error.type == WebResourceErrorType.UNKNOWN) {
              _log.info("Ignoring unknown error");
              return;
            }
            context.read<MoonPayBloc>().updateWebViewStatus(WebViewStatus.error);
          },
          onReceivedHttpError: (controller, request, error) {
            _log.warning("onReceivedHttpError error: $error", error);
            context.read<MoonPayBloc>().updateWebViewStatus(WebViewStatus.error);
          },
          onConsoleMessage: (controller, consoleMessage) {
            _log.info("onConsoleMessage: $consoleMessage");
          },
        ),
      ],
    );
  }
}
