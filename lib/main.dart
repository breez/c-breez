// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:c_breez/background/background_task_handler.dart';
import 'package:c_breez/background/breez_message_handler.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/credentials_manager.dart';
import 'package:c_breez/bloc/backup/backup_bloc.dart';
import 'package:c_breez/bloc/buy_bitcoin/moonpay/moonpay_bloc.dart';
import 'package:c_breez/bloc/connectivity/connectivity_bloc.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/fee_options/fee_options_bloc.dart';
import 'package:c_breez/bloc/input/input_bloc.dart';
import 'package:c_breez/bloc/input/input_printer.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/bloc/payment_options/payment_options_bloc.dart';
import 'package:c_breez/bloc/refund/refund_bloc.dart';
import 'package:c_breez/bloc/reverse_swap/reverse_swap_bloc.dart';
import 'package:c_breez/bloc/security/security_bloc.dart';
import 'package:c_breez/bloc/redeem_onchain_funds/redeem_onchain_funds_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/config.dart' as cfg;
import 'package:c_breez/logger.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/user_app.dart';
import 'package:c_breez/utils/date.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'bloc/network/network_settings_bloc.dart';

final _log = Logger("Main");

void main() async {
  // runZonedGuarded wrapper is required to log Dart errors.
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    final logger = BreezLogger();
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );
    //initializeDateFormatting(Platform.localeName, null);
    BreezDateUtils.setupLocales();
    await Firebase.initializeApp();
    final injector = ServiceInjector();

    final breezSDK = injector.breezSDK;
    if (!await breezSDK.isInitialized()) {
      breezSDK.initialize();
      logger.registerBreezSdkLog(breezSDK);
    }

    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
    final appDir = await getApplicationDocumentsDirectory();
    final config = await cfg.Config.instance();

    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: Directory(p.join(appDir.path, "bloc_storage")),
    );
    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<LSPBloc>(
            create: (BuildContext context) => LSPBloc(breezSDK),
          ),
          BlocProvider<AccountBloc>(
            create: (BuildContext context) => AccountBloc(
              breezSDK,
              CredentialsManager(keyChain: injector.keychain),
            ),
          ),
          BlocProvider<InputBloc>(
            create: (BuildContext context) => InputBloc(
              breezSDK,
              injector.lightningLinks,
              injector.device,
              const InputPrinter(),
            ),
          ),
          BlocProvider<UserProfileBloc>(
            create: (BuildContext context) => UserProfileBloc(
              breezSDK,
              injector.breezServer,
              injector.notifications,
            ),
          ),
          BlocProvider<CurrencyBloc>(
            create: (BuildContext context) => CurrencyBloc(breezSDK),
          ),
          BlocProvider<SecurityBloc>(
            create: (BuildContext context) => SecurityBloc(),
          ),
          BlocProvider<RedeemOnchainFundsBloc>(
            create: (BuildContext context) => RedeemOnchainFundsBloc(breezSDK),
          ),
          BlocProvider<ReverseSwapBloc>(
            create: (BuildContext context) => ReverseSwapBloc(breezSDK),
          ),
          BlocProvider<FeeOptionsBloc>(
            create: (BuildContext context) => FeeOptionsBloc(breezSDK),
          ),
          BlocProvider<ConnectivityBloc>(
            create: (BuildContext context) => ConnectivityBloc(),
          ),
          BlocProvider<RefundBloc>(
            create: (BuildContext context) => RefundBloc(breezSDK),
          ),
          BlocProvider<NetworkSettingsBloc>(
            create: (BuildContext context) => NetworkSettingsBloc(
              injector.preferences,
              config,
            ),
          ),
          BlocProvider<PaymentOptionsBloc>(
            create: (BuildContext context) => PaymentOptionsBloc(
              injector.preferences,
            ),
          ),
          BlocProvider<MoonPayBloc>(
            create: (BuildContext context) => MoonPayBloc(
              breezSDK,
              injector.preferences,
            ),
          ),
          BlocProvider<BackupBloc>(create: (BuildContext context) => BackupBloc(breezSDK)),
        ],
        child: UserApp(),
      ),
    );
  }, (error, stackTrace) async {
    if (error is! FlutterErrorDetails) {
      _log.severe("FlutterError: $error", error, stackTrace);
    }
  });
}

@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
Future<void> _onBackgroundMessage(RemoteMessage message) {
  return BreezMessageHandler(message).handleBackgroundMessage();
}

@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  BackgroundTaskManager().handleBackgroundTask();
}
