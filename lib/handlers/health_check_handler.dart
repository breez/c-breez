import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/health_check/health_check_bloc.dart';
import 'package:c_breez/handlers/handler.dart';
import 'package:c_breez/handlers/handler_context_provider.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logging/logging.dart';

final _log = Logger("HealthCheckHandler");

class HealthCheckHandler extends Handler {
  StreamSubscription<HealthCheckStatus>? _listener;
  Flushbar? _flushbar;

  @override
  void init(HandlerContextProvider<StatefulWidget> contextProvider) {
    super.init(contextProvider);
    final context = contextProvider.getBuildContext();
    if (context == null) {
      _log.info("HealthCheckHandler: context is null");
      return;
    }

    final texts = context.texts();
    final themeData = Theme.of(context);
    final bloc = context.read<HealthCheckBloc>();

    _listener?.cancel();
    _listener = bloc.stream.distinct().listen((event) {
      _flushbar?.dismiss();
      if (event == HealthCheckStatus.Maintenance || event == HealthCheckStatus.ServiceDisruption) {
        _log.info("Showing flushbar for: $event");
        _flushbar = showFlushbar(
          context,
          isDismissible: false,
          position: FlushbarPosition.TOP,
          duration: Duration.zero,
          message: event == HealthCheckStatus.Maintenance
              ? texts.handler_check_version_error_upgrading_servers
              : texts.handler_health_check_service_disruption,
          buttonText: "",
          icon: SvgPicture.asset(
            "src/icon/warning.svg",
            colorFilter: ColorFilter.mode(
              themeData.colorScheme.error,
              BlendMode.srcATop,
            ),
          ),
        );
      }
    }, onError: (error) {
      _log.info("HealthCheckStatus error: $error");
    });
  }

  @override
  void dispose() {
    super.dispose();
    _listener?.cancel();
    _listener = null;
    _flushbar?.dismiss();
    _flushbar = null;
  }
}
