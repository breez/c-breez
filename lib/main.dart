import 'dart:async';
import 'dart:io';

import 'package:breez_sdk/sdk.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/credential_manager.dart';
import 'package:c_breez/bloc/connectivity/connectivity_bloc.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/input/input_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/bloc/refund/refund_bloc.dart';
import 'package:c_breez/bloc/security/security_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/bloc/withdraw/withdraw_funds_bloc.dart';
import 'package:c_breez/logger.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/user_app.dart';
import 'package:c_breez/utils/date.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'bloc/network/network_settings_bloc.dart';

final _log = FimberLog("Main");

void main() async {
  // runZonedGuarded wrapper is required to log Dart errors.
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    BreezLogger();
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );
    //initializeDateFormatting(Platform.localeName, null);
    BreezDateUtils.setupLocales();
    await Firebase.initializeApp();
    var injector = ServiceInjector();
    final breezLib = injector.breezLib;
    var appDir = await getApplicationDocumentsDirectory();

    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: Directory(p.join(appDir.path, "bloc_storage")),
    );
    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<LSPBloc>(
            create: (BuildContext context) => LSPBloc(breezLib),
          ),
          BlocProvider<AccountBloc>(
            create: (BuildContext context) => AccountBloc(
              breezLib,
              CredentialsManager(keyChain: injector.keychain),
            ),
          ),
          BlocProvider<InputBloc>(
            create: (BuildContext context) => InputBloc(
              breezLib,
              injector.lightningLinks,
              injector.device,
              injector.inputParser,
            ),
          ),
          BlocProvider<UserProfileBloc>(
            create: (BuildContext context) => UserProfileBloc(injector.breezServer, injector.notifications),
          ),
          BlocProvider<CurrencyBloc>(
            create: (BuildContext context) => CurrencyBloc(breezLib),
          ),
          BlocProvider<SecurityBloc>(
            create: (BuildContext context) => SecurityBloc(),
          ),
          BlocProvider<WithdrawFundsBloc>(
            create: (BuildContext context) => WithdrawFundsBloc(breezLib),
          ),
          BlocProvider<ConnectivityBloc>(
            create: (BuildContext context) => ConnectivityBloc(),
          ),
          BlocProvider<RefundBloc>(
            create: (BuildContext context) => RefundBloc(breezLib),
          ),
          BlocProvider<NetworkSettingsBloc>(
            create: (BuildContext context) => NetworkSettingsBloc(
              injector.preferences,
            ),
          ),
        ],
        child: UserApp(),
      ),
    );
  }, (error, stackTrace) async {
    if (error is! FlutterErrorDetails) {
      _log.e("FlutterError: $error", ex: error, stacktrace: stackTrace);
    }
  });
}
