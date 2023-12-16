import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/ext/block_builder_extensions.dart';
import 'package:c_breez/bloc/refund/refund_bloc.dart';
import 'package:c_breez/bloc/rev_swap_in_progress/rev_swap_in_progress_bloc.dart';
import 'package:c_breez/bloc/security/security_bloc.dart';
import 'package:c_breez/bloc/security/security_state.dart';
import 'package:c_breez/bloc/swap_in_progress/swap_in_progress_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_state.dart';
import 'package:c_breez/routes/buy_bitcoin/moonpay/moonpay_page.dart';
import 'package:c_breez/routes/create_invoice/create_invoice_page.dart';
import 'package:c_breez/routes/dev/developers_view.dart';
import 'package:c_breez/routes/fiat_currencies/fiat_currency_settings.dart';
import 'package:c_breez/routes/home/home_page.dart';
import 'package:c_breez/routes/initial_walkthrough/initial_walkthrough.dart';
import 'package:c_breez/routes/initial_walkthrough/mnemonics/enter_mnemonics_page.dart';
import 'package:c_breez/routes/initial_walkthrough/mnemonics/mnemonics_confirmation_page.dart';
import 'package:c_breez/routes/lsp/select_lsp_page.dart';
import 'package:c_breez/routes/network/network_page.dart';
import 'package:c_breez/routes/payment_options/payment_options_page.dart';
import 'package:c_breez/routes/qr_scan/widgets/qr_scan.dart';
import 'package:c_breez/routes/security/lock_screen.dart';
import 'package:c_breez/routes/security/secured_page.dart';
import 'package:c_breez/routes/security/security_page.dart';
import 'package:c_breez/routes/splash/splash_page.dart';
import 'package:c_breez/routes/get-refund/get_refund_page.dart';
import 'package:c_breez/routes/subswap/swap/swap_page.dart';
import 'package:c_breez/routes/withdraw/reverse_swap/reverse_swap_page.dart';
import 'package:c_breez/routes/withdraw/redeem_onchain_funds/redeem_onchain_funds_page.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/theme/breez_dark_theme.dart';
import 'package:c_breez/theme/breez_light_theme.dart';
import 'package:c_breez/widgets/route.dart';
import 'package:c_breez/widgets/transparent_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:theme_provider/theme_provider.dart';

const String THEME_ID_PREFERENCE_KEY = "themeID";

final _log = Logger("UserApp");

const _kMaxTitleTextScaleFactor = 1.3;

class UserApp extends StatelessWidget {
  final GlobalKey _appKey = GlobalKey();
  final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final RefundBloc refundBloc = context.read<RefundBloc>();

