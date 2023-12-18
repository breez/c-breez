import 'dart:typed_data';

import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_state.dart';
import 'package:c_breez/models/user_profile.dart';
import 'package:c_breez/routes/create_invoice/qr_code_dialog.dart';
import 'package:c_breez/routes/create_invoice/widgets/successful_payment.dart';
import 'package:c_breez/routes/home/widgets/payments_filter/calendar_dialog.dart';
import 'package:c_breez/routes/initial_walkthrough/beta_warning_dialog.dart';
import 'package:c_breez/routes/initial_walkthrough/initial_walkthrough.dart';
import 'package:c_breez/routes/settings/set_admin_password.dart';
import 'package:c_breez/routes/splash/splash_page.dart';
import 'package:c_breez/routes/spontaneous_payment/spontaneous_payment_page.dart';
import 'package:c_breez/routes/withdraw/redeem_onchain_funds/confirmation_page/redeem_onchain_funds_confirmation.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:c_breez/widgets/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hex/hex.dart';
import 'package:theme_provider/theme_provider.dart';

class UITestPage extends StatelessWidget {
  const UITestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("UI Test Page"),
        leading: const back_button.BackButton(),
        actions: [
          BlocBuilder<UserProfileBloc, UserProfileState>(builder: (context, userState) {
            return _buildThemeSwitch(context, userState.profileSettings);
          })
        ],
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          Card(
            child: ListTile(
              title: const Text("InitialWalkthroughPage"),
              onTap: () {
                Navigator.of(context).push(
                  FadeInRoute(
                    builder: (_) => InitialWalkthroughPage(),
                  ),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("SplashPage"),
              onTap: () {
                Navigator.of(context).push(
                  FadeInRoute(
                    builder: (_) => const SplashPage(
                      isInitial: true,
                    ),
                  ),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("SelectLSPPage"),
              onTap: () {
                Navigator.of(context).pushNamed("/select_lsp");
              },
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("CreateInvoicePage"),
              onTap: () {
                Navigator.of(context).pushNamed("/create_invoice");
              },
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("FiatCurrencySettings"),
              onTap: () {
                Navigator.of(context).pushNamed("/fiat_currency");
              },
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("QRScan"),
              onTap: () {
                Navigator.of(context).pushNamed("/qr_scan");
              },
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("CalendarDialog"),
              onTap: () {
                showDialog(
                  useRootNavigator: false,
                  context: context,
                  builder: (_) => CalendarDialog(
                    DateTime.now().subtract(const Duration(days: 5)),
                  ),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("SuccessfulPaymentRoute"),
              onTap: () {
                Navigator.of(context).push(
                  FadeInRoute(
                    builder: (_) => const SuccessfulPaymentRoute(),
                  ),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("SpontaneousPaymentPage"),
              onTap: () {
                Navigator.of(context).push(
                  FadeInRoute(
                    builder: (_) => SpontaneousPaymentPage(
                      "123",
                      GlobalKey(debugLabel: "123"),
                    ),
                  ),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("SetAdminPasswordPage"),
              onTap: () {
                Navigator.of(context).push(
                  FadeInRoute(
                    builder: (_) => const SetAdminPasswordPage(
                      submitAction: "CREATE",
                    ),
                  ),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("BetaWarningDialog"),
              onTap: () {
                showDialog(
                  useRootNavigator: false,
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlphaWarningDialog();
                  },
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("QrCodeDialog"),
              onTap: () async {
                LNInvoice invoice = LNInvoice(
                  paymentHash: "Fake Payment Hash",
                  amountMsat: 2000000.toInt(),
                  bolt11: "Fake bolt11",
                  description: "Fake Description",
                  expiry: 60.toInt(),
                  payeePubkey: '',
                  timestamp: 0,
                  routingHints: [],
                  paymentSecret: Uint8List.fromList(
                    HEX.decode('0c56b71ef'),
                  ),
                  minFinalCltvExpiryDelta: 18,
                  network: Network.Bitcoin,
                );
                Future<ReceivePaymentResponse> response = Future.delayed(
                  const Duration(seconds: 2),
                  () => ReceivePaymentResponse(lnInvoice: invoice),
                );
                Widget dialog = FutureBuilder(
                  future: response,
                  builder: (BuildContext context, AsyncSnapshot<ReceivePaymentResponse> response) {
                    return QrCodeDialog(response.data, null, (result) {});
                  },
                );
                return showDialog(
                  useRootNavigator: false,
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => dialog,
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("RedeemOnchainConfirmationPage"),
              onTap: () {
                Navigator.of(context).push(
                  FadeInRoute(
                      builder: (_) => const RedeemOnchainConfirmationPage(
                            amountSat: 200000,
                            toAddress: "3A2DSxJraw7e2vCR1xHy3oFctLQTHhecHF",
                          )),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  GestureDetector _buildThemeSwitch(
    BuildContext context,
    UserProfileSettings user,
  ) {
    final themeData = Theme.of(context);
    return GestureDetector(
      onTap: () => ThemeProvider.controllerOf(context).nextTheme(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
              right: 16.0,
            ),
            child: Container(
              width: 64,
              padding: const EdgeInsets.all(4),
              decoration: const ShapeDecoration(
                shape: StadiumBorder(),
                color: theme.themeSwitchBgColor,
              ),
              child: Row(
                children: [
                  Image.asset(
                    "src/icon/ic_lightmode.png",
                    height: 24,
                    width: 24,
                    color: themeData.lightThemeSwitchIconColor,
                  ),
                  const SizedBox(
                    height: 20,
                    width: 8,
                    child: VerticalDivider(
                      color: Colors.white30,
                    ),
                  ),
                  ImageIcon(
                    const AssetImage("src/icon/ic_darkmode.png"),
                    color: themeData.darkThemeSwitchIconColor,
                    size: 24.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
