// ignore_for_file: avoid_print

import 'dart:async';

import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/onboarding_preferences.dart';
import 'package:c_breez/bloc/backup/backup_bloc.dart';
import 'package:c_breez/bloc/buy_bitcoin/moonpay/moonpay_bloc.dart';
import 'package:c_breez/bloc/connectivity/connectivity_bloc.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/error_report_bloc/error_report_bloc.dart';
import 'package:c_breez/bloc/health_check/health_check_bloc.dart';
import 'package:c_breez/bloc/input/input_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/bloc/network/network_settings_bloc.dart';
import 'package:c_breez/bloc/payment_options/payment_options_bloc.dart';
import 'package:c_breez/bloc/redeem_onchain_funds/redeem_onchain_funds_bloc.dart';
import 'package:c_breez/bloc/refund/refund_bloc.dart';
import 'package:c_breez/bloc/reverse_swap/reverse_swap_bloc.dart';
import 'package:c_breez/bloc/sdk_connectivity/sdk_connectivity_cubit.dart';
import 'package:c_breez/bloc/security/security_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/bloc/webhooks/webhooks_bloc.dart';
import 'package:c_breez/configs/config.dart' as cfg;
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/user_app.dart';
import 'package:c_breez/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preference_app_group/shared_preference_app_group.dart';

final _log = Logger("Main");

void main() async {
  // runZonedGuarded wrapper is required to log Dart errors.
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
      //initializeDateFormatting(Platform.localeName, null);
      BreezDateUtils.setupLocales();
      await Firebase.initializeApp();
      final injector = ServiceInjector();
      var breezLogger = injector.breezLogger;
      final breezSDK = injector.breezSDK;
      if (!await breezSDK.isInitialized()) {
        breezSDK.initialize();
        breezLogger.registerBreezSdkLog(breezSDK);
      }

      final appDir = await getApplicationDocumentsDirectory();
      final config = await cfg.Config.instance();

      // iOS Extension requirement
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        SharedPreferenceAppGroup.setAppGroup(
          "group.${const String.fromEnvironment("APP_ID_PREFIX")}.com.cBreez.client",
        );
      }

      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory(p.join(appDir.path, "bloc_storage")),
      );

      final SdkConnectivityCubit sdkConnectivityCubit = SdkConnectivityCubit(
        breezSDK: injector.breezSDK,
        credentialsManager: injector.credentialsManager,
      );
      final bool isOnboardingComplete = await OnboardingPreferences.isOnboardingComplete();
      if (isOnboardingComplete) {
        _log.info('Reconnect if secure storage has mnemonic.');
        final String? mnemonic = await injector.credentialsManager.restoreMnemonic();
        if (mnemonic != null) {
          await sdkConnectivityCubit.reconnect(mnemonic: mnemonic);
        }
      }
      runApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<LSPBloc>(create: (BuildContext context) => LSPBloc(breezSDK)),
            BlocProvider<AccountBloc>(create: (BuildContext context) => AccountBloc(breezSDK)),
            BlocProvider<InputBloc>(
              create: (BuildContext context) =>
                  InputBloc(breezSDK, injector.lightningLinks, injector.deviceClient),
            ),
            BlocProvider<UserProfileBloc>(create: (BuildContext context) => UserProfileBloc()),
            BlocProvider<WebhooksBloc>(
              lazy: false,
              create: (BuildContext context) =>
                  WebhooksBloc(breezSDK, injector.breezPreferences, injector.notifications),
            ),
            BlocProvider<CurrencyBloc>(create: (BuildContext context) => CurrencyBloc(breezSDK)),
            BlocProvider<SecurityBloc>(create: (BuildContext context) => SecurityBloc()),
            BlocProvider<RedeemOnchainFundsBloc>(
              create: (BuildContext context) => RedeemOnchainFundsBloc(breezSDK),
            ),
            BlocProvider<ReverseSwapBloc>(create: (BuildContext context) => ReverseSwapBloc(breezSDK)),
            BlocProvider<ConnectivityBloc>(create: (BuildContext context) => ConnectivityBloc()),
            BlocProvider<RefundBloc>(create: (BuildContext context) => RefundBloc(breezSDK)),
            BlocProvider<NetworkSettingsBloc>(
              create: (BuildContext context) => NetworkSettingsBloc(injector.breezPreferences, config),
            ),
            BlocProvider<PaymentOptionsBloc>(
              create: (BuildContext context) => PaymentOptionsBloc(injector.breezPreferences),
            ),
            BlocProvider<MoonPayBloc>(
              create: (BuildContext context) => MoonPayBloc(breezSDK, injector.breezPreferences),
            ),
            BlocProvider<BackupBloc>(create: (BuildContext context) => BackupBloc(breezSDK)),
            BlocProvider<HealthCheckBloc>(create: (BuildContext context) => HealthCheckBloc(breezSDK)),
            BlocProvider<ErrorReportBloc>(create: (BuildContext context) => ErrorReportBloc(breezSDK)),
            BlocProvider<SdkConnectivityCubit>(create: (BuildContext context) => sdkConnectivityCubit),
          ],
          child: UserApp(),
        ),
      );
    },
    (error, stackTrace) async {
      if (error is! FlutterErrorDetails) {
        _log.severe("FlutterError: $error", error, stackTrace);
      }
    },
  );
}
