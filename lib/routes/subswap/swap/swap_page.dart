import 'package:breez_sdk/breez_bridge.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'widgets/address_widget_placeholder.dart';
import 'widgets/deposit_widget.dart';

class SwapPage extends StatefulWidget {
  const SwapPage();

  @override
  State<StatefulWidget> createState() {
    return SwapPageState();
  }
}

class SwapPageState extends State<SwapPage> {
  final BreezBridge breezLib = ServiceInjector().breezLib;
  SwapInfo? swap;
  String? bitcoinAddress;
  String? errorMessage;

  @override
  void didChangeDependencies() {
    getBTCAddress();
    super.didChangeDependencies();
  }

  void getBTCAddress() async {
    try {
      swap = (await breezLib.receiveOnchain());
    } catch (e) {
      errorMessage = extractExceptionMessage(e);
    } finally {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final bool isLoading = swap == null && errorMessage == null;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const back_button.BackButton(),
        title: Text(texts.invoice_btc_address_title),
      ),
      body: isLoading
          ? const AddressWidgetPlaceholder()
          : SingleChildScrollView(
              child: Column(
                children: [
                  if (swap != null) ...[DepositWidget(swap!)],
                  if (errorMessage != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 50.0,
                        left: 30.0,
                        right: 30.0,
                      ),
                      child: Text(errorMessage!, textAlign: TextAlign.center),
                    ),
                  ]
                ],
              ),
            ),
      bottomNavigationBar: errorMessage != null
          ? SingleButtonBottomBar(
              text: errorMessage != null
                  ? texts.invoice_btc_address_action_retry
                  : texts.invoice_btc_address_action_close,
              onPressed: () async {
                if (errorMessage != null) {
                  getBTCAddress();
                } else {
                  Navigator.of(context).pop();
                }
              },
            )
          : const SizedBox(),
    );
  }
}
