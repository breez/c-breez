import 'package:c_breez/widgets/back_button.dart' as backBtn;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/account/account_bloc.dart';
import '../../bloc/invoice/invoice_bloc.dart';
import '../../bloc/lsp/lsp_bloc.dart';
import '../../bloc/user_profile/user_profile_bloc.dart';
import '../../widgets/route.dart';
import '../initial_walkthrough.dart';
import '../splash_page.dart';

class UITestPage extends StatelessWidget {
  const UITestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accountBloc = context.read<AccountBloc>();
    final invoiceBloc = context.read<InvoiceBloc>();
    final userProfileBloc = context.read<UserProfileBloc>();
    final lspBloc = context.read<LSPBloc>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("UI Test Page"),
        leading: const backBtn.BackButton(),
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
                    builder: (_) => InitialWalkthroughPage(
                      userProfileBloc,
                      accountBloc,
                    ),
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
                    builder: (_) => const SplashPage(),
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
        ],
      ),
    );
  }
}
