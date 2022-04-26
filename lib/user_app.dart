import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/invoice/invoice_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_state.dart';
import 'package:c_breez/l10n/locales.dart';
import 'package:c_breez/models/user_profile.dart';
import 'package:c_breez/routes/dev/commands.dart';
import 'package:c_breez/routes/fiat_currencies/fiat_currency_settings.dart';
import 'package:c_breez/routes/home/theme.dart';
import 'package:c_breez/routes/qr_scan.dart';
import 'package:c_breez/utils/locale.dart';
import 'package:c_breez/widgets/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'bloc/lsp/lsp_bloc.dart';
import 'home_page.dart';
import 'routes/create_invoice/create_invoice_page.dart';
import 'routes/initial_walkthrough.dart';
import 'routes/lsp/select_lsp_page.dart';
import 'routes/splash_page.dart';
import 'theme_data.dart' as theme;
import 'package:flutter_bloc/flutter_bloc.dart';

//final routeObserver = RouteObserver();

Widget _withTheme(UserProfileSettings user, Widget child) {
  return child;
}

// ignore: must_be_immutable
class UserApp extends StatelessWidget {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey _appKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var accountBloc = context.read<AccountBloc>();
    var invoiceBloc = context.read<InvoiceBloc>();
    var userProfileBloc = context.read<UserProfileBloc>();
    var lspBloc = context.read<LSPBloc>();

    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, state) {
        UserProfileSettings user = state.profileSettings;
        theme.themeId = user.themeId;
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ));
        return BlocBuilder<AccountBloc, AccountState>(builder: (context, accState) {
          // if (accState.initial || true) {
          //   return Container();
          // }
          return MaterialApp(
            key: _appKey,
            //navigatorKey: _navigatorKey,
            title: getSystemAppLocalizations().app_name,
            theme: theme.themeMap[user.themeId],
            localizationsDelegates: localizationsDelegates(),
            supportedLocales: supportedLocales(),
            builder: (BuildContext context, Widget? child) {
              final MediaQueryData data = MediaQuery.of(context);
              return MediaQuery(
                data: data.copyWith(
                  textScaleFactor: (data.textScaleFactor >= 1.3) ? 1.3 : data.textScaleFactor,
                ),
                child: _withTheme(user, child!),
              );
            },
            initialRoute: "/",//accState.id != null ? "/" : '/splash',
            // ignore: missing_return
            onGenerateRoute: (RouteSettings settings) {
              switch (settings.name) {
                case '/intro':
                  return FadeInRoute(
                    builder: (_) => InitialWalkthroughPage(
                      userProfileBloc,
                      accountBloc,
                    ),
                    settings: settings,
                  );
                case '/splash':
                  return FadeInRoute(
                    builder: (_) => SplashPage(user),
                    settings: settings,
                  );
                case '/':
                  return FadeInRoute(
                    builder: (_) => WillPopScope(
                      onWillPop: () async {
                        //return !await _homeNavigatorKey.currentState!.maybePop();
                        return true;
                      },
                      child: Navigator(
                        //key: _homeNavigatorKey,
                        //observers: [routeObserver],
                        initialRoute: "/",
                        // ignore: missing_return
                        onGenerateRoute: (RouteSettings settings) {
                          switch (settings.name) {
                            case '/':
                              return FadeInRoute(
                                builder: (_) => Home(
                                  accountBloc,
                                  invoiceBloc,
                                  userProfileBloc,
                                  lspBloc,
                                ),
                                settings: settings,
                              );
                            case '/select_lsp':
                              return MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (_) => SelectLSPPage(lstBloc: lspBloc),
                                settings: settings,
                              );
                            case '/create_invoice':
                              return FadeInRoute(
                                builder: (_) => withBreezTheme(
                                  context,
                                  CreateInvoicePage(),
                                ),
                                settings: settings,
                              );
                            case '/fiat_currency':
                              return FadeInRoute(
                                builder: (_) => withBreezTheme(
                                  context,
                                  FiatCurrencySettings(
                                    accountBloc,
                                    userProfileBloc,
                                  ),
                                ),
                                settings: settings,
                              );
                            case '/developers':
                              return FadeInRoute(
                                builder: (_) => withBreezTheme(
                                  context,
                                  const DevelopersView(),
                                ),
                                settings: settings,
                              );
                            case '/qr_scan':
                              return MaterialPageRoute<String>(
                                fullscreenDialog: true,
                                builder: (_) => QRScan(),
                                settings: settings,
                              );
                          }
                          assert(false);
                          return null;
                        },
                      ),
                    ),
                    settings: settings,
                  );
              }
              assert(false);
              return null;
            },
          );
        });
      },
    );
  }
}
