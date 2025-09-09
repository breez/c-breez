import 'dart:async';

import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/input/input_bloc.dart';
import 'package:c_breez/bloc/webhooks/webhooks_bloc.dart';
import 'package:c_breez/bloc/webhooks/webhooks_state.dart';
import 'package:c_breez/routes/create_invoice/widgets/successful_payment.dart';
import 'package:c_breez/routes/ln_address/ln_address_widget.dart';
import 'package:c_breez/routes/subswap/swap/widgets/address_widget_placeholder.dart';
import 'package:c_breez/routes/subswap/swap/widgets/swap_error_message.dart';
import 'package:c_breez/utils/utils.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:c_breez/widgets/transparent_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger("LnAddressPage");

class LnAddressPage extends StatefulWidget {
  const LnAddressPage();

  @override
  State<StatefulWidget> createState() {
    return LnAddressPageState();
  }
}

class LnAddressPageState extends State<LnAddressPage> {
  SwapInfo? swapInProgress;
  SwapInfo? swapUnused;
  String? bitcoinAddress;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _refreshLnurlPay();
    _trackPayment();
  }

  void _refreshLnurlPay() {
    final webhookBloc = context.read<WebhooksBloc>();
    webhookBloc.refreshLnurlPay();
  }

  void _trackPayment() {
    context
        .read<InputBloc>()
        .trackPayment(null)
        .then((value) {
          Timer(const Duration(milliseconds: 1000), () {
            if (mounted) {
              _onPaymentFinished();
            }
          });
        })
        .catchError((e) {
          _log.warning("Failed to track payment", e);
        });
  }

  void _onPaymentFinished() {
    final navigator = Navigator.of(context);
    navigator.pop();
    navigator.push(TransparentPageRoute((ctx) => const SuccessfulPaymentRoute()));
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return BlocBuilder<WebhooksBloc, WebhooksState>(
      builder: (context, webhookState) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: const back_button.BackButton(),
            title: Text(texts.invoice_ln_address_title),
          ),
          body: webhookState.isLoading
              ? const AddressWidgetPlaceholder()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      if (webhookState.lnurlPayUrl != null) LnAddressWidget(webhookState.lnurlPayUrl!),
                      if (webhookState.lnurlPayError != null) ...[
                        DepositErrorMessage(
                          errorMessage: ExceptionHandler.extractMessage(webhookState.lnurlPayError!, texts),
                        ),
                      ],
                    ],
                  ),
                ),
          bottomNavigationBar: webhookState.lnurlPayError != null
              ? SingleButtonBottomBar(
                  text: texts.invoice_ln_address_action_retry,
                  onPressed: () => _refreshLnurlPay,
                )
              : const SizedBox(),
        );
      },
    );
  }
}
