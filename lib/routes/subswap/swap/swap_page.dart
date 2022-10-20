import 'package:breez_sdk/breez_bridge.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:c_breez/widgets/loader.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';

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
  String? unconfirmedTxID;
  String? bitcoinAddress;
  String? errorMessage;

  @override
  void didChangeDependencies() {
    getBTCAddress();
    checkUnconfirmedTx();
    super.didChangeDependencies();
  }

  // TODO: Get bitcoin address and listen to address status changes
  void getBTCAddress() async {
    try {
      swap = (await breezLib.receiveOnchain());
      //errorMessage = "PLACEHOLDER_ERROR_STRING" ?? swap!.errorMessage;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      setState(() {});
    }
  }

  // TODO: check for unconfirmed Tx's
  void checkUnconfirmedTx() async {
    try {
      // Get SwapLiveData list using subswapService and check for redeemable tx's
      unconfirmedTxID = "PLACEHOLDER_TXID_STRING";
      // TODO: Differentiate between error types
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final bool isLoading =
        unconfirmedTxID == null && swap == null && errorMessage == null;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const back_button.BackButton(),
        title: Text(texts.invoice_btc_address_title),
      ),
      body: isLoading
          ? const Center(child: Loader())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // TODO: Move unconfirmed tx list to another page
                  if (unconfirmedTxID != null) ...[
/*                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 24),
                      child: RichText(
                        text: TextSpan(
                          text:'You have transactions waiting for confirmation. Click ',
                          children: [
                            TextSpan(
                              text: texts.invoice_btc_address_on_chain_here,
                              style: const TextStyle(color: Colors.blue),
                            ),
                            const TextSpan(text: ' to see the list.'),
                          ],
                        ),
                      ),
                    ),
                    UnconfirmedTxWidget(unconfirmedTxID: unconfirmedTxID!),*/
                  ],
                  if (swap != null) ...[DepositWidget(swap!)],
                  // TODO: Once unconfirmed tx list is moved to another page, make error message take priority over DepositWidget
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
                // TODO: Make sure the action is appropriate with error message
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
