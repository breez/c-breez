import 'dart:async';
import 'dart:io';

import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/invoice/invoice_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:path/path.dart' as p;
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/user_app.dart';
import 'package:c_breez/utils/date.dart';
import 'package:c_breez/logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

import 'firebase_options.dart';

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
    var appDir = await getApplicationDocumentsDirectory();
    final storage = await HydratedStorage.build(storageDirectory: Directory(p.join(appDir.path, "bloc_storge")));
    HydratedBlocOverrides.runZoned(() => runApp(MultiBlocProvider(
          providers: [
            BlocProvider<AccountBloc>(
              create: (BuildContext context) => AccountBloc(injector.breezBridge, injector.appStorage, injector.keychain),
            ),
            BlocProvider<LSPBloc>(
              create: (BuildContext context) => LSPBloc(injector.appStorage, injector.breezBridge, injector.breezServer),
            ),
            BlocProvider<InvoiceBloc>(
              create: (BuildContext context) => InvoiceBloc(injector.lightningLinks, injector.device),
            ),
            BlocProvider<UserProfileBloc>(
              create: (BuildContext context) => UserProfileBloc(injector.breezServer, injector.notifications),
            ),
            BlocProvider<CurrencyBoc>(
              create: (BuildContext context) => CurrencyBoc(injector.breezServer),
            ),
          ],
          child: UserApp(),
        )),storage: storage);
  }, (error, stackTrace) async {
    if (error is! FlutterErrorDetails) {
      log.log(Level.SEVERE, error.toString() + '\n' + stackTrace.toString(), "FlutterError");
    }
  });
}
