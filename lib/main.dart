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

import 'package:lightning_toolkit/lightning_toolkit.dart';
import 'firebase_options.dart';

void main() async {
  // runZonedGuarded wrapper is required to log Dart errors.
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    BreezLogger();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    //initializeDateFormatting(Platform.localeName, null);
    BreezDateUtils.setupLocales();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    var injector = ServiceInjector();
    var appDir = await getApplicationDocumentsDirectory();
    final storage = await HydratedStorage.build(
        storageDirectory: Directory(p.join(appDir.path, "bloc_storge")));
    print('before getLightningToolkit:');
    var lt = getLightningToolkit();
    var s = await lt.hsmdHandle(
        hexsecret:
            "f4c8dffa2ffa5fe196766139416e3b5e1041c704f37452076256a7e1183c5f0f",
        hexmessage:
            "00170020db170105cffa843916e2990c00ee6249fc901bf5decabbe366dc373b41533fd7",
            nodeId: null, dbId: 0);
    print('hsmd result: $s');
    HydratedBlocOverrides.runZoned(
        () => runApp(MultiBlocProvider(
              providers: [
                BlocProvider<LSPBloc>(
                  create: (BuildContext context) => LSPBloc(injector.appStorage,
                      injector.breezBridge, injector.breezServer),
                ),
                BlocProvider<AccountBloc>(
                  create: (BuildContext context) => AccountBloc(
                      injector.breezBridge,
                      injector.appStorage,
                      injector.keychain,                      
                      context.read<LSPBloc>(),
                      ),
                ),                
                BlocProvider<InvoiceBloc>(
                  create: (BuildContext context) =>
                      InvoiceBloc(injector.lightningLinks, injector.device, injector.appStorage, injector.breezBridge),
                ),
                BlocProvider<UserProfileBloc>(
                  create: (BuildContext context) => UserProfileBloc(
                      injector.breezServer, injector.notifications),
                ),
                BlocProvider<CurrencyBoc>(
                  create: (BuildContext context) =>
                      CurrencyBoc(injector.breezServer),
                ),
              ],
              child: UserApp(),
            )),
        storage: storage);
  }, (error, stackTrace) async {
    if (error is! FlutterErrorDetails) {
      log.log(Level.SEVERE, error.toString() + '\n' + stackTrace.toString(),
          "FlutterError");
    }
  });
}