    return ThemeProvider(
      saveThemesOnChange: true,
      onInitCallback: (controller, previouslySavedThemeFuture) async {
        String? savedTheme = await previouslySavedThemeFuture;
        if (savedTheme != null) {
          controller.setTheme(savedTheme);
        } else {
          controller.setTheme('light');
          controller.forgetSavedTheme();
        }
      },
      themes: <AppTheme>[
        AppTheme(
          id: 'light',
          data: breezLightTheme,
          description: 'Blue Theme',
        ),
        AppTheme(
          id: 'dark',
          data: breezDarkTheme,
          description: 'Dark Theme',
        ),
      ],
      child: ThemeConsumer(
        child: BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, state) {
            SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
            ));
            return BlocBuilder2<AccountBloc, AccountState, SecurityBloc, SecurityState>(
                builder: (context, accState, securityState) {
              return MaterialApp(
                key: _appKey,
                title: "${getSystemAppLocalizations().app_name} Cloud",
                theme: ThemeProvider.themeOf(context).data,
                localizationsDelegates: localizationsDelegates(),
                supportedLocales: supportedLocales(),
                builder: (BuildContext context, Widget? child) {
                  return MediaQuery.withClampedTextScaling(
                    maxScaleFactor: _kMaxTitleTextScaleFactor,
                    child: child!,
                  );
                },
                initialRoute: securityState.pinStatus == PinStatus.enabled ? "lockscreen" : "splash",
                onGenerateRoute: (RouteSettings settings) {
                  _log.info("New route: ${settings.name}");
                  switch (settings.name) {
                    case '/intro':
                      return FadeInRoute(
                        builder: (_) => InitialWalkthroughPage(),
                        settings: settings,
                      );
                    case 'splash':
                      return FadeInRoute(
                        builder: (_) => SplashPage(isInitial: accState.initial),
                        settings: settings,
                      );
                    case 'lockscreen':
                      return NoTransitionRoute(
                        builder: (_) => const LockScreen(
                          authorizedAction: AuthorizedAction.launchHome,
                        ),
                        settings: settings,
                      );
                    case '/enter_mnemonics':
                      return FadeInRoute<String>(
                        builder: (_) => EnterMnemonicsPage(
                          initialWords: settings.arguments as List<String>? ?? [],
                        ),
                        settings: settings,
                      );
                    case '/':
                      return FadeInRoute(
                        builder: (_) => NavigatorPopHandler(
                          onPop: () => _homeNavigatorKey.currentState!.pop(),
                          child: Navigator(
                            initialRoute: "/",
                            key: _homeNavigatorKey,
                            onGenerateRoute: (RouteSettings settings) {
                              _log.info("New inner route: ${settings.name}");
                              switch (settings.name) {
                                case '/':
                                  return FadeInRoute(
                                    builder: (_) => const Home(),
                                    settings: settings,
                                  );
                                case '/select_lsp':
                                  return MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (_) => SelectLSPPage(),
                                    settings: settings,
                                  );
                                case '/create_invoice':
                                  return FadeInRoute(
                                    builder: (_) => const CreateInvoicePage(),
                                    settings: settings,
                                  );
                                case '/get_refund':
                                  return FadeInRoute(
                                    builder: (_) => GetRefundPage(
                                      refundBloc: refundBloc,
                                    ),
                                    settings: settings,
                                  );
                                case '/swap':
                                  return FadeInRoute(
                                    builder: (_) => BlocProvider(
                                      create: (BuildContext context) => SwapInProgressBloc(
                                        ServiceInjector().breezSDK,
                                      ),
                                      child: const SwapPage(),
                                    ),
                                    settings: settings,
                                  );
                                case '/reverse_swap':
                                  return FadeInRoute(
                                    builder: (_) => BlocProvider(
                                      create: (BuildContext context) => RevSwapsInProgressBloc(
                                        ServiceInjector().breezSDK,
                                      ),
                                      child: ReverseSwapPage(
                                        btcAddressData: settings.arguments as BitcoinAddressData?,
                                      ),
                                    ),
                                    settings: settings,
                                  );
                                case '/unexpected_funds':
                                  return FadeInRoute(
                                    builder: (_) => RedeemFundsPage(
                                      walletBalance: settings.arguments as int,
                                    ),
                                    settings: settings,
                                  );
                                case '/fiat_currency':
                                  return FadeInRoute(
                                    builder: (_) => const FiatCurrencySettings(),
                                    settings: settings,
                                  );
                                case '/security':
                                  return FadeInRoute(
                                    builder: (_) => const SecuredPage(
                                      securedWidget: SecurityPage(),
                                    ),
                                    settings: settings,
                                  );
                                case '/mnemonics':
                                  return FadeInRoute(
                                    builder: (_) => MnemonicsConfirmationPage(
                                      mnemonics: settings.arguments as String,
                                    ),
                                    settings: settings,
                                  );
                                case '/network':
                                  return FadeInRoute(
                                    builder: (_) => const NetworkPage(),
                                    settings: settings,
                                  );
                                case '/developers':
                                  return FadeInRoute(
                                    builder: (_) => const DevelopersView(),
                                    settings: settings,
                                  );
                                case '/qr_scan':
                                  return MaterialPageRoute<String>(
                                    fullscreenDialog: true,
                                    builder: (_) => QRScan(),
                                    settings: settings,
                                  );
                                case '/payment_options':
                                  return FadeInRoute(
                                    builder: (_) => const PaymentOptionsPage(),
                                    settings: settings,
                                  );
                                case '/buy_bitcoin':
                                  return TransparentPageRoute(
                                    (_) => const MoonPayPage(),
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
        ),
      ),
    );
  }
}
