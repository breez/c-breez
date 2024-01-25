import 'dart:async';

import 'package:c_breez/bloc/input/input_bloc.dart';
import 'package:c_breez/bloc/webhooks/webhooks_bloc.dart';
import 'package:c_breez/routes/create_invoice/widgets/loading_or_error.dart';
import 'package:c_breez/routes/create_invoice/widgets/successful_payment.dart';
import 'package:c_breez/widgets/address_widget.dart';
import 'package:c_breez/widgets/transparent_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;

final _log = Logger("LnurlpayPageState");

class LightningAddressPage extends StatefulWidget {
  const LightningAddressPage();

  @override
  State<StatefulWidget> createState() {
    return LightningAddressPageState();
  }
}

class LightningAddressPageState extends State<LightningAddressPage> {
  @override
  void initState() {
    super.initState();
    final webhookBloc = context.read<WebhooksBloc>();
    webhookBloc.refreshLnurlPay();
    context.read<InputBloc>().trackPayment(null).then((value) {
      Timer(const Duration(milliseconds: 1000), () {
        if (mounted) {
          onPaymentFinished();
        }
      });
    }).catchError((e) {
      _log.warning("Failed to track payment", e);
    });
  }

  void onPaymentFinished() {
    final navigator = Navigator.of(context);
    navigator.pop();
    navigator.push(TransparentPageRoute((ctx) => const SuccessfulPaymentRoute()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WebhooksBloc, WebhooksState>(
      builder: (context, webhookState) {
        return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: const back_button.BackButton(),
              title: const Text("Receive via Lightning Address"),
            ),
            body: AnimatedCrossFade(
              firstChild: const LoadingOrError(
                error: null,
                displayErrorMessage: "",
              ),
              secondChild: webhookState.lnurlpayUrl == null
                  ? LoadingOrError(
                      displayErrorMessage: webhookState.lnurlPayError ?? "",
                    )
                  : Column(
                      children: [
                        AddressWidget(
                          webhookState.lnurlpayUrl!,
                          title: "Address Information",
                          type: AddressWidgetType.lnurl,
                        ),
                        const Padding(padding: EdgeInsets.only(top: 16.0)),
                      ],
                    ),
              duration: const Duration(seconds: 1),
              crossFadeState: webhookState.loading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            ));
      },
    );
  }
}
