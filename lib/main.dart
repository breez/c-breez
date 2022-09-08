import 'dart:async';
import 'dart:io';

import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/connectivity/connectivity_bloc.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/input/input_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/bloc/security/security_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/bloc/withdraw/withdraw_funds_bloc.dart';
import 'package:c_breez/firebase_options.dart';
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

final _log = FimberLog("Main");

void main() async {
  // runZonedGuarded wrapper is required to log Dart errors.
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    BreezLogger();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    //initializeDateFormatting(Platform.localeName, null);
    BreezDateUtils.setupLocales();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    var injector = ServiceInjector();
    final lightningServices = await injector.lightningServices;
    var appDir = await getApplicationDocumentsDirectory();

    final storage = await HydratedStorage.build(storageDirectory: Directory(p.join(appDir.path, "bloc_storage")));
    HydratedBlocOverrides.runZoned(
        () => runApp(MultiBlocProvider(
              providers: [
                BlocProvider<LSPBloc>(
                  create: (BuildContext context) => LSPBloc(lightningServices, injector.lspService),
                ),
                BlocProvider<AccountBloc>(
                  create: (BuildContext context) => AccountBloc(
                    lightningServices,
                    injector.lnurlService,                    
                    injector.keychain,
                  ),
                ),
                BlocProvider<InputBloc>(
                  create: (BuildContext context) =>
                      InputBloc(injector.lightningLinks, injector.device, lightningServices),
                ),
                BlocProvider<UserProfileBloc>(
                  create: (BuildContext context) => UserProfileBloc(injector.breezServer, injector.notifications),
                ),
                BlocProvider<CurrencyBloc>(
                  create: (BuildContext context) => CurrencyBloc(injector.fiatService),
                ),
                BlocProvider<SecurityBloc>(
                  create: (BuildContext context) => SecurityBloc(),
                ),
                BlocProvider<WithdrawFudsBloc>(
                  create: (BuildContext context) => WithdrawFudsBloc(lightningServices),
                ),
                BlocProvider<ConnectivityBloc>(
                  create: (BuildContext context) => ConnectivityBloc(),
                ),
              ],
              child: UserApp(),
            )),
        storage: storage);
  }, (error, stackTrace) async {
    if (error is! FlutterErrorDetails) {
      _log.e("FlutterError: $error", ex: error, stacktrace: stackTrace);
    }
  });
}
